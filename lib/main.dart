// import 'package:flutter/material.dart';
//
// import 'package:news_app_project/screens/main_screen.dart';
//
//
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:timeago/src/messages/vi_messages.dart';
//
// import 'package:news_app_project/screens/article_detail_screen.dart';
//
// void main() {
//   timeago.setLocaleMessages('vi', ViMessages()); // kích hoạt tiếng việt.
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const MainScreen(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:news_app_project/screens/main_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/src/messages/vi_messages.dart';

// import Database class
import 'package:news_app_project/services/database.dart';

void main() async {
  // Đảm bảo Flutter đã khởi tạo trước khi dùng async
  WidgetsFlutterBinding.ensureInitialized();

  // Thiết lập tiếng Việt cho timeago
  timeago.setLocaleMessages('vi', ViMessages());

  // ✅ Xóa database cũ (reset hoàn toàn)
  await DatabaseNewsApp.instance.deleteDB();

  // Sau đó chạy app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
