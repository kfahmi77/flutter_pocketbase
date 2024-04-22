import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../shared/utils/url.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginUsernameChanged>(usernameChanged);
    on<LoginPasswordChanged>(passwordChanged);
    on<LoginSubmitted>(loginSubmitted);
  }

  void usernameChanged(LoginUsernameChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      username: event.username,
      usernameInvalid: event.username.isEmpty,
    ));
  }

  void passwordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      password: event.password,
      passwordInvalid: event.password.isEmpty,
    ));
  }

  void loginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (event.username.isEmpty || event.password.isEmpty) {
      emit(state.copyWith(
        usernameInvalid: event.username.isEmpty,
        passwordInvalid: event.password.isEmpty,
      ));
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));

    try {
      // Simulate a network request
      await Future.delayed(const Duration(seconds: 1));
      log(event.username);
      log(event.password);
      final result = await pb
          .collection('users')
          .authWithPassword(event.username, event.password);
      log(result.record.toString());
      emit(state.copyWith(status: LoginStatus.success));
    } catch (_) {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }
}
