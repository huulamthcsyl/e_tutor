part of 'notification_cubit.dart';

enum NotificationStatus {
  initial,
  loading,
  success,
  failure,
}

class NotificationState extends Equatable {

  final List<NotificationDoc> notifications;
  final NotificationStatus status;

  const NotificationState({
    this.notifications = const [],
    this.status = NotificationStatus.initial,
  });

  @override
  List<Object> get props => [notifications, status];

  NotificationState copyWith({
    List<NotificationDoc>? notifications,
    NotificationStatus? status,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
    );
  }
}

