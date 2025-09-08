import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  RxString selectedLanguage = 'en'.obs;
  RxString language = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }

  Future<void> saveLanguage(String langCode) async {
    try {
      // Validate langCode
      if (!['en', 'es'].contains(langCode)) {
        log('Invalid language code: $langCode');
        return;
      }

      // Update variables
      language.value = langCode;
      selectedLanguage.value = langCode;

      // Log the change
      log('Saving language: $langCode');

      // Update app locale
      Get.updateLocale(Locale(langCode));

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', langCode);
    } catch (e) {
      log('Error saving language: $e');
    }
  }

  Future<void> loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLang = prefs.getString('selected_language') ?? 'en';

      // Update variables
      language.value = savedLang;
      selectedLanguage.value = savedLang;

      // Update locale
      Get.updateLocale(Locale(savedLang));
      log('Loaded language: $savedLang');
    } catch (e) {
      log('Error loading language: $e');
    }
  }

  // Helper to get display name for UI
  String getLanguageDisplayName() {
    return selectedLanguage.value == 'en' ? 'English' : 'Spanish';
  }
}