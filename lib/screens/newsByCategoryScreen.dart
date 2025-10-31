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
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 1,
        leading: Container(
          margin: const EdgeInsets.only(left: 0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'News ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              widget.category,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            )
          : articles.isEmpty
          ? Container(
              color: Colors.white,
              child: const Center(child: Text("Không có bài báo nào")),
            )
          : Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final news = articles[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 26.0),
                      child: ArticleFormbigCard(
                        image: news.imageUrl,
                        NameArticle: news.title,
                        publishedAt: news.publishedAt,
                        author: news.author,
                        content: news.content,
                        description: news.description,
                        urlTrending: news.url,
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
