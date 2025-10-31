import 'package:flutter/material.dart';
import 'package:news_app_project/models/news_model.dart';
import 'package:news_app_project/services/database.dart';
import 'package:news_app_project/widgets/article_formsmall_card.dart';
import 'package:news_app_project/widgets/appbar.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<NewsArticle> savedArticles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSavedArticles();
  }

  Future<void> loadSavedArticles() async {
    final articles = await DatabaseNewsApp.instance.getSavedArticles();
    setState(() {
      savedArticles = articles;
      isLoading = false;
    });
  }

  Future<void> deleteArticle(String url) async {
    await DatabaseNewsApp.instance.deleteArticleByUrl(url);
    loadSavedArticles(); // load lại danh sách sau khi xoá
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppbarBuild(),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Text("Các bài đã lưu", style: TextStyle(fontSize: 18)),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: savedArticles.isEmpty
                    ? const Center(
                        child: Text("Chưa có bài viết nào được lưu."),
                      )
                    : ListView.builder(
                        itemCount: savedArticles.length,
                        itemBuilder: (context, index) {
                          final article = savedArticles[index];
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
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
