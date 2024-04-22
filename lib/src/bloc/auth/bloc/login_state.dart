part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.username = '',
    this.password = '',
    this.usernameInvalid = false,
    this.passwordInvalid = false,
  });

  final LoginStatus status;
  final String username;
  final String password;
  final bool usernameInvalid;
  final bool passwordInvalid;

  LoginState copyWith({
    LoginStatus? status,
    String? username,
    String? password,
    bool? usernameInvalid,
    bool? passwordInvalid,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      usernameInvalid: usernameInvalid ?? this.usernameInvalid,
      passwordInvalid: passwordInvalid ?? this.passwordInvalid,
    );
  }

  @override
  List<Object> get props => [status, username, password, usernameInvalid, passwordInvalid];
}