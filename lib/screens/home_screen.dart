import 'package:flutter/material.dart';

import 'package:news_app_project/widgets/search_bar.dart';
import 'package:news_app_project/widgets/section_header.dart';
import 'package:news_app_project/widgets/article_formbig_card.dart';
import 'package:news_app_project/widgets/article_formsmall_card.dart';
import 'package:news_app_project/widgets/category_button.dart';
import 'package:news_app_project/widgets/appbar.dart';
import 'package:news_app_project/models/news_model.dart';
import 'package:news_app_project/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final NewsApiService _newsService = NewsApiService();

  Future<List<NewsArticle>>? _trendingFuture;
  Future<List<NewsArticle>>? _newsFuture;

  String? userInitial;
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
    _loadUserInitial();
    _trendingFuture = _newsService.fetchNewsTrending();
    _newsFuture = _newsService.fetchNews(selectedCategory);
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
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

  Future<void> _loadUserInitial() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        final name = snapshot['username'] ?? '';
        if (name.isNotEmpty) {
          setState(() {
            userInitial = name[0].toUpperCase();
          });
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppbarBuild(),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(child: CustomSearchBar(onSubmitted: _onSearch)),
                    if(FirebaseAuth.instance.currentUser != null) ...[
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 54,
                        height: 54,
                        child: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            userInitial ?? "?",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ]
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
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      final articles = snapshot.data!;
                      if (articles.isEmpty) {
                        return const Center(
                          child: Text("No articles found."),
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
                        child: Text("No articles found."),
                      );
                    }
                  },
                )
                    : ListView(
                  children: [
                    const SizedBox(height: 24),
                    const SectionHeader(title: "Trending"),
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
                            child: Text("Error: ${snapshot.error}"),
                          );
                        } else if (snapshot.hasData) {
                          final newsList = snapshot.data!;
                          if (newsList.isEmpty) {
                            return const Center(
                              child: Text("No articles available."),
                            );
                          }

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
                            child: Text("No articles available."),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    const SectionHeader(title: "Latest"),
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
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData) {
                          final newsList = snapshot.data!;

                          if (newsList.isEmpty) {
                            return const Center(
                              child: Text("No articles available."),
                            );
                          }

                          final limitedList = newsList.take(6).toList();

                          return ListView.builder(
                            shrinkWrap: true,
                            physics:
                            const NeverScrollableScrollPhysics(),
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
                          return const Center(
                            child: Text("No articles available."),
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
