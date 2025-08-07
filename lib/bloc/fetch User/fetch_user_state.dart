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
  final String? uid;
  final List<AllUserInfo>? userInfo;
  const FetchUserState({
    required this.status,
    this.errorMsg,
    this.role,
    this.email,
    this.name,
    this.userInfo,
    this.uid,
  });

  FetchUserState copyWith({
    FetchUserStatus? status,
    String? errorMsg,
    String? role,
    String? email,
    String? name,
    List<AllUserInfo>? userInfo,
    final String? uid,
  }) {
    return FetchUserState(
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
      role: role ?? this.role,
      email: email ?? this.email,
      name: name ?? this.name,
      userInfo: userInfo ?? this.userInfo,
      uid: uid ?? this.uid,
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
  ];
}

class AllUserInfo {
  final String uid;
  final String name;
  final String email;

  AllUserInfo({required this.uid, required this.email, required this.name});
}
