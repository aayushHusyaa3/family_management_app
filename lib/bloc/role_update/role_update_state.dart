part of 'role_update_cubit.dart';

enum RoleUpdatingStatus {
  fetching,
  fetched,
  fetchingFailure,
  initialUpdating,
  updating,
  updated,
  updatingFailure,
}

class RoleUpdateState extends Equatable {
  final RoleUpdatingStatus? status;
  final String? errorMsg;
  final String? boardTitle;
  final String? boardDescription;
  final String? boardId;
  final String? boardNickname;
  final String? role;

  final String? uid;
  const RoleUpdateState({
    this.errorMsg,
    this.status,
    this.uid,
    this.boardDescription,
    this.boardTitle,
    this.boardId,
    this.boardNickname,
    this.role,
  });

  RoleUpdateState copyWith({
    RoleUpdatingStatus? status,
    String? errorMsg,
    String? uid,
    String? boardTitle,
    String? boardDescription,
    String? boardId,
    String? boardNickname,
    String? role,
  }) {
    return RoleUpdateState(
      errorMsg: errorMsg ?? this.errorMsg,
      uid: uid ?? this.uid,
      status: status ?? this.status,
      boardDescription: boardDescription ?? this.boardDescription,
      boardTitle: boardTitle ?? this.boardTitle,
      boardId: boardId ?? this.boardId,
      boardNickname: boardNickname ?? this.boardNickname,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMsg,
    uid,
    boardDescription,
    boardTitle,
    boardId,
    boardNickname,
    role,
  ];
}
