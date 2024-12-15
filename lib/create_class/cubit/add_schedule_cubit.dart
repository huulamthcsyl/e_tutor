
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_schedule_state.dart';

class AddScheduleCubit extends Cubit<AddScheduleState> {
  AddScheduleCubit() : super(const AddScheduleState());

  void startTimeChanged(DateTime value) {
    emit(state.copyWith(
      startTime: value,
      endTime: value.add(const Duration(hours: 2)),
    ));
  }

  void endTimeChanged(DateTime value) {
    emit(state.copyWith(endTime: value));
  }
}
