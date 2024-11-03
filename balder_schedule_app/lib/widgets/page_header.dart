// lib/widgets/page_header.dart

import 'package:flutter/material.dart';
import '../utils/padded_screen.dart';

class PageHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const PageHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      toolbarHeight: 61,
      title: PaddedScreen(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(61.0);
}
