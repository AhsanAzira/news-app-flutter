import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/bookmark_controller.dart';
import '../models/article_model.dart';
import '../routes/app_routes.dart';
import '../utils/app_colors.dart';
import '../utils/date_formatter.dart';

class BookmarkView extends GetView<BookmarkController> {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        // [PERBAIKAN] Hapus backgroundColor agar mengambil dari Tema
        // backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        if (controller.bookmarks.isEmpty) {
          // [PERBAIKAN] Gunakan style dari Tema
          return Center(
            child: Text(
              'Anda belum memiliki bookmark',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.bookmarks.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final article = controller.bookmarks[index];
            return Dismissible(
              key: Key(article.url!),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                controller.removeBookmark(article);
              },
              background: Container(
                // [PERBAIKAN] Gunakan warna dari Tema
                color: Theme.of(context).colorScheme.error,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.delete,
                  // [PERBAIKAN] Gunakan warna dari Tema
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
              child: _buildBookmarkCard(article, context),
            );
          },
        );
      }),
    );
  }

  Widget _buildBookmarkCard(ArticleModel article, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      // [PERBAIKAN] Hapus properti yang sudah diatur di CardTheme
      // elevation: 2,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.detail, arguments: article);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // [TAMBAHAN] Placeholder dan Error
                  placeholder: (context, url) => Container(
                    height: 180,
                    color: Theme.of(context).colorScheme.surface,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 180,
                    color: Theme.of(context).colorScheme.surface,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    // [PERBAIKAN] Gunakan style dari Tema
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    DateFormatter.formatDate(article.publishedAt),
                    // [PERBAIKAN] Gunakan style dari Tema
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
