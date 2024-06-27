import 'dart:convert';

import 'package:equatable/equatable.dart';

List<Task> tasksListFromMap(List list) =>
    List<Task>.from(list.map((x) => Task.fromMap(x)));

class Task extends Equatable {
  final int id;
  final String todo;
  final bool completed;
  final int userId;

  const Task({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  Map<String, dynamic> toMap(Task task) {
    return {
      'todo': task.todo,
      'completed': task.completed,
      "id": task.id,
      "userId": task.userId
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      todo: map['todo'] as String,
      completed: map['completed'] as bool,
      userId: map['userId'] as int,
    );
  }

  static String encode(List<Task> tasks) => json.encode(
        tasks.map<Map<String, dynamic>>((task) => task.toMap(task)).toList(),
      );

  static List<Task> decode(String tasks) =>
      (json.decode(tasks) as List<dynamic>)
          .map<Task>((item) => Task.fromMap(item))
          .toList();

  Task copyWith({
    int? id,
    String? todo,
    bool? completed,
    int? userId,
  }) {
    return Task(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [id];
}
