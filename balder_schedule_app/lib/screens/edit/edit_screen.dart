import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/services/storage/storage_service.dart';
import 'package:balder_schedule_app/utils/export/export.dart';
import 'package:balder_schedule_app/utils/margin_screen.dart';
import 'package:balder_schedule_app/widgets/edit/day_selector.dart';
import 'package:balder_schedule_app/widgets/page_header.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(title: S.of(context).editTitle),
      body: MarginScreen(child: EditContent()),
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
          if (kIsWeb)
            IconButton(
              icon: Icon(Icons.download_outlined),
              tooltip: 'Экспортировать данные',
              onPressed: () async {
                final data = await StorageService().loadLessonData();
                exportData(data);
              },
            ),
        ],
      ),
    );
  }
}
