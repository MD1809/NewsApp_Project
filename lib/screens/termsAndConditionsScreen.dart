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
        title: const Text("Terms & Conditions"),
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
            "Last updated: October 29, 2025",
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          _buildBodyText(
            "Welcome to the \"News App.\" Please read the following terms carefully before using the app. "
                "By using this application, you agree to be bound by these Terms & Conditions.",
          ),
          const SizedBox(height: 20),

          _buildSectionTitle("1. Purpose of the Application"),
          _buildBodyText(
            "The \"News App\" provides news articles and information "
                "aggregated from reliable sources to give users a quick and convenient news reading experience. "
                "The app is intended solely for informational and entertainment purposes.",
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("2. News Sources and Content Copyright"),
          _buildBodyText(
            "News in this app may be aggregated from various sources. "
                "All content copyrights belong to the original authors and sources. "
                "We do not modify the original content except for formatting it for display. "
                "If you are the content owner and wish to request removal, please contact us via our support email.",
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("3. User Responsibilities"),
          _buildBodyText(
            "Users agree not to copy, distribute, or exploit the content in the app for commercial purposes without permission. "
                "You must not use the app for illegal activities or any action that could harm the system.",
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("4. Ownership and Licensing"),
          _buildBodyText(
            "All source code, design, and user interface of this application belong to the developer. "
                "You may only use the app for personal and non-commercial purposes.",
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("5. Disclaimer"),
          _buildBodyText(
            "We do not guarantee that all information is completely accurate or always up-to-date. "
                "The app is not responsible for any damages resulting from your use of the information provided. "
                "External links may lead to other websites whose content we do not control.",
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("6. Data Collection and Privacy"),
          _buildBodyText(
            "The app may collect certain non-personal data (such as visit frequency or usage time) "
                "to improve the user experience. Sensitive personal data will not be collected unless you voluntarily provide it. "
                "Please refer to our Privacy Policy for more details.",
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("7. Updates and Changes to Terms"),
          _buildBodyText(
            "We may modify or update these terms at any time. "
                "The new version will be published within the app and will take effect immediately upon release.",
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("8. Contact Information"),
          _buildBodyText(
            "If you have any questions or feedback about these Terms & Conditions, please contact us:\n\n"
                "Email: support@newsapp.com\nAPI provider website: https://newsapi.org",
          ),
          const SizedBox(height: 30),

          const Center(
            child: Text(
              "By continuing to use this app, you agree to these Terms & Conditions.",
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
