part of 'login_cubit.dart';

enum LoginStatus { initialLogin, logging, logged, loginFailure }

class LoginState extends Equatable {
  final LoginStatus? status;
  final String? errorMsg;

  const LoginState({this.errorMsg, this.status});

  LoginState copyWith({LoginStatus? status, String? errorMsg}) {
    return LoginState(
      errorMsg: errorMsg ?? this.errorMsg,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [errorMsg, status];
}
