import 'package:flutter/material.dart';

class AppbarBuild extends StatefulWidget {
  const AppbarBuild({super.key});

  @override
  State<AppbarBuild> createState() => _AppbarBuildState();
}

class _AppbarBuildState extends State<AppbarBuild> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      titleSpacing: 20,
      title: RichText(
        text: TextSpan(
          text: "News ",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.blue,
          ),
          children: [
            TextSpan(
              text: "App",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: IconButton(
            icon: Icon(Icons.notifications_active, size: 28),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
