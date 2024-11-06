import 'package:flutter/material.dart';

import '../../utils/padded_screen.dart';
import '../../widgets/page_header.dart';
import '../../generated/l10n.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(title: S.of(context).editTitle),
      body: const PaddedScreen(child: EditContent()),
    );
  }
}

class EditContent extends StatelessWidget {
  const EditContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
