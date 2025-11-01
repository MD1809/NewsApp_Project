import 'package:flutter/material.dart';

import 'package:news_app_project/models/news_model.dart';
import 'package:news_app_project/utils/date_utils.dart';
import 'package:news_app_project/services/firestore_service.dart';

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
  // Kiểm tra bài viết đã được lưu chưa
  void checkIfSaved() async {
    bool saved = await ArticleService.isArticleSaved(widget.article.url);
    setState(() {
      isSaved = saved;
    });
  }

  /// Lưu hoặc xóa bài viết
  void toggleSave() async {
    if (isSaved) {
      await ArticleService.deleteArticle(widget.article.url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã bỏ lưu bài viết')),
      );
    } else {
      await ArticleService.saveArticle(widget.article);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu bài viết')),
      );
    }
    setState(() {
      isSaved = !isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. APP BAR
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
              Navigator.pop(context); // Quay lại trang trước
            },
          ),
        ),
        title: const Text(
          'Trở lại',
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
            tooltip: 'Lưu bài viết',
            onPressed: toggleSave,
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black87),
            tooltip: 'Chia sẻ',
            onPressed: () {
              // Xử lý chia sẻ bài viết
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      // 2. BODY (Nội dung chính)
      body: SingleChildScrollView(
        child: Column(
          // Căn lề các thành phần con sang bên trái
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(widget.article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(widget.article.imageUrl),
              ),
            // Phần nội dung text bên dưới ảnh
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề bài viết
                  Text(
                    widget.article.title,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: AssetImage("assets/images/xe.jpg"),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          widget.article.author,
                          style: TextStyle(fontSize: 12),
                          maxLines: 1, // chỉ hiển thị 1 dòng
                          overflow: TextOverflow
                              .ellipsis, // hiển thị "..." nếu quá dài
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.access_time, size: 14, color: Colors.black54),
                      SizedBox(width: 3),
                      Text(
                        formatPublishedTime(widget.article.publishedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16), // Khoảng cách
                  // Nội dung bài viết
                  Text(
                    widget.article.content,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
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
