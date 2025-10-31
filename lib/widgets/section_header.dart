import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {

  final String title;

  const SectionHeader({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          "See All",
          style: TextStyle(color: Colors.blue, fontSize: 14),
        ),
      ],
    );
  }
}
