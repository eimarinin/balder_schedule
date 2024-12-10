import 'package:balder_schedule_app/models/lesson_model.dart';
import 'package:balder_schedule_app/models/notes_model.dart';
import 'package:balder_schedule_app/services/database/lesson_db.dart';
import 'package:balder_schedule_app/services/database/notes_db.dart';
import 'package:balder_schedule_app/utils/margin_screen.dart';
import 'package:balder_schedule_app/widgets/dialogs/confirmation_dialog.dart';
import 'package:balder_schedule_app/widgets/dialogs/edit_dialog.dart';
import 'package:balder_schedule_app/widgets/flash/snackbar_handler.dart';
import 'package:balder_schedule_app/widgets/page_header_child.dart';
import 'package:balder_schedule_app/widgets/schedule/lesson/lesson_tag.dart';
import 'package:balder_schedule_app/widgets/schedule/lesson/lesson_time.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LessonScreen extends StatelessWidget {
  final int id;
  final String date;

  const LessonScreen({
    super.key,
    required this.id,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LessonModel?>(
      future: LessonDatabase().getLessonById(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Ошибка')),
            body: Center(child: Text('Не удалось загрузить урок')),
          );
        }

        final lesson = snapshot.data;

        if (lesson == null) {
          return Scaffold(
            appBar: AppBar(title: Text('Урок не найден')),
            body: Center(child: Text('Урок с ID $id не найден')),
          );
        }

        return Scaffold(
          appBar: PageHeaderChild(title: lesson.name),
          body: MarginScreen(
            child: LessonContent(
              lesson: lesson,
              date: date,
            ),
          ),
        );
      },
    );
  }
}

class LessonContent extends StatefulWidget {
  final LessonModel lesson;
  final String date;

  const LessonContent({
    super.key,
    required this.lesson,
    required this.date,
  });

  @override
  State<LessonContent> createState() => _LessonContentState();
}

class _LessonContentState extends State<LessonContent>
    with TickerProviderStateMixin {
  late LessonModel lesson = widget.lesson;
  late String date = widget.date;

  String _noteText = '';

  bool _isNoteFormVisible = false;

  void _toggleNoteFormVisibility() {
    setState(() {
      _isNoteFormVisible = !_isNoteFormVisible;
    });
  }

  Future<List<NotesModel>> _fetchNotes() {
    return NotesDatabase().getNotesByLessonId(lesson.id!);
  }

  Future<void> _saveNote() async {
    if (_noteText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Введите текст заметки')),
      );
      return;
    }

    final notesDb = NotesModel(
      lessonId: lesson.id!,
      date: date,
      note: _noteText.trim(),
    );

    SnackbarHandler.handleAction(
      context,
      () async {
        await NotesDatabase().insertNote(notesDb);

        setState(() {
          _isNoteFormVisible = false;
          _noteText = '';
        });
      },
      'Заметка успешно добавлена!',
      'Ошибка при добавлении заметки.',
    );
  }

  void _editNote(BuildContext context, int noteId, String noteText) async {
    final TextEditingController controller = TextEditingController(
      text: noteText,
    );

    final updatedNote = await EditNoteDialog.show(
      context: context,
      title: 'Редактировать заметку',
      controller: controller,
      hintText: 'Введите новый текст заметки',
    );

    if (updatedNote != null &&
        updatedNote.trim().isNotEmpty &&
        context.mounted) {
      SnackbarHandler.handleAction(
        context,
        () async {
          await NotesDatabase().updateNote(noteId, updatedNote.trim());
          setState(() {});
        },
        'Заметка успешно обновлена!',
        'Ошибка при обновлении заметки.',
      );
    }
  }

  void _deleteNote(BuildContext context, int noteId) {
    ConfirmationDialog.show(
      context: context,
      title: 'Подтверждение',
      content: 'Вы уверены, что хотите удалить заметку?',
      confirmButtonText: 'Удалить',
      isDanger: true,
      onConfirm: () {
        SnackbarHandler.handleAction(
          context,
          () async {
            await NotesDatabase().deleteNote(noteId);
            setState(() {});
          },
          'Заметка успешно удалена!',
          'Не удалось удалить заметку.',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(12),
          Row(
            children: [
              LessonTime(text: lesson.time.split('-')[0]),
              const Gap(12),
              Text('-', style: TextStyle(fontSize: 24)),
              const Gap(12),
              LessonTime(text: lesson.time.split('-')[1]),
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
                      LessonTag(label: lesson.lessonType),
                      const Divider(thickness: 2, height: 0),
                      LessonTag(
                        label: lesson.classRoom.toLowerCase() == 'online'
                            ? 'Онлайн'
                            : lesson.classRoom,
                      ),
                      const Divider(thickness: 2, height: 0),
                      LessonTag(label: lesson.teacher),
                      const Divider(thickness: 2, height: 0),
                      if (lesson.weekParity != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LessonTag(
                              label: 'Кратность недель: ${lesson.weekParity!}',
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (lesson.notes != null) ...[
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                    ),
                    child: Wrap(
                      runSpacing: 12.0,
                      children: [
                        Text('Общая заметка',
                            style: Theme.of(context).textTheme.bodyLarge),
                        const Divider(thickness: 2, height: 0),
                        Text(lesson.notes ?? ''),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
          const Gap(12),
          FutureBuilder<List<NotesModel>>(
            future: _fetchNotes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Ошибка загрузки заметок'),
                );
              }

              final notes = snapshot.data ?? [];

              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return FadeTransition(
                    opacity: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: AnimationController(
                          vsync: this,
                          duration: const Duration(milliseconds: 400),
                        )..forward(),
                        curve: Curves.easeIn,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerLow,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Заметка на ${note.date}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      const Divider(thickness: 2, height: 16),
                                      Text(
                                        note.note,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(8),
                                MenuAnchor(
                                  menuChildren: <Widget>[
                                    MenuItemButton(
                                      style: ButtonStyle(
                                        padding: WidgetStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                        ),
                                      ),
                                      onPressed: () => _editNote(
                                          context, note.id!, note.note),
                                      child: const Text('Редактировать'),
                                    ),
                                    MenuItemButton(
                                      style: ButtonStyle(
                                        padding: WidgetStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                        ),
                                      ),
                                      onPressed: () =>
                                          _deleteNote(context, note.id!),
                                      child: const Text('Удалить'),
                                    ),
                                  ],
                                  builder: (_, MenuController controller,
                                      Widget? child) {
                                    return IconButton(
                                      onPressed: () {
                                        if (controller.isOpen) {
                                          controller.close();
                                        } else {
                                          controller.open();
                                        }
                                      },
                                      icon: const Icon(Icons.more_vert),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Gap(12),
              );
            },
          ),
          const Gap(12),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _toggleNoteFormVisibility,
                  child: Text(_isNoteFormVisible
                      ? 'Скрыть ввод заметки'
                      : 'Добавить заметку'),
                ),
              ),
            ],
          ),
          if (_isNoteFormVisible) ...[
            const Gap(12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Заметка на $date',
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
              onChanged: (value) {
                setState(() {
                  _noteText = value;
                });
              },
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                    ),
                    onPressed: _saveNote,
                    icon: Icon(
                      Icons.check_outlined,
                      size: 18,
                    ),
                    label: Text('Сохранить'),
                  ),
                ),
              ],
            ),
          ],
          const Gap(12),
        ],
      ),
    );
  }
}
