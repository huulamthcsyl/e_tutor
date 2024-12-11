import 'package:equatable/equatable.dart';

class Schedule extends Equatable {
  final String startTime;
  final String endTime;

  const Schedule({
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [startTime, endTime];
}