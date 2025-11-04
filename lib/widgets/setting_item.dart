import 'package:flutter/material.dart';

class buildSettingItem extends StatelessWidget {

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const buildSettingItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: theme.iconTheme.color,),
        title: Text(text, style: theme.textTheme.bodyMedium,),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.iconTheme.color,),
        onTap: onTap,
      ),
    );
  }
}
