
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_sizer.dart';
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
                  ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => Image.asset(
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