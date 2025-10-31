import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:news_app_project/models/news_model.dart';

class NewsApiService {
  // =======================
  // api key
  // =======================
  final String apiKey = "859796dcbc8b4b53a6edd33f45aaf1c9";


  // =======================
  // api lấy các bài báo top trending
  // =======================
  Future<List<NewsArticle>> fetchNewsTrending() async {
    final String url = "https://newsapi.org/v2/top-headlines?language=en&country=us&apiKey=$apiKey";


    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> dataTrending = jsonDecode(response.body);

      if (dataTrending['status'] == 'ok') {
        final List<dynamic> articlesJson = dataTrending['articles'];
        return articlesJson
            .map((json) => NewsArticle.fromJson(json))
            .toList();
      }else {
        throw Exception(dataTrending['message'] ?? 'Lỗi không xác định từ API');
      }
    } else {
      throw Exception('Không thể tải tin tức (Status code: ${response.statusCode})');
    }
  }


  // =======================
  // api lấy các bài báo theo thể loại
  // =======================
  Future<List<NewsArticle>> fetchNews(String selectedCategory) async {

    String categoryParam = selectedCategory == "All" ? "" : "&category=${selectedCategory.toLowerCase()}";

    final String url = "https://newsapi.org/v2/top-headlines?"
        "language=en&"
        "country=us"
        "$categoryParam"
        "&apiKey=$apiKey";


    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] == 'ok') {
        final List<dynamic> articlesJson = data['articles'];
        return articlesJson
            .map((json) => NewsArticle.fromJson(json))
            .toList();
      }else {
        throw Exception(data['message'] ?? 'Lỗi không xác định từ API');
      }
    } else {
      throw Exception('Không thể tải tin tức (Status code: ${response.statusCode})');
    }
  }

  // =======================
  // api lấy ảnh cho category item
  // =======================
  Future<Map<String, String>> fetchCategoryImages(List<String> categories) async {
    final Map<String, String> result = {};

    // Gọi tuần tự (có thể cải tiến dùng Future.wait)
    for (var category in categories) {
      try {
        final url = Uri.parse(
          "https://newsapi.org/v2/top-headlines?country=us&language=en&category=${category.toLowerCase()}&pageSize=1&apiKey=$apiKey",
        );

        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List articles = data["articles"];
          if (articles.isNotEmpty && articles.first["urlToImage"] != null) {
            result[category] = articles.first["urlToImage"];
          } else {
            result[category] = "assets/images/xe.jpg";
          }
        } else {
          result[category] = "assets/images/xe.jpg";
        }
      } catch (e) {
        print("Lỗi khi tải ảnh cho $category: $e");
        result[category] = "assets/images/xe.jpg";
      }
    }

    return result;
  }
}
