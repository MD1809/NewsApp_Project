import 'package:flutter/material.dart';

import 'package:news_app_project/models/news_model.dart';
import 'package:news_app_project/utils/date_utils.dart';
import 'package:news_app_project/screens/article_detail_screen.dart';

class ArticleFormsmallCard extends StatelessWidget {
  final String image;
  final String title;
  final String content;
  final String description;
  final String authorName;
  final DateTime publishedAt;
  final String url;

  const ArticleFormsmallCard({
    super.key,
    required this.image,
    required this.title,
    required this.content,
    required this.description,
    required this.authorName,
    required this.publishedAt,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Tạo đối tượng NewsArticle
        final articledetail = NewsArticle(
          title: title,
          content: content,
          imageUrl: image,
          author: authorName,
          publishedAt: publishedAt,
          description: description,
          url: url,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Articledetailscreen(article: articledetail),
          ),
        );
      },
      child: Card(
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  image,
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 68,
                      height: 68,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Text(
                      content,
                      style: TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Icon(Icons.access_time, size: 14, color: Colors.black54),
                        SizedBox(width: 3),
                        Text(
                          formatPublishedTime(publishedAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
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