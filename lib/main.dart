import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_app_project/screens/main_screen.dart';
import 'services/firebase_options.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/src/messages/vi_messages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Kích hoạt tiếng Việt cho timeago
  timeago.setLocaleMessages('vi', ViMessages());

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















// import 'package:flutter/material.dart';
// import 'package:news_app_project/screens/main_screen.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:timeago/src/messages/vi_messages.dart';
//
// // import Database class
// import 'package:news_app_project/services/database.dart';

// void main() async {
//   // Đảm bảo Flutter đã khởi tạo trước khi dùng async
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Thiết lập tiếng Việt cho timeago
//   timeago.setLocaleMessages('vi', ViMessages());
//
//   // Xóa database cũ (reset hoàn toàn)
//   await DatabaseNewsApp.instance.deleteDB();
//
//   // Sau đó chạy app
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const MainScreen(),
//     );
//   }
// }
