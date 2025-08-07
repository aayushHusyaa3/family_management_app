part of 'fetch_tasks_cubit.dart';

enum FetchTasksStatus {
  initialFetching,
  fetching,
  fetched,
  fetchingError,

  fetchedStatusTasks,
  fetchingStatusTasks,
  fetchingStatusTasksError,

  deleting,
  deletingFailed,
  deleted,

  marking,
  markingFailed,
  marked,
}

class FetchTasksState extends Equatable {
  final FetchTasksStatus status;
  final String? errorMsg;
  final int? taskCount;
  final List<TaskInfo>? taskInfoList;
  final String? taskId;
  final int? urgentCount;

  const FetchTasksState({
    this.status = FetchTasksStatus.initialFetching,
    this.errorMsg,
    this.taskCount,
    this.taskInfoList,
    this.taskId,
    this.urgentCount,
  });

  FetchTasksState copyWith({
    FetchTasksStatus? status,
    String? errorMsg,
    int? taskCount,
    List<TaskInfo>? taskInfoList,
    String? taskId,
    int? urgentCount,
  }) {
    return FetchTasksState(
      errorMsg: errorMsg ?? this.errorMsg,
      status: status ?? this.status,
      taskCount: taskCount ?? this.taskCount,
      taskInfoList: taskInfoList ?? this.taskInfoList,
      taskId: taskId ?? this.taskId,
      urgentCount: urgentCount ?? this.urgentCount,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMsg,
    taskCount,
    taskInfoList,
    taskId,
    urgentCount,
  ];
}

class TaskInfo {
  String title;
  String taskId;
  String description;
  String priority;
  String date;
  String? assignedTo;
  bool isChecked;
  TaskInfo({
    required this.title,
    required this.taskId,
    required this.description,
    required this.priority,
    required this.date,
    this.assignedTo,
    this.isChecked = false,
  });
}
