import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SingUpController extends GetxController{

  final nameText = TextEditingController();
  final businessNameText = TextEditingController();
  final emailText = TextEditingController();
  final phoneText = TextEditingController();
  final passwordText = TextEditingController();

  final isNewPasswordHidden = true.obs;
  final RxBool obSecureText = true.obs;

  void togglePasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }


}