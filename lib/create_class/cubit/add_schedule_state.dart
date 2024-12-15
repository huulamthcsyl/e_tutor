part of 'add_schedule_cubit.dart';

class AddScheduleState extends Equatable {

  final DateTime startTime;
  final DateTime endTime;

  const AddScheduleState({
    this.startTime = const ConstDateTime(0, 0, 0, 0),
    this.endTime = const ConstDateTime(0, 0, 0, 2),
  });

  @override
  List<Object> get props => [startTime, endTime];

  AddScheduleState copyWith({
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return AddScheduleState(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
