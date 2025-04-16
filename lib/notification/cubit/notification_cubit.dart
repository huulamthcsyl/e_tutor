import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notification_repository/notification_repository.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {

  final NotificationRepository _notificationRepository;
  final AuthenticationRepository _authenticationRepository;

  NotificationCubit(this._notificationRepository, this._authenticationRepository) : super(const NotificationState());

  void initialize() async {
    emit(state.copyWith(status: NotificationStatus.loading));
    try {
      final user = await _authenticationRepository.user.first;
      final notifications = await _notificationRepository.getNotifications(user.id);
      emit(state.copyWith(
        notifications: notifications,
        status: NotificationStatus.success,
      ));
    } on Exception {
      emit(state.copyWith(status: NotificationStatus.failure));
    }
  }
}
