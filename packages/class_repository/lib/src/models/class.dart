import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';

class Class extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final List<String>? members;
  final int? tuition;
  final List<Schedule>? schedules;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? startDate;
  final DateTime? endDate;

  const Class({
    this.id,
    this.name,
    this.description,
    this.members,
    this.tuition,
    this.schedules,
    this.isActive,
    this.createdAt,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        members,
        tuition,
        schedules,
        isActive,
        createdAt,
        endDate,
        startDate,
      ];
}
