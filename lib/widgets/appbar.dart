import 'package:flutter/material.dart';

import 'package:news_app_project/screens/notifications_screen.dart';

class AppbarBuild extends StatefulWidget {
  const AppbarBuild({super.key});

  @override
  State<AppbarBuild> createState() => _AppbarBuildState();
}

class _AppbarBuildState extends State<AppbarBuild> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      scrolledUnderElevation: 0,
      titleSpacing: 20,
      title: RichText(
        text: TextSpan(
          text: "News ",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
          children: [
            TextSpan(
              text: "App",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: IconButton(
            icon: Icon(
              Icons.notifications_active,
              size: 28,
              color: theme.colorScheme.onBackground,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
        ),
      ],
    );
  }
}
