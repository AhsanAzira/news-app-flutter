import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

/// Service untuk mengelola penyimpanan tema (light/dark mode)
class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  /// Menyimpan mode tema
  Future<void> saveThemeMode(bool isDarkMode) async {
    await _box.write(_key, isDarkMode);
  }

  /// Membaca mode tema
  /// Defaultnya adalah false (light mode) jika belum ada data
  bool _isDarkMode() {
    return _box.read(_key) ?? false;
  }

  /// Mendapatkan ThemeMode yang sedang aktif
  ThemeMode getThemeMode() {
    return _isDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }
}
