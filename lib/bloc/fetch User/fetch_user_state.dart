part of 'fetch_user_cubit.dart';

enum FetchUserStatus {
  initialFetching,
  fetching,
  fetched,
  fetchingError,
  logout,

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
  final List<AllUserInfo>? userInfo;
  const FetchUserState({
    required this.status,
    this.errorMsg,
    this.role,
    this.email,
    this.name,
    this.userInfo,
  });

  FetchUserState copyWith({
    FetchUserStatus? status,
    String? errorMsg,
    String? role,
    String? email,
    String? name,
    final List<AllUserInfo>? userInfo,
  }) {
    return FetchUserState(
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
      role: role ?? this.role,
      email: email ?? this.email,
      name: name ?? this.name,
      userInfo: userInfo ?? this.userInfo,
    );
  }

  @override
  List<Object?> get props => [status, errorMsg, role, email, name, userInfo];
}

class AllUserInfo {
  final String uid;
  final String name;
  final String email;

  AllUserInfo({required this.uid, required this.email, required this.name});
}
