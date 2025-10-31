import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const Text("Điều khoản & Điều kiện"),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: TermsContent(),
      ),
    );
  }
}

class TermsContent extends StatelessWidget {
  const TermsContent({super.key});

  Text _buildSectionTitle(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
      height: 2,
    ),
  );

  Text _buildBodyText(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      color: Colors.black87,
      height: 1.6,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cập nhật lần cuối: 29/10/2025",
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          _buildBodyText(
            "Chào mừng bạn đến với ứng dụng đọc tin tức \"News app.\" "
                "Vui lòng đọc kỹ các điều khoản dưới đây trước khi sử dụng. "
                "Bằng việc sử dụng ứng dụng, bạn đồng ý bị ràng buộc bởi các điều khoản này.",
          ),
          const SizedBox(height: 20),

          _buildSectionTitle("1. Mục đích của Ứng dụng"),
          _buildBodyText(
            "Ứng dụng \"News app\" cung cấp các bản tin, bài viết và thông tin "
                "được tổng hợp từ nhiều nguồn đáng tin cậy, nhằm mang đến cho người dùng trải nghiệm đọc tin tức nhanh chóng và tiện lợi. "
                "Ứng dụng chỉ phục vụ mục đích thông tin và giải trí.",
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("2. Nguồn tin và bản quyền nội dung"),
          _buildBodyText(
            "Tin tức trong ứng dụng có thể được tổng hợp từ nhiều nguồn khác nhau. "
                "Mọi bản quyền nội dung thuộc về tác giả và nguồn tin gốc. "
                "Chúng tôi không chỉnh sửa nội dung gốc ngoài việc định dạng lại để hiển thị. "
                "Nếu bạn là chủ sở hữu nội dung và muốn yêu cầu gỡ bỏ, vui lòng liên hệ qua email hỗ trợ.",
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("3. Trách nhiệm của người dùng"),
          _buildBodyText(
            "Người dùng cam kết không sao chép, phân phối hoặc khai thác nội dung trong ứng dụng cho mục đích thương mại nếu không được phép. "
                "Không được sử dụng ứng dụng cho các hoạt động vi phạm pháp luật hoặc gây hại đến hệ thống.",
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("4. Quyền sở hữu và cấp phép"),
          _buildBodyText(
            "Toàn bộ mã nguồn, thiết kế và giao diện của ứng dụng thuộc quyền sở hữu của \" Cá nhân nhà phát triển\". "
                "Bạn chỉ được sử dụng ứng dụng cho mục đích cá nhân, phi thương mại.",
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("5. Miễn trừ trách nhiệm"),
          _buildBodyText(
            "Chúng tôi không đảm bảo mọi thông tin đều chính xác hoặc luôn được cập nhật kịp thời. "
                "Ứng dụng không chịu trách nhiệm cho thiệt hại phát sinh từ việc bạn sử dụng thông tin trong ứng dụng. "
                "Các liên kết ngoài có thể dẫn tới trang web khác mà chúng tôi không kiểm soát nội dung.",
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("6. Thu thập dữ liệu và quyền riêng tư"),
          _buildBodyText(
            "Ứng dụng có thể thu thập một số thông tin phi cá nhân (như lượt truy cập, thời gian sử dụng) "
                "nhằm cải thiện trải nghiệm người dùng. Không thu thập thông tin nhạy cảm trừ khi bạn tự nguyện cung cấp. "
                "Vui lòng xem thêm Chính sách Bảo mật để biết chi tiết.",
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("7. Cập nhật và thay đổi điều khoản"),
          _buildBodyText(
            "Chúng tôi có thể thay đổi hoặc cập nhật các điều khoản này bất kỳ lúc nào. "
                "Phiên bản mới sẽ được công bố trong ứng dụng và có hiệu lực ngay khi được đăng tải.",
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("8. Liên hệ"),
          _buildBodyText(
            "Nếu bạn có thắc mắc hoặc góp ý về Điều khoản & Điều kiện, vui lòng liên hệ:\n\n"
                "📧 Email: support@newsapp.com\n🌐 Website cung cấp api: https://newsapi.org",
          ),
          const SizedBox(height: 30),

          const Center(
            child: Text(
              "Bằng việc tiếp tục sử dụng ứng dụng, bạn đồng ý với các điều khoản trên.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 15,
                color: Colors.grey,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
