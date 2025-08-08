part of 'register_cubit.dart';

enum RegisterStatus {
  initialregister,
  registering,
  registered,
  registerFailure,

  updating,
  updated,
  updatingFailure,
}

class RegisterState extends Equatable {
  final RegisterStatus? status;
  final String? errorMsg;
  final String? uid;

  const RegisterState({this.errorMsg, this.status, this.uid});

  RegisterState copyWith({
    RegisterStatus? status,
    String? errorMsg,
    String? uid,
  }) {
    return RegisterState(
      errorMsg: errorMsg ?? this.errorMsg,
      uid: uid ?? this.uid,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status, errorMsg, uid];
}
