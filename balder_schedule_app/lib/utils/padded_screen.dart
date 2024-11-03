import 'package:flutter/material.dart';

class PaddedScreen extends StatelessWidget {
  final Widget child;

  const PaddedScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: child,
    );
  }
}
