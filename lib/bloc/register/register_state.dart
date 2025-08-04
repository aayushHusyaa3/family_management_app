part of 'register_cubit.dart';

enum RegisterStatus {
  initialregister,
  registering,
  registered,
  registerFailure,
  emptyRegister,
}

class RegisterState extends Equatable {
  final RegisterStatus? status;
  final String? errorMsg;

  const RegisterState({this.errorMsg, this.status});

  RegisterState copyWith({RegisterStatus? status, String? errorMsg}) {
    return RegisterState(
      errorMsg: errorMsg ?? this.errorMsg,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status, errorMsg];
}
