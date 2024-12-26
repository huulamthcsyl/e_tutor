import 'package:e_tutor/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Padding(
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
                  return state.lessons
                      .where((lesson) => isSameDay(lesson.startTime, day))
                      .toList();
                },
                onPageChanged: (focusedDay) {
                  context.read<HomeCubit>().selectedDayChanged(focusedDay);
                  context.read<HomeCubit>().getLessonsInMonth(focusedDay);
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _EventList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.lessonsInSelectedDay.length,
          itemBuilder: (context, index) {
            final lesson = state.lessonsInSelectedDay[index];
            return ListTile(
              title: Text(lesson.startTime.toString()),
              subtitle: Text(lesson.endTime.toString()),
            );
          },
        );
      },
    );
  }
}