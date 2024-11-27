class LessonModel {
  final int? id;
  final String name;
  final String classRoom;
  final String lessonType;
  final String time;
  final String? weekParity;
  final String lessonDate;
  final String teacher;
  final String? notes;

  LessonModel({
    this.id,
    required this.name,
    required this.classRoom,
    required this.lessonType,
    required this.time,
    this.weekParity,
    required this.lessonDate,
    required this.teacher,
    this.notes,
  });

  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      id: map['id'],
      name: map['name'],
      classRoom: map['classRoom'],
      lessonType: map['lessonType'],
      time: map['time'],
      weekParity: map['weekParity'],
      lessonDate: map['lessonDate'],
      teacher: map['teacher'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'classRoom': classRoom,
      'lessonType': lessonType,
      'time': time,
      'weekParity': weekParity,
      'lessonDate': lessonDate,
      'teacher': teacher,
      'notes': notes,
    };
  }
}
