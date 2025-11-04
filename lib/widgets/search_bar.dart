import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String)? onSubmitted;

  const CustomSearchBar({
    super.key,
    this.onSubmitted,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: _controller,
      onSubmitted: (value) {
        widget.onSubmitted?.call(value);
      },
      cursorColor: Theme.of(context).colorScheme.primary,
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : Colors.grey.shade400,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),

        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 10),
          child: Icon(
            Icons.search,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 50),

        hintText: "Search...",
        hintStyle: TextStyle(
          color: isDark ? Colors.white54 : Colors.black45,
          fontSize: 14,
        ),
      ),
    );
  }
}
