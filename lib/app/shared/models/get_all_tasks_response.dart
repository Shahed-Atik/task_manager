import 'package:task_manager/app/shared/models/task.dart';

class GetAllTasksResponse {
  final List<Task> tasks;
  final int total;
  final int skip;
  final int limit;

  GetAllTasksResponse({
    required this.tasks,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory GetAllTasksResponse.fromMap(Map<String, dynamic> map) {
    return GetAllTasksResponse(
      tasks: tasksListFromMap(map['todos']),
      total: map['total'] as int,
      skip: map['skip'] as int,
      limit: map['limit'] as int,
    );
  }
}
