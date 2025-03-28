import 'package:class_repository/class_repository.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:e_tutor/class_detail/class_detail.dart';
import 'package:e_tutor/utils/format_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_repository/profile_repository.dart';

import '../widgets/add_member/view/add_member_dialog.dart';

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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == ClassDetailStatus.success) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ClassInfo(classDetail: state.classDetail),
                  const SizedBox(height: 8),
                  _ClassSchedules(schedules: state.classDetail.schedules),
                  const SizedBox(height: 8),
                  _ClassMembers(members: state.members, classId: state.classDetail.id!),
                ],
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
  const _ClassInfo({super.key, required this.classDetail});

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
  const _ClassSchedules({super.key, required this.schedules});

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
                    'Từ ${schedule.startTime.format(context)} đến ${schedule.endTime.format(context)}',
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
  const _ClassMembers({super.key, required this.members, required this.classId});

  final List<Profile>? members;
  final String classId;

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
            'Thành viên lớp học',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
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
                  ],
                ),
              ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push<void>(
                AddMemberDialog.route(classId),
              ).then((value) {
                context.read<ClassDetailCubit>().fetchClassDetail(classId);
              });
            },
            child: DottedBorder(
                padding: const EdgeInsets.all(8),
                color: Theme.of(context).colorScheme.primary,
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_circle,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Thêm thành viên',
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
