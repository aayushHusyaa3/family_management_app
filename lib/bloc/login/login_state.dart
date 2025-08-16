part of 'login_cubit.dart';

enum LoginStatus {
  initialLogin,
  logging,
  logged,
  loginFailure,

  googleLogin,
  googleLoginFailure,
  googleLoginSuccessful,

  appleLogin,
  appleLoginFailure,
  appleLoginSuccessful,

  forgetSucessful,
  forgetting,
  forgetFailure,
}

class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMsg;

  final String? uid;

  const LoginState({this.errorMsg, required this.status, this.uid});

  LoginState copyWith({LoginStatus? status, String? errorMsg, String? uid}) {
    return LoginState(
      errorMsg: errorMsg ?? this.errorMsg,
      status: status ?? this.status,

      uid: uid ?? this.uid,
    );
  }

  @override
  List<Object?> get props => [errorMsg, status, uid];
}
