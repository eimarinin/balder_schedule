// lib/widgets/page_header.dart

import 'package:flutter/material.dart';

class PageHeaderChild extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const PageHeaderChild({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text(title),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
