import 'package:authentication_repository/authentication_repository.dart';
import 'package:class_repository/class_repository.dart';
import 'package:const_date_time/const_date_time.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:table_calendar/table_calendar.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ClassRepository classRepository;
  final AuthenticationRepository authenticationRepository;
  final NotificationRepository notificationRepository;

  HomeCubit(this.classRepository, this.authenticationRepository, this.notificationRepository)
      : super(const HomeState());

  void initialize() async {
    final user = await authenticationRepository.user.first;
    notificationRepository.getNotificationCount(user.id).listen((count) {
      emit(state.copyWith(notificationCount: count));
    });
    emit(state.copyWith(
      selectedDay: DateTime.now(),
    ));
    getLessonsInMonth(DateTime.now());
  }

  Future<void> getLessonsInMonth(DateTime date) async {
    emit(state.copyWith(status: HomeStatus.initial));
    final user = await authenticationRepository.user.first;
    try {
      final lessons = await classRepository.getLessonsInMonthOnDate(date, user.id);
      emit(state.copyWith(
        lessons: lessons,
        status: HomeStatus.success,
      ));
      getLessonsInDay(state.selectedDay);
    } on Exception {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  void getLessonsInDay(DateTime date) {
    final lessonsInSelectedDay = state.lessons
      .where((lesson) => isSameDay(lesson.lesson.startTime, state.selectedDay))
      .toList();
    emit(state.copyWith(lessonsInSelectedDay: lessonsInSelectedDay));
  }

  void selectedDayChanged(DateTime selectedDay) {
    emit(state.copyWith(selectedDay: selectedDay));
    getLessonsInDay(selectedDay);
  }

  void calendarFormatChanged(CalendarFormat calendarFormat) {
    emit(state.copyWith(calendarFormat: calendarFormat));
  }
}
