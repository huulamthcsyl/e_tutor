import 'package:class_repository/class_repository.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:e_tutor/class/class_detail/class_detail.dart';
import 'package:e_tutor/class/class_exam/class_exam.dart';
import 'package:e_tutor/utils/format_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

import 'package:e_tutor/payment/class_tuition/class_tuition.dart';
import '../../../lesson/class_lesson/view/class_lesson_page.dart';
import '../../create_class/widgets/add_member/view/add_member_dialog.dart';
import '../../../lesson/lesson_detail/view/lesson_detail_page.dart';
import '../../../utils/format_time.dart';

class ClassDetailView extends StatelessWidget {
  const ClassDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClassDetailCubit, ClassDetailState>(
      listener: (context, state) {
        if (state.status == ClassDetailStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Không thể tải thông tin lớp học'),
              ),
            );
        }
      },
      child: BlocBuilder<ClassDetailCubit, ClassDetailState>(
        builder: (context, state) {
          if (state.status == ClassDetailStatus.loading) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Chi tiết lớp học',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state.status == ClassDetailStatus.success) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Chi tiết lớp học',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                iconTheme: const IconThemeData(color: Colors.white),
                actions: [
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'class_tuition',
                        child: Text('Thanh toán học phí'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'class_tuition') {
                        Navigator.of(context).push<void>(
                          ClassTuitionPage.route(
                            classId: state.classDetail.id!,
                          ),
                        );
                      }
                    }
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ClassInfo(classDetail: state.classDetail),
                      const SizedBox(height: 8),
                      _ClassSchedules(schedules: state.classDetail.schedules),
                      const SizedBox(height: 8),
                      _ClassMembers(members: state.members, classId: state.classDetail.id!, user: state.user),
                      const SizedBox(height: 8),
                      _UpcomingLesson(lesson: state.upcomingLesson),
                      const SizedBox(height: 8),
                      _RecentExam(exam: state.recentExam),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ClassInfo extends StatelessWidget {
  const _ClassInfo({required this.classDetail});

  final Class classDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tên lớp học: ${classDetail.name ?? ""}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mô tả: ${classDetail.description ?? ""}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Học phí: ${FormatCurrency.format(classDetail.tuition ?? 0)}đ / buổi',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassSchedules extends StatelessWidget {
  const _ClassSchedules({required this.schedules});

  final List<Schedule>? schedules;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lịch học',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (schedules != null)
            for (final schedule in schedules!)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${schedule.startTime.format(context)}-${schedule.endTime.format(context)}, ${schedule.day.label()} hằng tuần',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
        ],
      ),
    );
  }
}

class _ClassMembers extends StatelessWidget {
  const _ClassMembers({required this.members, required this.classId, required this.user});

  final List<Profile>? members;
  final String classId;
  final Profile user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Thành viên lớp học',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              user.role == 'tutor' ? IconButton(
                onPressed: () {
                  Navigator.of(context).push<List<Profile>>(
                    AddMemberDialog.route(
                      classId
                    ),
                  ).then((value) {
                    if (value != null) {
                      context.read<ClassDetailCubit>()
                        .addMembersToClass(classId, value);
                      context.read<ClassDetailCubit>()
                        .fetchClassDetail(classId);
                    }
                  });
                },
                icon: const Icon(Icons.add),
              ) : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 8),
          if (members != null)
            for (final member in members!)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  spacing: 8,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(member.avatarUrl ?? ''),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          member.role?.tutorRole() ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    user.role == 'tutor' ? IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Xóa thành viên'),
                              content: RichText(
                                text: TextSpan(
                                  text: 'Bạn có chắc chắn muốn xóa ',
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: member.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' khỏi lớp học này?',
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop("delete");
                                  },
                                  child: const Text('Xóa'),
                                ),
                              ],
                            );
                          },
                        ).then((value) {
                          if (value == "delete") {
                            context.read<ClassDetailCubit>()
                              .removeMemberFromClass(classId, member.id);
                            context.read<ClassDetailCubit>()
                              .fetchClassDetail(classId);
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ) : const SizedBox.shrink(),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class _UpcomingLesson extends StatelessWidget {
  const _UpcomingLesson({required this.lesson});

  final LessonResponse lesson;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Buổi học sắp tới',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          lesson.lesson.id != null ? GestureDetector(
            onTap: () => Navigator.of(context).push<void>(
              LessonPage.route(
                classId: lesson.classId,
                lessonId: lesson.lesson.id,
              ),
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push<void>(
                LessonPage.route(
                  classId: lesson.classId,
                  lessonId: lesson.lesson.id,
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
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
                      '${FormatTime.formatTime(lesson.lesson.startTime!)} - ${FormatTime.formatTime(lesson.lesson.endTime!)}, ${FormatTime.formatDate(lesson.lesson.startTime!)}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ) : const Text(
            'Không có buổi học nào trong thời gian tới',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push<void>(
                ClassLessonPage.route(id: lesson.classId),
              ).then((value) {
                context.read<ClassDetailCubit>().fetchClassDetail(lesson.classId);
              });
            },
            child: DottedBorder(
              padding: const EdgeInsets.all(8),
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Xem tất cả',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}

class _RecentExam extends StatelessWidget {
  const _RecentExam({required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bài kiểm tra gần nhất',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          exam.id != null ? SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.title ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${FormatTime.formatTime(exam.startTime!)} - ${FormatTime.formatTime(exam.endTime!)}, ${FormatTime.formatDate(exam.startTime!)}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                exam.status == 'completed' ? Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Điểm: ${exam.score}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ) : const Row(
                  children: [
                    Icon(
                      Icons.book,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Chưa hoàn thành',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ) : const Text(
            'Không có bài kiểm tra nào',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push<void>(
                ClassExamPage.route(
                  classId: exam.classId!,
                ),
              ).then((value) {
                context.read<ClassDetailCubit>().fetchClassDetail(exam.classId!);
              });
            },
            child: DottedBorder(
                padding: const EdgeInsets.all(8),
                color: Theme.of(context).colorScheme.primary,
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                )
            ),
          )
        ],
      ),
    );
  }
}

extension on String {
  String tutorRole() {
    switch (this) {
      case 'tutor':
        return 'Gia sư';
      case 'student':
        return 'Học sinh';
      case 'parent':
        return 'Phụ huynh';
      default:
        return '';
    }
  }
}

extension on DayInWeek {
  String label() {
    switch (this) {
      case DayInWeek.Monday:
        return 'Thứ hai';
      case DayInWeek.Tuesday:
        return 'Thứ ba';
      case DayInWeek.Wednesday:
        return 'Thứ tư';
      case DayInWeek.Thursday:
        return 'Thứ năm';
      case DayInWeek.Friday:
        return 'Thứ sáu';
      case DayInWeek.Saturday:
        return 'Thứ bảy';
      case DayInWeek.Sunday:
        return 'Chủ nhật';
      }
  }
}
