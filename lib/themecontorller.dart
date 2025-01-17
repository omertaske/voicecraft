import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs; // Varsayılan olarak Light Mode

  void toggleTheme() {
    if (isDarkMode.value) {
      Get.changeThemeMode(ThemeMode.light); // Light Mode'a geç
    } else {
      Get.changeThemeMode(ThemeMode.dark); // Dark Mode'a geç
    }
    isDarkMode.value = !isDarkMode.value; // Durumu güncelle
  }
}
