import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction,
      SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }

  @override
  void updatedTransactions({
    required SKPaymentQueueWrapper paymentQueue,
    required List<SKPaymentTransactionWrapper> transactions,
  }) {}

  @override
  void removedTransactions({
    required SKPaymentQueueWrapper paymentQueue,
    required List<SKPaymentTransactionWrapper> transactions,
  }) {}

  @override
  void paymentQueueRestoreCompletedTransactionsFinished({
    required SKPaymentQueueWrapper paymentQueue,
  }) {}

  @override
  void paymentQueueRestoreCompletedTransactionsFailedWithError({
    required SKPaymentQueueWrapper paymentQueue,
    required SKError error,
  }) {}

  @override
  void shouldAddStorePayment({
    required SKPaymentQueueWrapper paymentQueue,
    required SKPaymentWrapper payment,
    required String forProductIdentifier,
  }) {}
}
