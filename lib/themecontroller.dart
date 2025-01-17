import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    updateTheme();
  }

  void updateTheme() {
    final baseTheme = isDarkMode.value ? ThemeData.dark() : ThemeData.light();
    
    final updatedTheme = baseTheme.copyWith(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: isDarkMode.value ? Brightness.dark : Brightness.light,
      ),
      // Temel stil ayarları
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: TextStyle(
          color: isDarkMode.value ? Colors.white70 : Colors.black87,
        ),
        hintStyle: TextStyle(
          color: isDarkMode.value ? Colors.white60 : Colors.black54,
        ),
      ),
      // AppBar teması
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: isDarkMode.value ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkMode.value ? Colors.white : Colors.blue,
        ),
      ),
      // Diğer renk ayarları
      iconTheme: IconThemeData(
        color: isDarkMode.value ? Colors.white : Colors.blue,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: isDarkMode.value ? Colors.blue[300] : Colors.blue,
        thumbColor: isDarkMode.value ? Colors.blue[300] : Colors.blue,
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) => 
          isDarkMode.value ? Colors.blue[300] : Colors.blue
        ),
      ),
    );

    Get.changeTheme(updatedTheme);
  }

  @override
  void onInit() {
    super.onInit();
    final window = WidgetsBinding.instance.window;
    isDarkMode.value = window.platformBrightness == Brightness.dark;
    
    ever(isDarkMode, (_) => updateTheme());
    
    window.onPlatformBrightnessChanged = () {
      isDarkMode.value = window.platformBrightness == Brightness.dark;
    };

    updateTheme();
  }
} 