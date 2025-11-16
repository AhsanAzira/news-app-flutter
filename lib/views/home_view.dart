import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/home_controller.dart';
import '../controllers/theme_controller.dart'; // Import ThemeController
import '../utils/app_colors.dart'; // Dibutuhkan untuk AppColors.error
import '../utils/date_formatter.dart';
import '../routes/app_routes.dart';

/// View untuk Home Page (Menggunakan konsep MVC)
/// Menampilkan list berita dengan kategori
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dapatkan instance ThemeController
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        elevation: 0,
        actions: [
          // Tombol Toggle Tema
          Obx(
            () => IconButton(
              icon: Icon(
                themeController.isDarkMode
                    ? Icons.wb_sunny_outlined
                    : Icons.nightlight_round,
              ),
              onPressed: () {
                themeController.toggleTheme();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            // Gunakan context dari build method untuk dialog
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Get.toNamed(AppRoutes.bookmark);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category tabs
          _buildCategoryTabs(),

          // News list
          Expanded(
            child: Obx(() {
              // [PERBAIKAN] Kita tidak perlu lagi mendengarkan tema
              // atau menggunakan ValueKey di sini, karena controller
              // akan me-refresh 'articles' untuk kita.

              // Menampilkan loading indicator
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Menampilkan error message
              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: Theme.of(Get.context!).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.fetchNews,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              }

              // Menampilkan empty state
              if (controller.articles.isEmpty) {
                return _buildEmptyState();
              }

              // Menampilkan list berita
              return RefreshIndicator(
                // [PERBAIKAN] Key sudah tidak diperlukan lagi.
                onRefresh: controller.refreshNews,
                child: ListView.builder(
                  itemCount: controller.articles.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final article = controller.articles[index];
                    return _buildNewsCard(article);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Widget untuk category tabs
  Widget _buildCategoryTabs() {
    final context = Get.context!;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
        ),
      ),
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected = controller.selectedCategory.value == category;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: ChoiceChip(
                label: Text(category.toUpperCase()),
                selected: isSelected,
                onSelected: (_) => controller.changeCategory(category),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Widget untuk card berita
  Widget _buildNewsCard(article) {
    final context = Get.context!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.detail, arguments: article);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: Theme.of(context).colorScheme.surface,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: Theme.of(context).colorScheme.surface,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  if (article.description != null)
                    Text(
                      article.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),

                  // Author & Date
                  Row(
                    children: [
                      if (article.author != null) ...[
                        Icon(
                          Icons.person,
                          size: 16,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            article.author!,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormatter.formatDate(article.publishedAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk tampilan empty state yang lebih baik
  Widget _buildEmptyState() {
    final context = Get.context!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 80,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak Ada Berita',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada berita yang tersedia untuk kategori ini.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// Dialog untuk search
  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Cari Berita'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Masukkan kata kunci...',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              controller.searchNews(value);
              Get.back();
            }
          },
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                controller.searchNews(searchController.text);
                Get.back();
              }
            },
            child: const Text('Cari'),
          ),
        ],
      ),
    );
  }
}
