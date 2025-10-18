
import 'package:flutter/material.dart';
import 'package:gat/core/utils/constants/app_sizer.dart';
import 'package:get/get.dart';

class ViewImageScreen extends StatelessWidget {
  final String? imageUrl;

  const ViewImageScreen({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back_outlined),
                ),
              ),
              SizedBox(height: 80.h),
              imageUrl?.isNotEmpty == true
                  ? Image.network(
                imageUrl!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/images/no_image.jpg",
                  fit: BoxFit.contain,
                ),
              )
                  : Image.asset(
                "assets/images/no_image.jpg",
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}