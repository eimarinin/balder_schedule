// lib/screens/notifications_screen.dart

import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/padded_screen.dart';
import '../../widgets/page_header_child.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeaderChild(title: S.of(context).qrTitle),
      body: const PaddedScreen(child: QrContent()),
    );
  }
}

class QrContent extends StatelessWidget {
  const QrContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(12),
      ],
    );
  }
}
