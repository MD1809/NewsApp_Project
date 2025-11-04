import 'package:flutter/material.dart';

import 'package:news_app_project/widgets/category_item.dart';
import 'package:news_app_project/screens/newsByCategoryScreen.dart';
import 'package:news_app_project/services/api_service.dart';
import 'package:news_app_project/widgets/appbar.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<String> categoryNames = [
    "General",
    "Business",
    "Entertainment",
    "Health",
    "Science",
    "Sports",
    "Technology",
  ];

  final NewsApiService _getImageNewsService = NewsApiService();
  Map<String, String> categoryImages = {}; // { "Sports": "image_url", ... }
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategoryImages();
  }

  /// 🔹 Gọi API lấy ảnh cho từng category
  Future<void> loadCategoryImages() async {
    try {
      final images = await _getImageNewsService.fetchCategoryImages(
        categoryNames,
      );
      setState(() {
        categoryImages = images;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi load category images: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppbarBuild(),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              SizedBox(height: 4),
              Row(
                children: [
                  Text("News by Category", style: TextStyle(fontSize: 18)),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : categoryImages.isEmpty
                    ? const Center(child: Text('No news found for this category'))
                    : GridView.builder(
                        itemCount: categoryNames.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.5,
                            ),
                        itemBuilder: (context, index) {
                          final category = categoryNames[index];
                          final imageUrl =
                              categoryImages[category] ??
                              "https://developer.android.com/static/codelabs/basic-android-kotlin-compose-load-images/img/70e008c63a2a1139.png?hl=vi";
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      NewsByCategoryScreen(category: category),
                                ),
                              );
                            },
                            child: CategoryItem(
                              title: category,
                              imageUrl: imageUrl,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
