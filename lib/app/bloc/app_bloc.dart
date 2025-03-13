import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_state.dart';
part 'app_event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(AuthenticationRepository authenticationRepository)
    : _authenticationRepository = authenticationRepository,
      super(AppState()) {
        on<AppUserSubscriptionRequested>(_onUserSubscriptionRequested);
        on<AppLogoutPressed>(_onLogoutPressed);
      }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onUserSubscriptionRequested(
    AppUserSubscriptionRequested event,
    Emitter<AppState> emit,
  ) {
    return emit.onEach(
      _authenticationRepository.user, 
      onData: (user) => emit(AppState(user: user)),
      onError: addError
    );
  }

  void _onLogoutPressed(
    AppLogoutPressed event,
    Emitter<AppState> emit,
  ) {
    _authenticationRepository.logOut();
  }
}