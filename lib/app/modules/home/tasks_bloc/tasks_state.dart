import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:task_manager/app/shared/models/task.dart';

class TasksState {
  const TasksState(
      {required this.pagingState, required this.totalTasks, this.error});

  final PagingState<int, Task> pagingState;

  final int totalTasks;

  final String? error;

  factory TasksState.init() => const TasksState(
      pagingState: PagingState(nextPageKey: 0), totalTasks: 1000);

  TasksState copyWith(
      {PagingState<int, Task>? pagingState, String? error, int? totalTasks}) {
    return TasksState(
        pagingState: pagingState ?? this.pagingState,
        error: error ?? this.error,
        totalTasks: totalTasks ?? this.totalTasks);
  }
}
