import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/utils/padded_screen.dart';
import 'package:balder_schedule_app/widgets/edit/day_selector.dart';
import 'package:balder_schedule_app/widgets/page_header.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(title: S.of(context).editTitle),
      body: PaddedScreen(child: EditContent()),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () => context.go('/edit/lesson_create'),
        icon: Icon(Icons.add_outlined),
        label: Text('Добавить'),
      ),
    );
  }
}

class EditContent extends StatelessWidget {
  const EditContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(12),
          DaySelector(),
          const Gap(12),
        ],
      ),
    );
  }
}
