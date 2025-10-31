import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String formatPublishedTime(DateTime publishedAt) {
  final now = DateTime.now();
  final difference = now.difference(publishedAt);

  if (difference.inDays < 1) {
    // Nếu trong vòng 24 giờ → hiển thị “x giờ/phút trước”
    return timeago.format(publishedAt, locale: 'vi');
  } else {
    // Nếu lâu hơn 1 ngày → hiển thị ngày cụ thể
    return DateFormat('dd/MM/yyyy').format(publishedAt);
  }
}
