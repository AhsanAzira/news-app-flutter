import 'package:flutter/services.dart'; // [TAMBAHAN] Import Haptic Feedback
import 'package:get/get.dart';
import '../models/article_model.dart';
import '../services/bookmark_service.dart';
import './detail_controller.dart';

class BookmarkController extends GetxController {
  final BookmarkService _bookmarkService = BookmarkService();

  final RxList<ArticleModel> bookmarks = <ArticleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  /// Memuat daftar bookmark dari service
  void loadBookmarks() {
    bookmarks.value = _bookmarkService.getBookmarks();
  }

  /// Menghapus bookmark
  Future<void> removeBookmark(ArticleModel article) async {
    // [TAMBAHAN] Getaran sedang untuk aksi 'hapus'
    HapticFeedback.mediumImpact();

    await _bookmarkService.removeBookmark(article);
    loadBookmarks(); // Muat ulang daftar setelah dihapus

    // Update status di DetailController jika sedang dibuka
    if (Get.isRegistered<DetailController>() &&
        Get.find<DetailController>().article.url == article.url) {
      Get.find<DetailController>().isBookmarked.value = false;
    }

    Get.snackbar(
      'Berhasil',
      'Bookmark telah dihapus',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
