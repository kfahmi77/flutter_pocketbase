import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../../shared/utils/url.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final storage = const FlutterSecureStorage();
  LoginBloc() : super(const LoginState()) {
    on<LoginUsernameChanged>(usernameChanged);
    on<LoginPasswordChanged>(passwordChanged);
    on<LoginSubmitted>(loginSubmitted);
    on<AppStarted>(_appStarted);
  }

  void _appStarted(AppStarted event, Emitter<LoginState> emit) async {
    save(String token) async {
      await storage.write(key: 'token', value: token);
    }

    final customAuthStore =
        AsyncAuthStore(save: save, initial: await storage.read(key: 'token'));
    final pb = PocketBase(
      '"http://127.0.0.1:8090"',
      authStore: customAuthStore,
    );
    if (pb.authStore.isValid) {
      emit(state.copyWith(status: LoginStatus.success));
      final result = await pb.collection('users').authRefresh();
      log(result.toString());
    } else {
      emit(state.copyWith(status: LoginStatus.initial));
    }
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
      await Future.delayed(const Duration(seconds: 1));
      log(event.username);
      log(event.password);
      final result = await pb
          .collection('users')
          .authWithPassword(event.username, event.password);
      final responseData = jsonDecode(result.toString());
      final token = responseData['token'];
      await storage.write(key: 'token', value: token);
      final getToken = await storage.read(key: 'token');
      if (responseData['record'] != null) {
        final userId = responseData['record']['id'];

     pb.authStore.model.id = userId.toString();
        log(userId.toString());
      } else {
        log('User data is not available in the response');
      }
      print('Result: $result');
      log('Token: $token');
      log('GetToken: $getToken');
      emit(state.copyWith(status: LoginStatus.success));
    } catch (_) {
      log(_.toString());
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }
}

class UserModel {
  final String id;
  final String token;

  UserModel({required this.id, required this.token});
}
