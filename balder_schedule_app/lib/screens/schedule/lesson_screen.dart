import 'package:balder_schedule_app/utils/padded_screen.dart';
import 'package:balder_schedule_app/widgets/page_header_child.dart';
import 'package:balder_schedule_app/widgets/schedule/lesson/lesson_time.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeaderChild(title: 'Алгебра'),
      body: const PaddedScreen(child: LessonContent()),
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
          Gap(12),
          Row(
            children: [
              LessonTime(text: '8:00'),
              Gap(12),
              Text('-', style: TextStyle(fontSize: 24)),
              Gap(12),
              LessonTime(text: '9:35'),
            ],
          )
        ],
      ),
    );
  }
}
