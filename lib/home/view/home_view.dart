import 'package:e_tutor/home/home.dart';
import 'package:e_tutor/lesson/lesson_detail/lesson_detail.dart';
import 'package:e_tutor/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../exam/exam_detail/view/exam_detail_page.dart';
import '../../notification/notification.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('eTutor'),
            actions: [
              Badge(
                offset: const Offset(-6, 6),
                backgroundColor: Colors.red,
                label: Text(
                  state.notificationCount.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      NotificationPage.route(),
                    );
                  },
                ),
              )
            ],
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2010, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: state.selectedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(state.selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      context.read<HomeCubit>().selectedDayChanged(selectedDay);
                    },
                    calendarFormat: state.calendarFormat,
                    onFormatChanged: (format) {
                      context.read<HomeCubit>().calendarFormatChanged(format);
                    },
                    locale: 'vi_VN',
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Tháng',
                      CalendarFormat.week: 'Tuần',
                      CalendarFormat.twoWeeks: '2 Tuần',
                    },
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: const TextStyle(color: Colors.white),
                      selectedTextStyle: const TextStyle(color: Colors.white),
                      outsideDaysVisible: false,
                    ),
                    eventLoader: (day) {
                      final List<Object> events = [];
                      if (state.exams.isNotEmpty) {
                        events.addAll(state.exams
                            .where((exam) => isSameDay(exam.startTime, day))
                            .toList());
                      }
                      if (state.lessons.isNotEmpty) {
                        events.addAll(state.lessons
                            .where((lesson) => isSameDay(lesson.lesson.startTime, day))
                            .toList());
                      }
                      return events;
                    },
                    onPageChanged: (focusedDay) {
                      context.read<HomeCubit>().selectedDayChanged(focusedDay);
                      context.read<HomeCubit>().getLessonsInMonth(focusedDay);
                      context.read<HomeCubit>().getExamsInMonth(focusedDay);
                    },
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      _LessonList(),
                      _ExamList(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LessonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            for (final lesson in state.lessonsInSelectedDay)
              GestureDetector(
                onTap: () => Navigator.of(context).push<String>(
                  LessonPage.route(
                    classId: lesson.classId,
                    lessonId: lesson.lesson.id
                  ),
                ).then((value) {
                  if (value == "cancelled") {
                    context.read<HomeCubit>().getLessonsInMonth(state.selectedDay);
                  }
                }),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  margin: const EdgeInsets.only(bottom: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.class_,
                        size: 40,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.className,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${FormatTime.formatTime(lesson.lesson.startTime!)} - ${FormatTime.formatTime(lesson.lesson.endTime!)}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
          ]
        );
      },
    );
  }
}

class _ExamList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            for (final exam in state.examsInSelectedDay)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push<void>(
                    ExamPage.route(
                      examId: exam.id!,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  margin: const EdgeInsets.only(bottom: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.assignment,
                        size: 40,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exam.title ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${FormatTime.formatTime(exam.startTime!)} - ${FormatTime.formatTime(exam.endTime!)}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
          ]
        );
      },
    );
  }
}