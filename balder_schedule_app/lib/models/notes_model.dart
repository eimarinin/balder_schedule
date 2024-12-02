class NotesModel {
  final int? id;
  final int lessonId; // Связь с уроком
  final String note; // Содержимое заметки
  final String date; // Дата применения заметки

  NotesModel({
    this.id,
    required this.lessonId,
    required this.note,
    required this.date,
  });

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['id'],
      lessonId: map['lessonId'],
      note: map['note'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lessonId': lessonId,
      'note': note,
      'date': date,
    };
  }
}
