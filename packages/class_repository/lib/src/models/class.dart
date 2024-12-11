import 'package:class_repository/class_repository.dart';
import 'package:class_repository/src/models/exam.dart';
import 'package:equatable/equatable.dart';

class Class extends Equatable {
  final String id;
  final String? name;
  final String? description;
  final List<String>? members;
  final double? tuition;
  final List<Schedule>? schedules;
  final List<Lesson>? lessons;
  final List<Exam>? exams;
  final bool? isActive;

  const Class({
    required this.id,
    this.name,
    this.description,
    this.members,
    this.tuition,
    this.schedules,
    this.lessons,
    this.exams,
    this.isActive
  });

  @override
  List<Object?> get props => [id, name, description, members, tuition, schedules, lessons, exams, isActive];
}
