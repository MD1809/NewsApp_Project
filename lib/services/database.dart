import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:news_app_project/models/news_model.dart';

class DatabaseNewsApp {
  static final DatabaseNewsApp instance = DatabaseNewsApp._init();
  static Database? _database;

  DatabaseNewsApp._init();

  // Getter lấy database (nếu chưa có thì khởi tạo)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('databaseNewsApp.db');
    return _database!;
  }

  // Hàm khởi tạo DB (tạo file lưu trong máy)
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // Thư mục mặc định của SQLite
    final path = join(dbPath, filePath); // Nối đường dẫn đến file articles.db

    // Mở (hoặc tạo mới) database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Chỉ chạy 1 lần duy nhất khi DB mới được tạo
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE articlesSaved (
        url TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        content TEXT,
        imageUrl TEXT,
        author TEXT,
        publishedAt TEXT,
        created_at TEXT
      )
    ''');
  }

  // lưu bài viết vào cơ sở dữ liệu
  Future<void> insertArticle(NewsArticle article) async {
    final db = await instance.database;
    await db.insert(
      'articlesSaved',
      {
        'url': article.url,
        'title': article.title,
        'description': article.description,
        'content': article.content,
        'imageUrl': article.imageUrl,
        'author': article.author,
        'publishedAt': article.publishedAt.toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // lấy danh sách các bài đã lưu (mới nhất ở trên cùng)
  Future<List<NewsArticle>> getSavedArticles() async {
    final db = await instance.database;
    final result = await db.query(
      'articlesSaved',
      orderBy: 'created_at DESC', // Sắp xếp giảm dần theo thời gian lưu
    );

    return result.map((row) {
      return NewsArticle(
        title: row['title'] as String,
        description: row['description'] as String,
        content: row['content'] as String,
        url: row['url'] as String,
        imageUrl: row['imageUrl'] as String,
        author: row['author'] as String,
        publishedAt: DateTime.parse(row['publishedAt'] as String),
      );
    }).toList();
  }


  // xóa 1 bài viết đã lưu theo id
  Future<void> deleteArticleByUrl(String url) async {
    final db = await instance.database;
    await db.delete(
      'articlesSaved',
      where: 'url = ?',
      whereArgs: [url],
    );
  }

  // Kiểm tra xem bài viết đã được lưu chưa
  Future<bool> isSaved(String url) async {
    final db = await instance.database;
    final result = await db.query('articlesSaved', where: 'url = ?', whereArgs: [url]);
    return result.isNotEmpty;
  }

  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'databaseNewsApp.db');

    // Đóng kết nối trước khi xóa để tránh lỗi
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    await deleteDatabase(path);
    print('✅ Database đã được xóa: $path');
  }
}
