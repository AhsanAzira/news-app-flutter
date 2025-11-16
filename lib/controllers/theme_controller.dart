import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/theme_service.dart';

/// Controller global untuk mengelola state tema
class ThemeController extends GetxController {
  final ThemeService _themeService = ThemeService();

  // Variabel reaktif untuk menyimpan ThemeMode saat ini
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  // Getter untuk mengecek apakah sedang dark mode
  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    // Load tema yang tersimpan saat controller diinisialisasi
    themeMode.value = _themeService.getThemeMode();
  }

  /// Fungsi untuk mengganti tema
  void toggleTheme() {
    // Tentukan tema baru
    final newThemeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;

    // Perbarui state reaktif
    themeMode.value = newThemeMode;

    // Simpan preferensi baru ke GetStorage
    _themeService.saveThemeMode(newThemeMode == ThemeMode.dark);

    // Terapkan perubahan tema ke GetMaterialApp
    Get.changeThemeMode(newThemeMode);
  }
}
