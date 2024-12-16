import 'package:class_repository/class_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Schedule extends Equatable {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final DayInWeek day;

  const Schedule({
    required this.startTime,
    required this.endTime,
    required this.day,
  });

  @override
  List<Object?> get props => [startTime, endTime, day];

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      startTime: TimeOfDay.fromDateTime(DateTime.parse(json['startTime'])),
      endTime: TimeOfDay.fromDateTime(DateTime.parse(json['endTime'])),
      day: DayInWeek.values[json['day']],
    );
  }
}