import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/utils/padded_screen.dart';
import 'package:balder_schedule_app/widgets/page_header_child.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LessonCreateScreen extends StatelessWidget {
  const LessonCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeaderChild(title: S.of(context).lessonCreateScreenTitle),
      body: PaddedScreen(child: LessonCreateContent()),
    );
  }
}

class LessonCreateContent extends StatelessWidget {
  const LessonCreateContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(12),
          Wrap(
            runSpacing: 12.0,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Название предмета",
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
