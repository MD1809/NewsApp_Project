import 'package:flutter/material.dart';
import 'package:news_app_project/models/news_model.dart';
import 'package:news_app_project/services/database.dart';
import 'package:news_app_project/widgets/article_formsmall_card.dart';
import 'package:news_app_project/widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<NewsArticle> savedArticles = [];
  bool isLoading = true;

  // Hàm hash URL để trùng khớp với ArticleService
  String _safeId(String url) => sha1.convert(utf8.encode(url)).toString();

  @override
  void initState() {
    super.initState();
    loadSavedArticles();
  }

  /// Hàm load bài viết đã lưu
  Future<void> loadSavedArticles() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_articles')
          .orderBy('savedAt', descending: true)
          .get();

      final articles = snapshot.docs.map((doc) {
        final data = doc.data();

        // Xử lý kiểu publishedAt (Timestamp hoặc String)
        DateTime publishedAt;
        final publishedField = data['publishedAt'];
        if (publishedField is Timestamp) {
          publishedAt = publishedField.toDate();
        } else if (publishedField is String) {
          publishedAt = DateTime.tryParse(publishedField) ?? DateTime.now();
        } else {
          publishedAt = DateTime.now();
        }

        return NewsArticle(
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          content: data['content'] ?? '',
          url: data['url'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          author: data['author'] ?? '',
          publishedAt: publishedAt,
        );
      }).toList();

      setState(() {
        savedArticles = articles;
        isLoading = false;
      });
    } else {
      // 🔹 Nếu chưa đăng nhập → Lấy từ SQLite
      final articles = await DatabaseNewsApp.instance.getSavedArticles();
      setState(() {
        savedArticles = articles;
        isLoading = false;
      });
    }
  }

  /// Hàm xoá bài viết
  Future<void> deleteArticle(String url) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // 🔹 Xoá bài viết trên Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_articles')
          .doc(_safeId(url))
          .delete();
    } else {
      // Xoá bài viết cục bộ (SQLite)
      await DatabaseNewsApp.instance.deleteArticleByUrl(url);
    }

    // Load lại danh sách
    await loadSavedArticles();
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
                  Text("Saved Articles", style: TextStyle(fontSize: 18)),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: savedArticles.isEmpty
                    ? const Center(
                        child: Text("No saved articles yet."),
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
