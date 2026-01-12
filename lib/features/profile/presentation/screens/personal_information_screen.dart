import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gat/core/common/widgets/custom_text_field.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/localization/app_texts.dart';
import '../../../../core/utils/constants/app_colors.dart';

import '../../../../core/utils/validators/app_validator.dart';
import '../../controller/profile_controller.dart';


class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
                  child: Center(
                    child: Column(
                      children: [

                        /// Profile Pick
                        Obx(() => Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                    Container(
                    height: 96,
                    width: 96,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5.w),
                    ),
                    child: ClipOval(
                      child: profileController.profileImage.value == null
                          ? Image.network(
                        profileController.profileDataModel.value.data?.image ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset('assets/images/no-pictures.png'),
                          );
                        },
                      ) : Image.file(
                        profileController.profileImage.value!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                            Positioned(
                              top: 68.h,
                              left: 60.w,
                              child: GestureDetector(
                                onTap: () {
                                  // Show dialog to choose between gallery and camera
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) =>
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomText(text: 'Add Picture', fontSize: 18.sp, fontWeight: FontWeight.w500,),
                                              Gap(30.h),
                                              InkWell(
                                                onTap: () {
                                                  profileController.pickImage(ImageSource.gallery);
                                                  Get.back();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 1.3, color: AppColors.textFormFieldBorder),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.photo_library,
                                                        color: AppColors.appBarBackground,
                                                      ),
                                                      Gap(15.w),
                                                      CustomText(
                                                        text: 'Gallery',
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Gap(10.h),
                                              InkWell(
                                                onTap: () {
                                                  profileController.pickImage(ImageSource.camera);
                                                  Get.back();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 1.3, color: AppColors.textFormFieldBorder),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.photo_library,
                                                        color: AppColors.appBarBackground,
                                                      ),
                                                      Gap(15.w),
                                                      CustomText(
                                                        text: 'Camera',
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                  );
                                },
                                child: Container(
                                  height: 30.h,
                                  width: 30.w,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: AppColors.white,
                                  ),
                                  child: const Icon(Icons.edit),
                                ),
                              ),
                            ),
                          ],
                        )),

                        Gap(50.h),

                        Align(
                          alignment: Alignment.topLeft,
                          child: CustomText(
                            text: AppText.fullName.tr,
                            fontSize: 16.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        CustomTextField(
                          controller: profileController.nameController,
                          hintText: AppText.fullName.tr,
                          prefixIconPath: Icon(Icons.person_outline_rounded, size: 22.sp),

                          fillColor: Colors.white,
                        ),
                        Gap(10),
                        // Align(
                        //   alignment: Alignment.topLeft,
                        //   child: CustomText(
                        //     text: AppText.email.tr,
                        //     fontSize: 16.sp,
                        //     color: AppColors.textPrimary,
                        //   ),
                        // ),
                        // CustomTextFormField(
                        //   controller: profileController.emailController,
                        //   hintText: AppText.email.tr,
                        //   prefixIcon: Icon(Icons.email_outlined, size: 22.sp),
                        //   validator: (value) => AppValidator.validateEmail(value),
                        //   fillColor: Colors.white,
                        // ),
                        //
                        // Gap(10),
                        Align(
                          alignment: Alignment.topLeft,
                          child: CustomText(
                            text: AppText.phoneNumber.tr,
                            fontSize: 16.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        CustomTextField(
                          controller: profileController.phoneNumberController,
                          hintText: AppText.phoneNumber.tr,
                          prefixIconPath: Icon(Icons.phone_outlined, size: 22.sp),
                          validator: (value) => AppValidator.validatePhoneNumber(value),
                          fillColor: Colors.white,
                        ),

                        Gap(10),
                        Align(
                          alignment: Alignment.topLeft,
                          child: CustomText(
                            text: AppText.address.tr,
                            fontSize: 16.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        CustomTextField(
                          controller: profileController.addressController,
                          hintText: AppText.address.tr,
                          prefixIconPath: Icon(Icons.location_on_outlined, size: 22.sp),
                          //validator: (value) => AppValidator.validateTextField(value, AppText.address),
                          fillColor: Colors.white,
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            // This will stick to the bottom
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
              child: CustomButton(
                text: 'Update',
                onTap: () {
                  profileController.updateAccount();
                }, //  => Get.toNamed(AppRoute.completeProfileScreen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}