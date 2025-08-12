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
  final String? name;
  final String? email;
  final String? boardId;

  const RegisterState({
    this.errorMsg,
    this.status,
    this.uid,
    this.name,
    this.email,
    this.boardId,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    String? errorMsg,
    String? uid,
    String? name,
    String? email,
    String? boardId,
  }) {
    return RegisterState(
      errorMsg: errorMsg ?? this.errorMsg,
      uid: uid ?? this.uid,
      status: status ?? this.status,
      name: name ?? this.name,
      email: email ?? this.email,
      boardId: boardId ?? this.boardId,
    );
  }

  @override
  List<Object?> get props => [status, errorMsg, uid, name, email, boardId];
}
