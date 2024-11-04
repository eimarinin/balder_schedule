import 'package:balder_schedule_app/utils/padded_screen.dart';
import 'package:balder_schedule_app/widgets/page_header_child.dart';
import 'package:flutter/material.dart';

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
    return SingleChildScrollView();
  }
}
