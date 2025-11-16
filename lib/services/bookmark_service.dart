import 'package:get_storage/get_storage.dart';
import '../models/article_model.dart';

/// Service untuk mengelola data bookmark menggunakan GetStorage
class BookmarkService {
  final _box = GetStorage();
  final String _bookmarkKey = 'bookmarks';

  /// Mendapatkan semua bookmark
  List<ArticleModel> getBookmarks() {
    final List<dynamic>? data = _box.read<List<dynamic>>(_bookmarkKey);
    if (data == null) {
      return [];
    }
    return data
        .map((item) => ArticleModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Menyimpan daftar bookmark
  Future<void> _saveBookmarks(List<ArticleModel> articles) async {
    final List<Map<String, dynamic>> data = articles
        .map((article) => article.toJson())
        .toList();
    await _box.write(_bookmarkKey, data);
  }

  /// Menambah bookmark
  Future<void> addBookmark(ArticleModel article) async {
    final List<ArticleModel> bookmarks = getBookmarks();
    // Cek agar tidak duplikat berdasarkan URL
    if (!bookmarks.any((item) => item.url == article.url)) {
      bookmarks.add(article);
      await _saveBookmarks(bookmarks);
    }
  }

  /// Menghapus bookmark
  Future<void> removeBookmark(ArticleModel article) async {
    final List<ArticleModel> bookmarks = getBookmarks();
    bookmarks.removeWhere((item) => item.url == article.url);
    await _saveBookmarks(bookmarks);
  }

  /// Cek apakah artikel sudah di-bookmark
  bool isBookmarked(ArticleModel article) {
    final List<ArticleModel> bookmarks = getBookmarks();
    return bookmarks.any((item) => item.url == article.url);
  }
}
