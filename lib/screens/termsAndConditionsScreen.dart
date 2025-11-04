import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        scrolledUnderElevation: 0,
        title: Text(
          "Terms & Conditions",
          style: TextStyle(color: colorScheme.onBackground),
        ),
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

  Text _sectionTitle(BuildContext context, String text) => Text(
    text,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onBackground,
      height: 2,
    ),
  );

  Text _bodyText(BuildContext context, String text) => Text(
    text,
    style: TextStyle(
      fontSize: 14,
      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.85),
      height: 1.6,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Last updated: October 29, 2025",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: colorScheme.onBackground.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),

        _bodyText(
          context,
          "Welcome to the \"News App.\" Please read the following"
              " terms carefully before using the app. "
          "By using this application, you agree to be bound by"
              " these Terms & Conditions.",
        ),
        const SizedBox(height: 20),

        _sectionTitle(context, "1. Purpose of the Application"),
        _bodyText(
          context,
          "The \"News App\" provides news articles and"
              " information aggregated from reliable sources "
          "to give users a quick and convenient news reading experience. "
          "The app is intended solely for"
              " informational and entertainment purposes.",
        ),
        const SizedBox(height: 16),

        _sectionTitle(context, "2. News Sources and Content Copyright"),
        _bodyText(
          context,
          "News in this app may be aggregated from various sources. "
          "All content copyrights belong to the original authors. "
          "We do not modify original content except for formatting. "
          "If you are the content owner and wish to request removal,"
              " contact us via support email.",
        ),
        const SizedBox(height: 16),

        _sectionTitle(context, "3. User Responsibilities"),
        _bodyText(
          context,
          "Users agree not to copy, distribute,"
              " or exploit the content for commercial purposes. "
          "You must not use the app for illegal activities or"
              " actions that may harm the system.",
        ),
        const SizedBox(height: 16),

        _sectionTitle(context, "4. Ownership and Licensing"),
        _bodyText(
          context,
          "All source code, design, and user "
              "interface belong to the developer. "
          "You may only use the app for"
              " personal and non-commercial purposes.",
        ),
        const SizedBox(height: 16),

        _sectionTitle(context, "5. Disclaimer"),
        _bodyText(
          context,
          "We do not guarantee that all information is completely"
              " accurate or always up-to-date. "
          "We are not responsible for any damages"
              " resulting from use of the app. "
          "External links may lead to websites we do not control.",
        ),
        const SizedBox(height: 16),

        _sectionTitle(context, "6. Data Collection and Privacy"),
        _bodyText(
          context,
          "The app may collect non-personal data to improve user experience. "
          "Sensitive data will not be collected without your consent. "
          "See our Privacy Policy for details.",
        ),
        const SizedBox(height: 16),

        _sectionTitle(context, "7. Updates and Changes to Terms"),
        _bodyText(
          context,
          "We may modify these terms at any time. "
          "Updated versions will take effect immediately upon release.",
        ),
        const SizedBox(height: 16),

        _sectionTitle(context, "8. Contact Information"),
        _bodyText(
          context,
          "If you have any questions, please contact us:\n\n"
          "Email: support@newsapp.com\n"
          "News API provider: https://newsapi.org",
        ),
        const SizedBox(height: 30),

        Center(
          child: Text(
            "By continuing to use this app, "
                "you agree to these Terms & Conditions.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 15,
              color: colorScheme.onBackground.withOpacity(0.7),
              height: 1.8,
            ),
          ),
        ),
      ],
    );
  }
}
