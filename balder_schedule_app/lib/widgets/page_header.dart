import 'package:balder_schedule_app/models/lesson_model.dart';
import 'package:balder_schedule_app/services/database/lesson_db.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<List<LessonModel>> loadLessonData() async {
  final lessons = await LessonDatabase().getLessons();
  return lessons; // Возвращаем полный список объектов LessonModel
}

class PageHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const PageHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            IconButton(
              icon: const Icon(Icons.search_outlined),
              onPressed: () async {
                final data = await loadLessonData();
                if (context.mounted) {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(data: data),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomSearchDelegate extends SearchDelegate {
  final List<LessonModel> data;

  CustomSearchDelegate({required this.data});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = data.where((lesson) {
      final searchableString = '''
        ${lesson.name} ${lesson.classRoom} ${lesson.lessonType} 
        ${lesson.time} ${lesson.weekParity ?? ''} ${lesson.lessonDate} 
        ${lesson.teacher} ${lesson.notes ?? ''}
      '''
          .toLowerCase();
      return searchableString.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final lesson = results[index];
        return ListTile(
          trailing: Text(lesson.time),
          title: Text(lesson.name),
          subtitle: Text('${lesson.teacher} — ${lesson.classRoom}'),
          onTap: () {
            close(context, lesson);
            context.go('/lesson/${lesson.id}');
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // if (query.isEmpty) {
    //   return const SizedBox.shrink();
    // }

    final suggestions = data.where((lesson) {
      final searchableString = '''
        ${lesson.name} ${lesson.classRoom} ${lesson.lessonType} 
        ${lesson.time} ${lesson.weekParity ?? ''} ${lesson.lessonDate} 
        ${lesson.teacher} ${lesson.notes ?? ''}
      '''
          .toLowerCase();
      return searchableString.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final lesson = suggestions[index];
        return ListTile(
          trailing: Text(lesson.time),
          title: Text(lesson.name),
          subtitle: Text('${lesson.teacher} — ${lesson.classRoom}'),
          onTap: () {
            query = lesson.name;
            showResults(context);
            context.go('/lesson/${lesson.id}');
          },
        );
      },
    );
  }
}
