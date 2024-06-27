import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/app/shared/models/task.dart';
import 'package:task_manager/app/shared/models/user.dart';

class LocalStorageService {
  final SharedPreferences _preferences;

  static const userKey = "user";
  static const tasksKey = "tasks";

  LocalStorageService(this._preferences);

  Future<bool> setUser(User user) async {
    return await _preferences.setString(userKey, jsonEncode(user.toMap()));
  }

  User? getUser() {
    String? user = _preferences.getString("user");
    if (user != null) {
      return User.fromMap(jsonDecode(user));
    }
    return null;
  }

  Future<bool> deleteUserData() async {
    return await _preferences.clear();
  }

  //tasks storage
  Future<bool> deleteTasks() async {
    return await _preferences.remove(tasksKey);
  }

  Future<bool> setTasks(List<Task> tasks) async {
    List<Task>? oldTasks = getTasks();
    List<Task> newTasks = [];
    if (oldTasks != null) {
      newTasks = List.of(oldTasks);
      newTasks.addAll(tasks);
    }
    return await _preferences.setString(tasksKey, Task.encode(newTasks));
  }

  List<Task>? getTasks() {
    String? encodedTasks = _preferences.getString(tasksKey);
    if (encodedTasks != null) {
      return Task.decode(encodedTasks);
    }
    return null;
  }
}
