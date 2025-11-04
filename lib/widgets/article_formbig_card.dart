import 'package:flutter/material.dart';
import 'package:news_app_project/utils/date_utils.dart';
import 'package:news_app_project/models/news_model.dart';
import 'package:news_app_project/screens/article_detail_screen.dart';

class ArticleFormbigCard extends StatelessWidget {
  final String image;
  final String NameArticle;
  final DateTime publishedAt;
  final String author;
  final String content;
  final String url;
  final String description;

  final double? widthArticle;

  const ArticleFormbigCard({
    super.key,
    required this.image,
    required this.NameArticle,
    required this.publishedAt,
    required this.author,
    required this.content,
    required this.description,
    required this.url,
    this.widthArticle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final articledetail = NewsArticle(
          title: NameArticle,
          content: content,
          imageUrl: image,
          author: author,
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
      child: Container(
        width: widthArticle ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Theme.of(context).cardColor,
                      child: Icon(
                        Icons.broken_image,
                        color: Theme.of(context).iconTheme.color,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          NameArticle,
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Theme.of(
                          context,
                        ).iconTheme.color?.withOpacity(0.6),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        formatPublishedTime(publishedAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall?.color?.withOpacity(0.7),
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
    );
  }
}
