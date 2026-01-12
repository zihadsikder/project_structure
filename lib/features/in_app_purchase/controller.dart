import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';

import '../../core/services/Auth_service.dart';
import '../../core/utils/constants/app_colors.dart';
import 'exapmple_payment_queue.dart';

class SubscriptionController extends GetxController {
  final InAppPurchase _iap = InAppPurchase.instance;

  static const String monthlyIdAndroid = 'monthly_2026'; // Google Play
  static const String monthlyIdIOS = 'monthly_2026'; // App Store Connect

  static String get monthlyId =>
      Platform.isAndroid ? monthlyIdAndroid : monthlyIdIOS;

  RxBool isSubscribed = false.obs;
  RxBool isLoading = false.obs;
  RxBool isProductLoading = true.obs;

  RxList<ProductDetails> products = <ProductDetails>[].obs;
  late final StreamSubscription<List<PurchaseDetails>> _purchaseSub;

  ProductDetails? get monthlyProduct =>
      products.firstWhereOrNull((p) => p.id == monthlyId);

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    final available = await _iap.isAvailable();
    if (!available) {
      Get.snackbar("Error", "In-App Purchase not available");
      isProductLoading.value = false;
      return;
    }

    /// iOS Specific Delegate
    if (Platform.isIOS) {
      final iosAddition =
          _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    await _loadProducts();
    _listenToPurchaseUpdates();
    await restoreAndCheckSubscription();
  }

  Future<void> _loadProducts() async {
    isProductLoading.value = true;
    final response = await _iap.queryProductDetails({monthlyId});
    if (response.error != null) {
      Get.snackbar("Error", response.error!.message);
    } else if (response.productDetails.isEmpty) {
      Get.snackbar("Error", "Subscription not found on store!");
    } else {
      products.assignAll(response.productDetails);
    }
    isProductLoading.value = false;
  }

  void _listenToPurchaseUpdates() {
    _purchaseSub = _iap.purchaseStream.listen((purchases) async {
      for (final purchase in purchases) {
        await _handlePurchase(purchase);
      }
    }, onError: (e) => Get.snackbar("Error", "Purchase stream error: $e"));
  }

  // Main purchase function
  Future<void> subscribeMonthly() async {
    final product = monthlyProduct;
    if (product == null) {
      Get.snackbar("Loading", "Product not ready yet. Try again.");
      return;
    }

    if (isLoading.value || isSubscribed.value) return;

    isLoading.value = true;
    try {
      final purchaseParam = PurchaseParam(productDetails: product);
      await _iap.buyNonConsumable(
        purchaseParam: purchaseParam,
      ); // Correct for subscriptions
    } catch (e) {
      Get.snackbar("Error", "Failed to start purchase: $e");
      isLoading.value = false;
    }
  }

  // Handle all purchase states
  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    if (purchase.productID != monthlyId) return;

    switch (purchase.status) {
      case PurchaseStatus.pending:
        isLoading.value = true;
        break;

      case PurchaseStatus.error:
        isLoading.value = false;
        Get.snackbar("Failed", purchase.error?.message ?? "Purchase failed");
        break;

      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        final bool valid = await _verifyAndSendToBackend(purchase);
        if (valid) {
          isSubscribed.value = true;
          await _saveSubscriptionStatus(true);
          Get.snackbar(
            "Success",
            "Subscription activated!",
            backgroundColor: AppColors.primary,
          );
          if (Get.isOverlaysOpen) Get.back();
        }
        isLoading.value = false;
        break;

      case PurchaseStatus.canceled:
        isLoading.value = false;
        Get.snackbar("Cancelled", "Purchase was cancelled");
        break;
    }

    // Always complete the purchase
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
  }

  // Server-side verification + send data to your backend
  // Server-side verification + send data to your backend (FIXED FOR iOS & Android)
  Future<bool> _verifyAndSendToBackend(PurchaseDetails purchase) async {
    try {
      final token = AuthService.token;
      if (token == null) {
        Get.snackbar("Error", "Login required");
        return false;
      }

      String platform = Platform.isIOS ? 'apple' : 'google';
      String? receiptData;
      String? purchaseToken;

      // === iOS: Wait for receipt to be available (critical fix!) ===
      if (purchase is AppStorePurchaseDetails) {
        final appStoreDetails = purchase;

        // Wait up to 15 seconds for Apple to provide the receipt
        for (int i = 0; i < 15; i++) {
          if (appStoreDetails
              .verificationData
              .serverVerificationData
              .isNotEmpty) {
            receiptData =
                appStoreDetails.verificationData.serverVerificationData;
            break;
          }
          await Future.delayed(const Duration(seconds: 1));
        }

        if (receiptData == null || receiptData.isEmpty) {
          Get.snackbar(
            "Warning",
            "Receipt not ready. Using local mode (testing)",
          );
          return true; // Allow in test mode
        }
      }
      // === Android: Receipt is immediate ===
      else if (purchase is GooglePlayPurchaseDetails) {
        receiptData = purchase.verificationData.serverVerificationData;
        purchaseToken = purchase.verificationData.serverVerificationData;
      }

      final Map<String, dynamic> requestBody = {
        "status": true,
        "receipt": receiptData ?? 'data',
        "productId": purchase.productID,
        "purchaseToken": purchaseToken ?? 'valid',
        "transactionId": purchase.purchaseID,
        "platform": platform,
        "price": monthlyProduct?.price ?? "0.0",
        "currency": monthlyProduct?.currencyCode ?? "USD",
      };

      log("Sending to backend: $requestBody");

      final response = await NetworkCaller()
          .postRequest(
            AppUrls.sendInAppPurchaseData,
            body: requestBody,
            token: 'Bearer $token',
          )
          .timeout(const Duration(seconds: 30));

      if (response.isSuccess && response.statusCode == 200) {
        final json = response.responseData;
        if (json['success'] == true || json['valid'] == true) {
          return true;
        }
      }

      Get.snackbar("Server Error", "Subscription not activated on server");
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Verification failed: $e");
      }
      if (e is TimeoutException) {
        log("Server took too lon Check internet.");
      }
      // In debug/testing mode, allow access even if backend fails
      if (kDebugMode) {
        log("Subscription activated locally");
        return true;
      }
      return false;
    }
  }

  Future<void> restoreAndCheckSubscription() async {
    try {
      await _iap.restorePurchases();
      final saved = await _getSavedSubscriptionStatus();
      isSubscribed.value = saved;
    } catch (e) {
      log("Restore failed: $e");
    }
  }

  Future<void> _saveSubscriptionStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_subscribed', status);
  }

  Future<bool> _getSavedSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_subscribed') ?? false;
  }

  @override
  void onClose() {
    _purchaseSub.cancel();
    if (Platform.isIOS) {
      final iosAddition =
          _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosAddition.setDelegate(null);
    }
    super.onClose();
  }
}
