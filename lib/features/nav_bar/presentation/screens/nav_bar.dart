
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/icon_path.dart';
import '../../controllers/nav_bar_controller.dart';

class NavBar extends GetView<NavBarController> {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textSecondary,
      body: Obx(() => controller.screens[controller.currentIndex]),
      bottomNavigationBar: Container(
        color: Color(0xFFFFFFFF),
        child: Obx(
              () => BottomNavigationBar(
            currentIndex: controller.currentIndex,
            onTap: controller.changeIndex,

            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.navUnselectedColor,


            selectedLabelStyle:  GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            unselectedLabelStyle:   GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 0,
            items: [
              _buildNavItem(
                iconPath: IconPath.home, label: 'Home',

              ),
              _buildNavItem(
                iconPath: IconPath.home, label: 'Catalog',

              ),
              _buildNavItem(
                iconPath: IconPath.home, label: 'Chat',

              ),
              _buildNavItem(
                iconPath: IconPath.home, label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required String iconPath,
    required String label,

  }) {
    return BottomNavigationBarItem(
        activeIcon: SvgPicture.asset(
          iconPath,
          width: 20,
          height: 20,
          colorFilter:  ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
        icon: SvgPicture.asset(
          iconPath,
          width: 20,
          height: 20,
          colorFilter:  ColorFilter.mode(
            AppColors.navUnselectedColor,
            BlendMode.srcIn,
          ),
        ),
        label: label
    );
  }
}