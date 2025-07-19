import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{

  final phoneText = TextEditingController();
  final passwordText = TextEditingController();

  final isNewPasswordHidden = true.obs;
  final RxBool obSecureText = true.obs;

  void togglePasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

}