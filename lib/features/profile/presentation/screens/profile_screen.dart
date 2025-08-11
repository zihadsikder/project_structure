
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/common/widgets/universal_Image.dart';
import '../../../../core/services/Auth_service.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_texts.dart';

import '../../controller/profile_controller.dart';

import '../widgets/profile_item_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final ProfileController profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.appBarBackground,
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(80.h),

                ///  Profile Picture Section
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Obx(() {
                      if (profileController.profileImage.value != null) {
                        // Show local picked image instantly
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Image.file(
                            profileController.profileImage.value!,
                            height: 160,
                            width: 160,
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
                        // Show network image
                        return UniversalImage(
                          isCircular: true,
                          height: 160,
                          width: 160,
                          imagePath: profileController.profileDataModel.value.data?.image
                        );
                      }
                    }),

                    Positioned(
                      bottom: 15,
                      right: 10,
                      child: InkWell(
                        onTap: () {
                          profileController.pickImage(ImageSource.gallery);
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
                Obx(() {
                  if(profileController.isLoading.value) {
                    return Center(child: CircularProgressIndicator(color: AppColors.primary),);
                  } else if(profileController.profileDataModel.value.data != null || profileController.profileDataModel.value.data != null) {
                    return Column(
                      children: [
                        Container(
                          height: 120,
                          width: 120,

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
                        SizedBox(height: 10.h),
                        CustomText(
                          text:  profileController.profileDataModel.value.data?.name??'',
                          fontSize: 18.sp,
                          color: Colors.black,
                        ),
                        CustomText(
                          text:  profileController.profileDataModel.value.data?.email??'',
                          fontSize: 12.sp,
                          color: Color(0xFF636F85),

                        ),
                      ],
                    );
                  } else {
                    return Center(child: CustomText(
                      text: 'Profile Data Not Found!',
                      fontSize: 20.sp,
                      color: Color(0xFF02265D),
                    ));
                  }
                },),


                Gap(32.h),

                ProfileItemCard(
                  onTap: () {},
                  text: AppText.personalInformation.tr,
                  //icon: IconPath.person,
                ),
                Gap( 8.h),
                ProfileItemCard(
                  onTap: () {},
                  text: AppText.password.tr,
                  //icon: IconPath.lock,
                ),
                Gap( 8.h),
                Container(
                  height: 44.h,
                  width: double.infinity,
                  padding: EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notifications),
                      // Image.asset(
                      //   IconPath.notification,
                      //   height: 20.h,
                      //   width: 20.w,
                      // ),
                      Gap( 8.w),
                      CustomText(
                        text: AppText.notification.tr,
                        color: Color(0xFF6C757D),
                        fontSize: 14.sp,
                      ),
                      Spacer(),
                      Transform.scale(
                        scale: 0.8,
                        child: Obx(() => Switch(
                            padding: EdgeInsets.zero,
                            value:
                            profileController.isNotificationEnabled.value,
                            focusColor: Colors.white,
                            activeTrackColor: AppColors.textSecondary,
                            onChanged: (value) {
                              profileController.toggleNotification();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap( 8.h),
                ProfileItemCard(
                  onTap: (){},
                  text: AppText.language.tr,
                  //icon: IconPath.language,
                ),
                Gap( 8.h),
                ProfileItemCard(
                  onTap: () {}, // => Get.toNamed(AppRoute.helpAndSupportScreen),
                  text: AppText.helpSupport.tr,
                  //icon: IconPath.helpSupport,
                ),

                Gap( 8.h),
                // Delete Account
                ProfileItemCard(
                  onTap: () {

                    //showAccountDeleteDialog(context);

                    showModalBottomSheet(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.35),
                      context: context,
                      builder: (context) =>
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.delete),
                                  //Image.asset(IconPath.deleteIcon,height: 96.h,width: 96.w,),
                                  Gap(16),
                                  CustomText(text: '${AppText.deleteAccount.tr}?',fontSize: 24,fontWeight: FontWeight.w600,color: AppColors.textSecondary,),
                                  Gap(16),
                                  Row(
                                    children: [
                                      Expanded(child: CustomButton(text: 'No', onTap: ()=>Get.back(),backgroundColor: Color(0xffFFFC2C2),textColor: Colors.black,)),
                                      SizedBox(width: 20,),
                                      Expanded(child: CustomButton(text: 'Delete', onTap: (){
                                        Get.back();
                                        profileController.deleteAccount();

                                      },

                                        backgroundColor: Color(0xffF83737),textColor: Colors.white,))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                    );

                  },
                  text: AppText.deleteAccount.tr,
                  //icon: IconPath.deleteAccount,
                ),

                Gap( 8.h),
                // Sign out
                ProfileItemCard(
                  onTap: () {

                    //showLogoutOptions(context);

                    showModalBottomSheet(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.35),
                      context: context,
                      builder: (context) =>
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check),
                                  //Image.asset(IconPath.okIcon,height: 96.h,width: 96.w,),
                                  Gap(16),
                                  CustomText(text: AppText.readyToSignOut.tr,fontSize: 24,fontWeight: FontWeight.w600,color: AppColors.textSecondary,),
                                  Gap(16),
                                  Row(
                                    children: [
                                      Expanded(child: CustomButton(text: 'No', onTap: ()=>Get.back(),backgroundColor: Color(0xffF9DEBD),textColor: Colors.black,)),
                                      SizedBox(width: 20,),
                                      Expanded(child: CustomButton(text: 'Yes', onTap: ()=>AuthService.logoutUser(),backgroundColor: AppColors.primary,textColor: Colors.black,))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                    );

                  },
                  text: AppText.signOut.tr,
                  //icon: IconPath.logout,
                ),
                Gap( 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
