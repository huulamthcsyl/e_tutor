import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';

class LessonResponse extends Equatable {
  final String classId;
  final String className;
  final Lesson lesson;

  const LessonResponse({
    this.classId = '',
    this.className = '',
    this.lesson = const Lesson(),
  });

  @override
  List<Object?> get props => [classId, className, lesson];
}