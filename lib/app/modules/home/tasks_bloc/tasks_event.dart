import 'package:task_manager/app/shared/models/task.dart';

const int tasksLimit = 20;

abstract class TaskEvent {
  const TaskEvent();
}

class TasksRequested extends TaskEvent {
  final int skip;
  final int limit;
  final int total;

  const TasksRequested({
    required this.skip,
    required this.total,
    this.limit = tasksLimit,
  });
}

class TaskAdded extends TaskEvent {
  final Task task;

  const TaskAdded({required this.task});
}

class TaskUpdated extends TaskEvent {
  final Task task;

  const TaskUpdated({required this.task});
}

class TaskDeleted extends TaskEvent {
  final Task task;

  const TaskDeleted({required this.task});
}
