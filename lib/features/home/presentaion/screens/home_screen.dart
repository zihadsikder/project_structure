import 'package:flutter/material.dart';

import 'package:gat/core/utils/constants/app_colors.dart';

import 'package:gat/features/home/controllers/home_controller.dart';

import 'package:get/get.dart';


class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text('Hello')
            ],
          ),
        ),
      ),
    );
  }

}