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
    setState(() {
      isSaved = saved;
    });
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
    setState(() {
      isSaved = !isSaved;
    });
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: -10,
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
        title: const Text(
          'Back',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
            tooltip: 'Save article',
            onPressed: toggleSave,
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black87),
            tooltip: 'Share',
            onPressed: () {
              // 🔹 Handle article sharing
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(widget.article.imageUrl),
              ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.article.title,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.blueAccent,
                        child: widget.article.author.isNotEmpty
                            ? Text(
                          widget.article.author[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            : const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          widget.article.author,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time,
                          size: 14, color: Colors.black54),
                      const SizedBox(width: 3),
                      Text(
                        formatPublishedTime(widget.article.publishedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.article.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Container(
                    child: ElevatedButton(
                      onPressed: _openArticleUrl,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'Read More',
                        style: TextStyle(
                          color: Colors.white,
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
