import 'package:class_repository/class_repository.dart';
import 'package:e_tutor/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../class_detail/class_detail.dart';
import '../../homework/homework.dart';
import '../cubit/notification_cubit.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state.status == NotificationStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == NotificationStatus.failure) {
          return const Center(child: Text('Không thể tải danh sách thông báo'));
        } else if (state.notifications.isEmpty) {
          return const Center(child: Text('Bạn chưa có thông báo nào'));
        } else {
          return ListView.builder(
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              final notification = state.notifications[index];
              return GestureDetector(
                onTap: () {
                  // Handle notification tap
                  context.read<NotificationCubit>().markNotificationAsRead(notification.id);
                  switch (notification.documentType) {
                    case 'class':
                      Navigator.of(context).push(
                        ClassDetailPage.route(id: notification.documentId),
                      );
                      break;
                    case 'homework':
                      Navigator.of(context).push(
                        HomeworkPage.route(id: notification.documentId),
                      );
                      break;
                  }
                },
                child: Container(
                  color: notification.isRead ? Colors.white : Colors.blue[50],
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: notification.isRead
                              ? Colors.black
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(notification.body),
                      Text(
                        FormatTime.timeAgo(notification.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
