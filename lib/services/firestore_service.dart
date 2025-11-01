import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app_project/services/database.dart';
import 'package:news_app_project/models/news_model.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class ArticleService {
  static String _safeId(String url) =>
      sha1.convert(utf8.encode(url)).toString();

  /// Lưu bài viết (chưa đăng nhập: Sqflite, đã đăng nhập: Firestore)
  static Future<void> saveArticle(NewsArticle article) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Nếu đã đăng nhập, đồng bộ bài viết cục bộ trước
      await _syncLocalArticlesToFirestore(user.uid);

      // Lưu bài viết trực tiếp lên Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_articles')
          .doc(_safeId(article.url))
          .set({
            ...article.toFirestore(),
            'savedAt': FieldValue.serverTimestamp(),
          });
    } else {
      await DatabaseNewsApp.instance.insertArticle(article);
    }
  }

  /// Đồng bộ các bài viết từ Sqflite lên Firestore khi user đăng nhập
  static Future<void> _syncLocalArticlesToFirestore(String userId) async {
    final localArticles = await DatabaseNewsApp.instance.getSavedArticles();

    for (var article in localArticles) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('saved_articles')
          .doc(_safeId(article.url))
          .set({
            ...article.toFirestore(),
            'savedAt': FieldValue.serverTimestamp(),
          });

      // Xoá bài cục bộ sau khi đồng bộ
      await DatabaseNewsApp.instance.deleteArticleByUrl(article.url);
    }
  }

  /// Gọi hàm này ngay sau khi user đăng nhập
  static Future<void> syncLocalOnLogin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _syncLocalArticlesToFirestore(user.uid);
    }
  }

  /// Kiểm tra bài viết đã lưu chưa
  static Future<bool> isArticleSaved(String url) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_articles')
          .doc(_safeId(url))
          .get();
      return doc.exists;
    } else {
      return await DatabaseNewsApp.instance.isSaved(url);
    }
  }

  /// Xóa bài viết
  static Future<void> deleteArticle(String url) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('saved_articles')
          .doc(_safeId(url))
          .delete();
    } else {
      await DatabaseNewsApp.instance.deleteArticleByUrl(url);
    }
  }
}
