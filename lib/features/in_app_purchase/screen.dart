import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_sizer.dart';
import 'package:gat/features/in_app_purchase/controller.dart';
import 'package:get/get.dart';

import '../../core/common/widgets/custom_button.dart';
import '../../core/common/widgets/custom_text.dart';
import '../../core/utils/constants/app_colors.dart';

class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SubscriptionController());

    return Scaffold(
      body:Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 56.h,
          bottom: 56.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [


            Container(
              color: AppColors.backgroundLight,
              child: Obx(() {
                final isLoadingProduct = c.isProductLoading.value;
                final product = c.monthlyProduct;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CustomText(
                        text: 'Activate Your Plan',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Center(
                      child: CustomText(
                        textAlign: TextAlign.center,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                        text:
                        "Unlock full access to MST Budget Blueprint.\nTrack income, expenses, revenue and build better saving habits.",
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ---- FEATURES ----
                    _featureRow("Create personal saving accounts"),
                    _featureRow("Track daily income & expenses"),
                    _featureRow("Monthly revenue & spending analytics"),
                    _featureRow("Smart habits for money saving"),

                    SizedBox(height: 20.h),

                    // ---- PLAN CARD ----
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12.h),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(.2),
                        ),
                      ),
                      child: isLoadingProduct
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ],
                      )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Monthly Plan",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 6.h),
                          CustomText(
                            text: product?.description ??
                                "Full access for one month with auto-renew.",
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              CustomText(
                                text: product?.price ?? "--",
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              CustomText(
                                text: " / month",
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    /// ---- CTA BUTTON ----
                    Obx(() {
                      final canTap = !c.isLoading.value &&
                          !c.isProductLoading.value &&
                          product != null;

                      return CustomButton(
                        text: c.isSubscribed.value
                            ? "Already Subscribed"
                            : "Subscribe Now",
                        onTap: canTap ? c.subscribeMonthly : null,
                        child: c.isLoading.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : null,
                      );
                    }),
                    /// ---- Restore Purchases ----
                    SizedBox(height: 20.h),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          c.restoreAndCheckSubscription();
                        },
                        child: CustomText(
                          text: "Restore Purchases",
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    /// ---- Links to Privacy & Terms ----

                    SizedBox(height: 16.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                            "Subscription automatically renews unless auto-renewal is turned off at least 24 hours before the end of the current period.By subscribing you agree to our ",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Open Privacy Policy URL
                                // launchURL(
                                //   "https://privacy.moneysavingtechniques.com/",
                                // );
                              },
                          ),
                          TextSpan(
                            text: " and ",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: "Terms of Use",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Open Terms of Use (EULA) URL
                                // launchURL(
                                //   "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/",
                                // );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: AppColors.primary),
          SizedBox(width: 8.w),
          Expanded(
            child: CustomText(text: text),
          ),
        ],
      ),
    );
  }
}
