import 'package:flutter/material.dart';

import '../../widgets/page_header.dart';
import '../../generated/l10n.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(title: S.of(context).editTitle),
      body: const Center(
        child: Text('Экран редактирования'),
      ),
    );
  }
}
