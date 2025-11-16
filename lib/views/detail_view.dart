import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/detail_controller.dart';
import '../utils/app_colors.dart';
import '../utils/date_formatter.dart';

/// View untuk Detail Page (Menggunakan konsep MVC)
/// Menampilkan detail berita lengkap
class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar dengan image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            // [PERBAIKAN] Gunakan warna dari Tema
            backgroundColor: Theme.of(context).colorScheme.surface,
            // [PERBAIKAN] Atur warna ikon AppBar (back, dsb)
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: controller.article.urlToImage != null
                  ? CachedNetworkImage(
                      imageUrl: controller.article.urlToImage!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        // [PERBAIKAN] Gunakan warna dari Tema
                        color: Theme.of(context).colorScheme.surface,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        // [PERBAIKAN] Gunakan warna dari Tema
                        color: Theme.of(context).colorScheme.surface,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          // [PERBAIKAN] Gunakan warna dari Tema
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    )
                  : Container(
                      // [PERBAIKAN] Gunakan warna dari Tema
                      color: Theme.of(context).colorScheme.surface,
                      child: Icon(
                        Icons.article,
                        size: 100,
                        // [PERBAIKAN] Gunakan warna dari Tema
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    controller.article.title,
                    // [PERBAIKAN] Gunakan style dari Tema
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(height: 1.3),
                  ),
                  const SizedBox(height: 16),

                  // Author & Date
                  Row(
                    children: [
                      if (controller.article.author != null) ...[
                        Icon(
                          Icons.person,
                          size: 18,
                          // [PERBAIKAN] Gunakan warna dari Tema
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            controller.article.author!,
                            // [PERBAIKAN] Gunakan style dari Tema
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                        // [PERBAIKAN] Gunakan warna dari Tema
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormatter.formatFullDate(
                          controller.article.publishedAt,
                        ),
                        // [PERBAIKAN] Gunakan style dari Tema
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // Description
                  if (controller.article.description != null) ...[
                    Text(
                      controller.article.description!,
                      // [PERBAIKAN] Gunakan style dari Tema
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Content
                  if (controller.article.content != null) ...[
                    Text(
                      controller.article.content!,
                      // [PERBAIKAN] Gunakan style dari Tema
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Source URL
                  if (controller.article.url != null) ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.link,
                          size: 18,
                          // [PERBAIKAN] Gunakan warna dari Tema
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Sumber: ${controller.article.url}',
                            style: TextStyle(
                              fontSize: 14,
                              // [PERBAIKAN] Gunakan warna dari Tema
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        context: context, // [PERBAIKAN] Kirim context
                        icon: Icons.share,
                        label: 'Share',
                        onTap: controller.shareArticle,
                      ),
                      Obx(
                        () => _buildActionButton(
                          context: context, // [PERBAIKAN] Kirim context
                          icon: controller.isBookmarked.value
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          label: controller.isBookmarked.value
                              ? 'Saved'
                              : 'Bookmark',
                          onTap: controller
                              .toggleBookmark, // Panggil fungsi toggle
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk action button
  Widget _buildActionButton({
    required BuildContext context, // [PERBAIKAN] Terima context
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          // [PERBAIKAN] Gunakan warna dari Tema
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // [PERBAIKAN] Gunakan warna dari Tema
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                // [PERBAIKAN] Gunakan warna dari Tema
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
