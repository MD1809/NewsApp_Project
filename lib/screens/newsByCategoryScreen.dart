import 'package:flutter/material.dart';

import 'package:news_app_project/services/api_service.dart';
import 'package:news_app_project/widgets/article_formbig_card.dart';

class NewsByCategoryScreen extends StatefulWidget {
  final String category;

  const NewsByCategoryScreen({super.key, required this.category});

  @override
  State<NewsByCategoryScreen> createState() => _NewsByCategoryScreenState();
}

class _NewsByCategoryScreenState extends State<NewsByCategoryScreen> {
  final NewsApiService _newsService = NewsApiService();

  List<dynamic> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  Future<void> loadNews() async {
    try {
      final data = await _newsService.fetchNews(widget.category);
      setState(() {
        articles = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,

      appBar: AppBar(
        backgroundColor: colorScheme.background,
        surfaceTintColor: colorScheme.background,
        elevation: 1,
        scrolledUnderElevation: 0,

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'News ',
              style: TextStyle(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              widget.category,
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      )
          : articles.isEmpty
          ? Center(
        child: Text(
          "No articles found!",
          style: TextStyle(color: colorScheme.onBackground),
        ),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 10.0),
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final news = articles[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 26.0),
              child: ArticleFormbigCard(
                image: news.imageUrl,
                NameArticle: news.title,
                publishedAt: news.publishedAt,
                author: news.author,
                content: news.content,
                description: news.description,
                url: news.url,
              ),
            );
          },
        ),
      ),
    );
  }
}
