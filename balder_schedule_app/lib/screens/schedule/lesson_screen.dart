import 'package:balder_schedule_app/utils/padded_screen.dart';
import 'package:balder_schedule_app/widgets/page_header_child.dart';
import 'package:balder_schedule_app/widgets/schedule/lesson/lesson_tag.dart';
import 'package:balder_schedule_app/widgets/schedule/lesson/lesson_time.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeaderChild(title: 'Алгебра'),
      body: PaddedScreen(child: LessonContent()),
    );
  }
}

class LessonContent extends StatelessWidget {
  const LessonContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(12),
          Row(
            children: [
              LessonTime(text: '8:00'),
              const Gap(12),
              Text('-', style: TextStyle(fontSize: 24)),
              const Gap(12),
              LessonTime(text: '9:35'),
            ],
          ),
          const Gap(12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: Wrap(
                    runSpacing: 24.0,
                    children: [
                      LessonTag(label: 'Лекция'),
                      const Divider(thickness: 2, height: 0),
                      LessonTag(label: '6512'),
                      const Divider(thickness: 2, height: 0),
                      LessonTag(label: 'Багаев Андрей Владимирович'),
                      const Divider(thickness: 2, height: 0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LessonTag(label: 'Четные недели'),
                          LessonTag(label: 'Нечетные недели'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          TextField(
            decoration: InputDecoration(
              labelText: 'Заметка на 28.10',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
              hintText: 'Например, сделать домашку...',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            maxLines: null,
            minLines: 5,
          ),
          const Gap(12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                  ),
                  onPressed: () {},
                  icon: Icon(
                    Icons.check_outlined,
                    size: 18,
                  ),
                  label: Text('Сохранить'),
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
