import 'package:balder_schedule_app/widgets/edit/lesson/lesson_segment.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LessonSegments extends FormField<String> {
  final TextEditingController customController;

  LessonSegments({
    super.key,
    required Set<String> selected,
    required ValueChanged<Set<String>> onSelectionChanged,
    required List<LessonSegment> segments,
    required this.customController,
    super.validator,
  }) : super(
          initialValue: selected.isNotEmpty ? selected.first : '',
          builder: (FormFieldState<String> state) {
            return Builder(
              builder: (BuildContext context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<String>(
                        showSelectedIcon: false,
                        emptySelectionAllowed: true,
                        style: SegmentedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                        segments: segments,
                        selected: selected,
                        onSelectionChanged: (newSelection) {
                          if (customController.text.isNotEmpty) {
                            customController.clear();
                          }

                          state.didChange(newSelection.isNotEmpty
                              ? newSelection.first
                              : '');

                          onSelectionChanged(newSelection);
                        },
                      ),
                    ),
                    const Gap(8),
                    TextFormField(
                      textAlign: TextAlign.center,
                      controller: customController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Свой вариант',
                        hintStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          state.didChange('');
                        }
                        onSelectionChanged({});
                      },
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          state.errorText ?? '',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
}
