import 'package:flutter/material.dart';
import 'package:news_app_project/models/news_model.dart';
import 'package:news_app_project/utils/date_utils.dart';
import 'package:news_app_project/services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';

class Articledetailscreen extends StatefulWidget {
  final NewsArticle article;

  const Articledetailscreen({
    super.key,
    required this.article,
  });

  @override
  State<Articledetailscreen> createState() => _ArticledetailscreenState();
}

class _ArticledetailscreenState extends State<Articledetailscreen> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    checkIfSaved();
  }

  void checkIfSaved() async {
    bool saved = await ArticleService.isArticleSaved(widget.article.url);
    setState(() => isSaved = saved);
  }

  void toggleSave() async {
    if (isSaved) {
      await ArticleService.deleteArticle(widget.article.url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from saved articles')),
      );
    } else {
      await ArticleService.saveArticle(widget.article);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article saved')),
      );
    }
    setState(() => isSaved = !isSaved);
  }

  Future<void> _openArticleUrl() async {
    final String? link = widget.article.url;

    if (link == null || link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the article link')),
      );
      return;
    }

    try {
      final Uri url = Uri.parse(link);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the article link')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
        scrolledUnderElevation: 0,
        elevation: 1,
        titleSpacing: -10,

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          'Back',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: colorScheme.primary,
            ),
            onPressed: toggleSave,
          ),
          IconButton(
            icon: Icon(Icons.share, color: colorScheme.onBackground),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.article.imageUrl.isNotEmpty)
              Image.network(widget.article.imageUrl),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Title
                  Text(
                    widget.article.title,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ✅ Author + Time
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: colorScheme.primary,
                        child: widget.article.author.isNotEmpty
                            ? Text(
                          widget.article.author[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            : Icon(Icons.person,
                            color: Colors.white, size: 14),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          widget.article.author,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onBackground,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.access_time,
                          size: 14, color: colorScheme.onBackground),
                      const SizedBox(width: 3),
                      Text(
                        formatPublishedTime(widget.article.publishedAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),


                  Text(
                    widget.article.content,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: colorScheme.onBackground,
                    ),
                  ),

                  const SizedBox(height: 60),


                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _openArticleUrl,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Read More',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
