import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/article_model.dart';
import '../services/bookmark_service.dart';

class DetailController extends GetxController {
  late ArticleModel article;

  // Instance service
  final BookmarkService _bookmarkService = BookmarkService();

  // Observable state untuk status bookmark
  final RxBool isBookmarked = false.obs;

  @override
  void onInit() {
    super.onInit();
    article = Get.arguments as ArticleModel;

    // Cek status bookmark saat controller diinisialisasi
    checkBookmarkStatus();
  }

  /// Cek apakah artikel ini sudah di-bookmark
  void checkBookmarkStatus() {
    isBookmarked.value = _bookmarkService.isBookmarked(article);
  }

  /// Fungsi untuk toggle bookmark
  Future<void> toggleBookmark() async {
    HapticFeedback.lightImpact();

    if (isBookmarked.value) {
      await _bookmarkService.removeBookmark(article);
      isBookmarked.value = false;
      Get.snackbar(
        'Berhasil',
        'Bookmark dihapus',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // Jika belum, tambahkan
      await _bookmarkService.addBookmark(article);
      isBookmarked.value = true;
      Get.snackbar(
        'Berhasil',
        'Artikel berhasil di-bookmark',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void shareArticle() {
    HapticFeedback.lightImpact();

    Get.snackbar(
      'Info',
      'Fitur share akan segera hadir',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
