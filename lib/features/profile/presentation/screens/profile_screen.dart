
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/common/widgets/universal_Image.dart';
import '../../../../core/utils/constants/app_colors.dart';

import '../../../../core/utils/constants/icon_path.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/profile_controller.dart';

import '../widgets/profile_item_card.dart';
import '../widgets/show_logout_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      // Light background for a clean look
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 36.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(40.h),
                // Reduced gap for better balance
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    UniversalImage(isCircular: true, height: 160, width: 160),
                    Positioned(
                      bottom: 15,
                      right: 10,

                      child: InkWell(
                        onTap: () {
                          profileController.pickImage(ImageSource.camera);
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                          ),
                          child: Icon(
                            Icons.image,
                            color: AppColors.textFormFieldBorder,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                CustomText(
                  text: 'Alex Jone',
                  fontSize: 26.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),

                /// Profile Picture Section
                // Obx(() {
                //   if (profileController.isLoading.value) {
                //     return Center(
                //       child: CircularProgressIndicator(color: AppColors.primary),
                //     );
                //   } else if (profileController.profileDataModel.value.data != null) {
                //     return Column(
                //       children: [
                //         Container(
                //           height: 120,
                //           width: 120,
                //           decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             border: Border.all(color: AppColors.primary, width: 2.5.w),
                //             boxShadow: [
                //               BoxShadow(
                //                 color: AppColors.textSecondary.withOpacity(0.2),
                //                 spreadRadius: 2,
                //                 blurRadius: 5,
                //                 offset: const Offset(0, 3),
                //               ),
                //             ],
                //           ),
                //           child: ClipOval(
                //             child: profileController.profileImage.value == null
                //                 ? Image.network(
                //               profileController.profileDataModel.value.data?.image ?? '',
                //               fit: BoxFit.cover,
                //               errorBuilder: (context, error, stackTrace) {
                //                 return Padding(
                //                   padding: const EdgeInsets.all(12.0),
                //                   child: Image.asset('assets/images/no-pictures.png'),
                //                 );
                //               },
                //             )
                //                 : Image.file(
                //               profileController.profileImage.value!,
                //               fit: BoxFit.cover,
                //             ),
                //           ),
                //         ),
                //         SizedBox(height: 12.h),
                //         CustomText(
                //           text: profileController.profileDataModel.value.data?.name ?? '',
                //           fontSize: 20.sp,
                //           color: AppColors.textPrimary,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         CustomText(
                //           text: profileController.profileDataModel.value.data?.email ?? '',
                //           fontSize: 14.sp,
                //           color: AppColors.textSecondary,
                //         ),
                //       ],
                //     );
                //   } else {
                //     return Center(
                //       child: CustomText(
                //         text: 'Profile Data Not Found!',
                //         fontSize: 18.sp,
                //         color: AppColors.error,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     );
                //   }
                // }),
                Gap(32.h),

                // Three Containers in a Row

                Gap(48.h),
                // Profile Items
                ProfileItemCard(
                  onTap: () {
                    Get.toNamed(AppRoute.personalInformationScreen);
                  },
                  text: 'Accounts', icon: IconPath.user, // Placeholder icon
                ),
                Gap(8.h),
                ProfileItemCard(
                  onTap: () {

                    Get.toNamed(AppRoute.changePasswordScreen);
                  },
                  text: 'Change Password',
                  icon: IconPath.email, // Placeholder icon
                ),
                Gap(18.h),
                InkWell(
                  onTap: () {
                    showLogoutOptions(context);
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(left: 12.w),
                    child: Row(
                      children: [
                        Icon(Icons.login_outlined, color: AppColors.primary),
                        CustomText(
                          text: 'Log out',
                          fontSize: 16.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),

                // Sign out
                Gap(16.h),
                // Added extra gap at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
