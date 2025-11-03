import 'package:flutter/material.dart';

import 'package:news_app_project/widgets/search_bar.dart';
import 'package:news_app_project/widgets/section_header.dart';
import 'package:news_app_project/widgets/article_formbig_card.dart';
import 'package:news_app_project/widgets/article_formsmall_card.dart';
import 'package:news_app_project/widgets/category_button.dart';
import 'package:news_app_project/widgets/appbar.dart';

import 'package:news_app_project/models/news_model.dart';
import 'package:news_app_project/services/api_service.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  // Tạo một đối tượng service
  final NewsApiService _newsService = NewsApiService();

  Future<List<NewsArticle>>? _trendingFuture;
  Future<List<NewsArticle>>? _newsFuture;

  String _searchQuery = "";
  Future<List<NewsArticle>>? _searchFuture;

  String selectedCategory = "All";
  final List<String> categories = [
    "All",
    "Business",
    "Sports",
    "Health",
    "Technology",
  ];

  @override
  void initState() {
    super.initState();
    // Gọi API khi khởi tạo màn hình
    _trendingFuture = _newsService.fetchNewsTrending();
    _newsFuture = _newsService.fetchNews(selectedCategory);
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      // gọi lại API khi thay đổi
      _newsFuture = _newsService.fetchNews(category);
    });
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.trim();
      if (_searchQuery.isNotEmpty) {
        _searchFuture = _newsService.searchNews(_searchQuery);
      } else {
        _searchFuture = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppbarBuild(),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(child: CustomSearchBar(onSubmitted: _onSearch)),
                    const SizedBox(width: 20),
                    const SizedBox(
                      width: 54,
                      height: 54,
                      child: CircleAvatar(
                        backgroundColor: Colors.deepPurpleAccent,
                        child: Text(
                          "D",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _searchQuery.isNotEmpty
                    ? FutureBuilder<List<NewsArticle>>(
                        future: _searchFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Lỗi: ${snapshot.error}'),
                            );
                          } else if (snapshot.hasData) {
                            final articles = snapshot.data!;
                            if (articles.isEmpty) {
                              return const Center(
                                child: Text("Không có bài viết."),
                              );
                            }
                            return ListView.builder(
                              itemCount: articles.length,
                              itemBuilder: (context, index) {
                                final article = articles[index];
                                return ArticleFormsmallCard(
                                  image: article.imageUrl,
                                  title: article.title,
                                  content: article.content,
                                  authorName: article.author,
                                  publishedAt: article.publishedAt,
                                  description: article.description,
                                  url: article.url,
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: Text("Không có bài viết."),
                            );
                          }
                        },
                      )
                    : ListView(
                        children: [
                          const SizedBox(height: 24),
                          SectionHeader(title: "Trending"),
                          const SizedBox(height: 16),
                          FutureBuilder<List<NewsArticle>>(
                            future: _trendingFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text("Lỗi: ${snapshot.error}"),
                                );
                              } else if (snapshot.hasData) {
                                final newsList = snapshot.data!;
                                if (newsList.isEmpty) {
                                  return const Center(
                                    child: Text("Không có bài viết."),
                                  );
                                }

                                // Lấy tối đa 8 bài
                                final trendingList = newsList.take(4).toList();

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: trendingList.map((article) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 18,
                                        ),
                                        child: ArticleFormbigCard(
                                          widthArticle: 320.0,
                                          image: article.imageUrl,
                                          NameArticle: article.title,
                                          publishedAt: article.publishedAt,
                                          author: article.author,
                                          content: article.content,
                                          description: article.description,
                                          url: article.url,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Text("Không có bài viết."),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 30),
                          SectionHeader(title: "Latest"),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: categories.map((category) {
                                return CategoryButton(
                                  text: category,
                                  isSelected: selectedCategory == category,
                                  onTap: () => onCategorySelected(category),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FutureBuilder<List<NewsArticle>>(
                            future: _newsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // Khi đang tải dữ liệu
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                // Nếu có lỗi
                                return Center(
                                  child: Text('Lỗi: ${snapshot.error}'),
                                );
                              } else if (snapshot.hasData) {
                                final newsList = snapshot.data!;

                                if (newsList.isEmpty) {
                                  return const Center(
                                    child: Text("Không có bài viết."),
                                  );
                                }
                                // Lấy 10 bài đầu tiên
                                final limitedList = newsList.take(6).toList();

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: limitedList.length,
                                  itemBuilder: (context, index) {
                                    final article = limitedList[index];
                                    return ArticleFormsmallCard(
                                      image: article.imageUrl,
                                      title: article.title,
                                      content: article.content,
                                      authorName: article.author,
                                      publishedAt: article.publishedAt,
                                      description: article.description,
                                      url: article.url,
                                    );
                                  },
                                );
                              } else {
                                // Không có dữ liệu
                                return const Center(
                                  child: Text("Không có bài viết."),
                                );
                              }
                            },
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
