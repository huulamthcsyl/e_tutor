part of 'add_schedule_cubit.dart';

class AddScheduleState extends Equatable {
  final DateTime startTime;
  final DateTime endTime;
  final DayInWeek day;

  const AddScheduleState({
    this.startTime = const ConstDateTime(0, 0, 0, 0),
    this.endTime = const ConstDateTime(0, 0, 0, 2),
    this.day = DayInWeek.Monday,
  });

  @override
  List<Object> get props => [startTime, endTime, day];

  AddScheduleState copyWith({
    DateTime? startTime,
    DateTime? endTime,
    DayInWeek? day,
  }) {
    return AddScheduleState(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      day: day ?? this.day
    );
  }
}
