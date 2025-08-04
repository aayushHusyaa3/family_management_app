part of 'add_tasks_cubit.dart';

enum PostStatus {
  initalPosting,
  emptyPosting,
  posting,
  posted,
  postingFailed,

  deleting,
  deletingFailed,
  deleted,

  marking,
  markingFailed,
  marked,
}

class AddTasksState extends Equatable {
  final PostStatus? status;
  final String? errorMsg;
  final String? taskId;
  final List<TaskInfo>? tasks;

  const AddTasksState({this.errorMsg, this.status, this.tasks, this.taskId});
  AddTasksState copyWith({
    PostStatus? status,
    String? errorMsg,
    String? taskId,
    List<TaskInfo>? tasks,
  }) {
    return AddTasksState(
      errorMsg: errorMsg ?? this.errorMsg,
      status: status ?? this.status,
      taskId: taskId ?? this.taskId,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props => [errorMsg, status, tasks];
}
