import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../core/common/widgets/app_loader.dart';
import '../../../core/common/widgets/app_snackber.dart';
import '../../../core/common/widgets/app_toast.dart';

import '../../../core/common/widgets/loading_widgets.dart';
import '../../../core/services/Auth_service.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../../../core/utils/logging/logger.dart';
import '../model/profile_model.dart';

class ProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final inProgress = false.obs;
  RxString imagePath = ''.obs;
  // Observable for selected image
  final Rx<File?> profileImage = Rx<File?>(null);

  // Observable for notification state
  final RxBool isNotificationEnabled = true.obs;

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    getProfileData().then((_) {
      if (profileDataModel.value.data != null) {
        nameController.text = profileDataModel.value.data?.name ?? '';
        phoneNumberController.text =
            profileDataModel.value.data?.phoneNumber ?? '';
        addressController.text = profileDataModel.value.data?.location ?? '';
      }
    });
    _loadNotificationState();
  }

  /// Method to pick an image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
        imagePath.value = pickedFile.path; // Store path for update
        await updateAccount(); // Instantly update profile
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }


  /// Method to toggle notification state
  void toggleNotification() async {
    isNotificationEnabled.value = !isNotificationEnabled.value;
    // Save the new state to shared preferences
    await _saveNotificationState();
  }

  // Load notification state from shared preferences
  Future<void> _loadNotificationState() async {
    final prefs = await SharedPreferences.getInstance();
    isNotificationEnabled.value =
        prefs.getBool('isNotificationEnabled') ?? true;
  }

  // Save notification state to shared preferences
  Future<void> _saveNotificationState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationEnabled', isNotificationEnabled.value);
  }

  /// Get Profile Data
  final isLoading = false.obs;
  var profileDataModel = ProfileModel().obs;

  Future<void> getProfileData() async {
    isLoading.value = true;
    try {
      final response = await NetworkCaller().getRequest(
        AppUrls.getUserProfile,
        token: 'Bearer ${AuthService.token}',
      );
      if (response.isSuccess && response.responseData != null) {
        profileDataModel.value = ProfileModel.fromJson(response.responseData);
      } else {
        log('Failed to fetch courses: ${response.statusCode}');
        AppLoggerHelper.error(
          'Failed to fetch courses: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Error fetching course data: $e');
      AppLoggerHelper.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Updated Profile Data Method

  Future<void> updateAccount() async {
    try {
      LoadingWidget();
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(AppUrls.updateProfile),
      );
      request.headers['Authorization'] = 'Bearer ${AuthService.token}';
      request.headers['Accept'] = 'application/json';

      final profileData = <String, dynamic>{};
      if (nameController.text.trim().isNotEmpty) {
        profileData['name'] = nameController.text.trim();
      }
      if (addressController.text.trim().isNotEmpty) {
        profileData['location'] = addressController.text.trim();
      }
      if (phoneNumberController.text.trim().isNotEmpty) {
        profileData['phoneNumber'] = phoneNumberController.text.trim();
      }

      if (profileData.isNotEmpty) {
        request.fields['bodyData'] = jsonEncode(profileData);
      }

      if (profileImage.value != null) {
        var file = profileImage.value!;
        if (await file.exists()) {
          var stream = http.ByteStream(file.openRead());
          var length = await file.length();
          var multipartFile = http.MultipartFile(
            'profileImage',
            stream,
            length,
            filename: file.path,
          );
          request.files.add(multipartFile);
        } else {
          AppToasts.errorToast(
            message: 'Selected image file is invalid or inaccessible',
            toastGravity: ToastGravity.CENTER,
          );
          return;
        }
      }

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);
      var responseBody = jsonDecode(responseData.body);

      if (response.statusCode == 200) {
        AppToasts.successToast(
          message: 'Profile updated successfully',
          toastGravity: ToastGravity.CENTER,
        );
        AppLoggerHelper.debug(
          'Profile Information Update Successfully: $responseData',
        );
        await getProfileData();
      } else {
        log('Failed to update profile info: ${response.statusCode}');
        AppLoggerHelper.error('Failed to update profile info: $responseBody');
        AppToasts.errorToast(
          message: responseBody['message'] ?? 'Failed to update profile',
          toastGravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      AppLoggerHelper.error(e.toString());
      AppToasts.errorToast(
        message: e.toString(),
        toastGravity: ToastGravity.CENTER,
      );
    } finally {
      HideLoadingWidget();
    }
  }

  /// update profile another formdata method
  // Future<void> updateAccount() async {
  //   inProgress.value = true;
  //
  //   Map<String, dynamic> requestBody = {
  //     "name": nameController.text.trim(),
  //     //"email": emailController.text.trim(),
  //     "phoneNumber": phoneNumberController.text.trim(),
  //     // "country":selectedCountry.value,
  //     // "countryCode": selectedCode.value,
  //   };
  //
  //   try {
  //     Get.dialog(
  //       Center(
  //         child:AppLoader(),
  //       ),
  //       barrierDismissible: false,
  //     );
  //
  //     await _sendRequestWithHeadersAndImages(
  //       AppUrls.updateProfile,
  //       requestBody,
  //       imagePath.value.isNotEmpty ? imagePath.value : null,
  //       AuthService.token != null ? "Bearer ${AuthService.token}" : "",
  //     );
  //
  //     await getProfileData();
  //
  //   } catch (e) {
  //     log('Update profile error: $e');
  //     AppSnackBar.error(
  //       'Profile update failed. Please try again.',
  //     );
  //   } finally {
  //     inProgress.value = false;
  //     if (Get.isDialogOpen ?? false) Get.back();
  //   }
  // }
  //
  // Future<void> _sendRequestWithHeadersAndImages(
  //     String url,
  //     Map<String, dynamic> body,
  //     String? imagePath,
  //     String? token,
  //     ) async {
  //   try {
  //     var request = http.MultipartRequest('PUT', Uri.parse(url));
  //     request.headers['Authorization'] = '$token';
  //     request.fields['bodyData'] = jsonEncode(body);
  //
  //     if (imagePath != null && imagePath.isNotEmpty) {
  //       request.files.add(await http.MultipartFile.fromPath('profileImage', imagePath));
  //     }
  //
  //     log('Sending request to $url with data: $body');
  //
  //     var response = await request.send();
  //
  //     // Always close any loading dialog immediately after response
  //     if (Get.isDialogOpen ?? false) {
  //       Get.back();
  //     }
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       AppSnackBar.success(
  //
  //         'Profile updated successfully.',
  //
  //       );
  //       await getProfileData(); // refresh profile data after success
  //
  //       // Clear local picked image so UI shows updated network image
  //       profileImage.value = null;
  //       this.imagePath.value = '';
  //
  //     } else {
  //       var errorResponse = await response.stream.bytesToString();
  //       log('Update failed: $errorResponse');
  //       AppSnackBar.error(
  //
  //         'Failed to update profile.',
  //       );
  //
  //     }
  //   } catch (e) {
  //     if (Get.isDialogOpen ?? false) {
  //       Get.back();
  //     }
  //     log('Multipart request error: $e');
  //     AppSnackBar.error('Error updating profile. Please try again.');
  //   }
  // }
  /// delete account
  Future<void> deleteAccount() async {
    try {
      LoadingWidget();
      final response = await NetworkCaller().deleteRequest(
        AppUrls.deleteUserProfile,
        'Bearer ${AuthService.token}',
      );
      if (response.isSuccess) {
        HideLoadingWidget();
        AppToasts.successToast(
          message: 'Your account deleted successfully.',
          toastGravity: ToastGravity.TOP,
        );
        //Get.offAll(()=>LoginScreen());
      } else {
        HideLoadingWidget();
        AppToasts.errorToast(
          message: response.responseData['message'],
          toastGravity: ToastGravity.TOP,
        );
        AppLoggerHelper.error(
          'Failed to delete account: ${response.statusCode}',
        );
      }
    } catch (e) {
      HideLoadingWidget();
      AppToasts.errorToast(
        message: e.toString(),
        toastGravity: ToastGravity.TOP,
      );
      AppLoggerHelper.error(e.toString());
    } finally {
      HideLoadingWidget();
    }
  }

  ///
  @override
  void onClose() {
    nameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
