import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/utils/padded_screen.dart';
import 'package:balder_schedule_app/widgets/edit/lesson/lesson_field.dart';
import 'package:balder_schedule_app/widgets/page_header_child.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LessonCreateScreen extends StatefulWidget {
  const LessonCreateScreen({super.key});

  @override
  State<LessonCreateScreen> createState() => _LessonCreateScreenState();
}

class _LessonCreateScreenState extends State<LessonCreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _classController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeaderChild(title: S.of(context).lessonCreateScreenTitle),
      body: PaddedScreen(
        child: Form(
          key: _formKey,
          child: LessonCreateContent(
            nameController: _nameController,
            classController: _classController,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            // Если форма валидна
            // Ваша логика
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class LessonCreateContent extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController classController;

  const LessonCreateContent({
    super.key,
    required this.nameController,
    required this.classController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(12),
          Wrap(
            runSpacing: 12.0,
            children: [
              LessonField(
                labelText: 'Название предмета',
                controller: nameController,
              ),
              LessonField(
                labelText: 'Аудитория',
                controller: classController,
                isNumeric: true,
              ),
            ],
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
