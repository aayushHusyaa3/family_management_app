part of 'fetch_user_cubit.dart';

enum FetchUserStatus {
  initialFetching,
  fetching,
  fetched,
  fetchingError,

  logouting,
  loggedOut,
  logoutFailed,

  fetchingAllUser,
  fetchedAllUser,
  fetchingAllUserFailed,
}

class FetchUserState extends Equatable {
  final FetchUserStatus status;
  final String? errorMsg;
  final String? role;
  final String? email;
  final String? name;
  final String? imagePath;
  final String? uid;
  final int? itemCount;
  final List<Map<String, dynamic>>? joinRequestList;
  final List<AllUserInfo>? userInfo;
  final String? boardId;
  final String? rejectedEmail;
  final String? acceptedEmail;
  final String? roleStatus;
  final int? pendingCount;
  const FetchUserState({
    required this.status,
    this.errorMsg,
    this.role,
    this.email,
    this.imagePath,
    this.name,
    this.userInfo,
    this.uid,
    this.joinRequestList,
    this.itemCount,
    this.boardId,
    this.rejectedEmail,
    this.acceptedEmail,
    this.roleStatus,
    this.pendingCount,
  });

  FetchUserState copyWith({
    FetchUserStatus? status,
    String? errorMsg,
    String? role,
    String? email,
    String? name,
    String? imagePath,
    List<AllUserInfo>? userInfo,
    String? uid,
    int? itemCount,
    List<Map<String, dynamic>>? joinRequestList,
    String? boardId,
    String? rejectedEmail,
    String? acceptedEmail,
    String? roleStatus,
    int? pendingCount,
  }) {
    return FetchUserState(
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
      role: role ?? this.role,
      email: email ?? this.email,
      name: name ?? this.name,
      userInfo: userInfo ?? this.userInfo,
      uid: uid ?? this.uid,
      imagePath: imagePath ?? this.imagePath,
      joinRequestList: joinRequestList ?? this.joinRequestList,
      itemCount: itemCount ?? this.itemCount,
      boardId: boardId ?? this.boardId,
      rejectedEmail: rejectedEmail ?? this.rejectedEmail,
      acceptedEmail: acceptedEmail ?? this.acceptedEmail,
      roleStatus: roleStatus ?? this.roleStatus,
      pendingCount: pendingCount ?? this.pendingCount,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMsg,
    role,
    email,
    name,
    userInfo,
    uid,
    imagePath,
    joinRequestList,
    itemCount,
    boardId,
    rejectedEmail,
    acceptedEmail,
    roleStatus,
    pendingCount,
  ];
}

class AllUserInfo {
  final String uid;
  final String name;
  final String email;

  AllUserInfo({required this.uid, required this.email, required this.name});
}
