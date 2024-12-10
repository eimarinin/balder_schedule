import 'package:balder_schedule_app/models/notes_model.dart';
import 'package:balder_schedule_app/services/database/notes_db.dart';
import 'package:balder_schedule_app/widgets/schedule/schedule_tag.dart';
import 'package:balder_schedule_app/widgets/schedule/schedule_time.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ScheduleItem extends StatelessWidget {
  final int id;
  final String startTime;
  final String endTime;
  final String subject;
  final String lectureType;
  final String room;
  final String teacher;
  final bool specialDay;
  final String date;
  final String lessonNote;
  final int countNotes;

  const ScheduleItem({
    super.key,
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.lectureType,
    required this.room,
    required this.teacher,
    required this.specialDay,
    required this.date,
    required this.lessonNote,
    required this.countNotes,
  });

  Future<List<NotesModel>> _fetchNotes() {
    return NotesDatabase().getNotesByLessonId(id);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(
        '/lesson/$id?date=${Uri.encodeComponent(date)}',
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (specialDay) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    subject,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
              ] else ...[
                Text(
                  subject,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
              const Gap(6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ScheduleTime(startTime: startTime, endTime: endTime),
                  ),
                  const Gap(12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (room == 'online') ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Онлайн',
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ] else ...[
                        ScheduleTag(text: room),
                      ],
                      const Gap(2),
                      ScheduleTag(text: lectureType),
                      const Gap(2),
                      ScheduleTag(text: teacher),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (countNotes != 0)
            Positioned(
              top: 0,
              right: 0,
              child: Badge.count(
                count: countNotes,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.onSecondary,
                child: IconButton(
                  icon: const Icon(Icons.receipt),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(subject),
                        content: FutureBuilder<List<NotesModel>>(
                          future: _fetchNotes(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Ошибка загрузки заметок'),
                              );
                            }

                            final notes = snapshot.data ?? [];

                            if (notes.isEmpty) {
                              return const Center(
                                child: Text('Заметок нет'),
                              );
                            }

                            final itemCount =
                                notes.length + (lessonNote.isNotEmpty ? 1 : 0);

                            return SizedBox(
                              height: 350,
                              width: 400,
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: itemCount,
                                itemBuilder: (context, index) {
                                  if (lessonNote.isNotEmpty && index == 0) {
                                    return Text(
                                      lessonNote,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    );
                                  } else {
                                    final noteIndex = lessonNote.isNotEmpty
                                        ? index - 1
                                        : index;
                                    final note = notes[noteIndex];

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainer,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            note.date,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                        const Gap(4),
                                        Text(note.note),
                                      ],
                                    );
                                  }
                                },
                                separatorBuilder: (context, index) =>
                                    const Column(
                                  children: [
                                    Gap(12),
                                    Divider(thickness: 2, height: 0),
                                    Gap(12),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Закрыть'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
