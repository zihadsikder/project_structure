
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../core/services/Auth_service.dart';
import '../../../core/common/widgets/app_snackber.dart';
import '../../../routes/app_routes.dart';


class RoleSelectionController extends GetxController {
  var selectedRole = ''.obs;

  void selectRole(String role) {
    selectedRole.value = role;
    AuthService.saveRole(role);
  }

  bool isSelected(String role) {
    return selectedRole.value == role;
  }

  void proceedToSignup() {
    if (selectedRole.value.isNotEmpty) {
      if (kDebugMode) {
        print("Proceeding to SignUp with role: ${selectedRole.value}");
      }
      Get.toNamed(AppRoute.signUpScreen, arguments: {"role": selectedRole.value});
    } else {
      AppSnackBar.error(

     "Please select a role before proceeding.",
      );
    }
  }


}