import 'package:flutter/material.dart';

class MarginScreen extends StatelessWidget {
  final Widget child;

  const MarginScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ),
      child: child,
    );
  }
}
