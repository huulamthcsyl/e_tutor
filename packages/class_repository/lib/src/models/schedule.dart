import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Schedule extends Equatable {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const Schedule({
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [startTime, endTime];

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      startTime: TimeOfDay.fromDateTime(DateTime.parse(json['startTime'])),
      endTime: TimeOfDay.fromDateTime(DateTime.parse(json['endTime'])),
    );
  }
}