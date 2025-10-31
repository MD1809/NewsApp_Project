
class NewsArticle {
  final String title;
  final String description;
  final String content;
  final String url;
  final String imageUrl;
  final String author;
  final DateTime publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.imageUrl,
    required this.author,
    required this.publishedAt,
  });

  // Chuyển từ JSON sang đối tượng Dart
  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No title',
      description: json['description'] ?? 'No description',
      content: json['content'] ?? 'No content',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      author: json['author'] ?? 'No author',
      publishedAt: DateTime.parse(json['publishedAt']),
    );
  }

  // Chuyển sang Map (để lưu SQLite)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'url': url,
      'imageUrl': imageUrl,
      'author': author,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  // Tạo từ Map (đọc từ SQLite)
  factory NewsArticle.fromMap(Map<String, dynamic> mapArticle) {
    return NewsArticle(
      title: mapArticle['title'],
      description: mapArticle['description'],
      content: mapArticle['content'],
      url: mapArticle['url'],
      imageUrl: mapArticle['imageUrl'],
      author: mapArticle['author'],
      publishedAt: DateTime.parse(mapArticle['publishedAt']),
    );
  }
}
