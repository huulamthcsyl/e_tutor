part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final List<LessonResponse> lessons;
  final List<LessonResponse> lessonsInSelectedDay;
  final DateTime selectedDay;
  final CalendarFormat calendarFormat;
  final HomeStatus status;
  final int notificationCount;

  const HomeState({
    this.lessons = const [],
    this.lessonsInSelectedDay = const [],
    this.selectedDay = const ConstDateTime(2024),
    this.calendarFormat = CalendarFormat.week,
    this.status = HomeStatus.success,
    this.notificationCount = 0,
  });

  @override
  List<Object> get props => [lessons, lessonsInSelectedDay, selectedDay, calendarFormat, notificationCount, status];

  HomeState copyWith({
    List<LessonResponse>? lessons,
    List<LessonResponse>? lessonsInSelectedDay,
    DateTime? selectedDay,
    CalendarFormat? calendarFormat,
    HomeStatus? status,
    int? notificationCount,
  }) {
    return HomeState(
      lessons: lessons ?? this.lessons,
      lessonsInSelectedDay: lessonsInSelectedDay ?? this.lessonsInSelectedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      calendarFormat: calendarFormat ?? this.calendarFormat,
      status: status ?? this.status,
      notificationCount: notificationCount ?? this.notificationCount,
    );
  }
}
