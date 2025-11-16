import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'routes/app_pages.dart';
// Import baru
import 'controllers/theme_controller.dart';
import 'utils/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // [PERUBAHAN] Inisialisasi ThemeController secara global
  // Get.put() membuatnya tersedia di seluruh aplikasi
  Get.put(ThemeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // [PERUBAHAN] Dapatkan instance ThemeController
    final ThemeController themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      title: 'News App - MVC GetX',
      debugShowCheckedModeBanner: false,

      // [PERUBAHAN] Konfigurasi tema menggunakan AppThemes dan ThemeController
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeController.themeMode.value, // Set mode awal
      // GetX routing configuration
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,

      // Default transitions
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
