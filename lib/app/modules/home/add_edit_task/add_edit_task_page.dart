import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app/modules/app_bloc/app_bloc.dart';
import 'package:task_manager/app/modules/home/tasks_bloc/tasks_bloc.dart';
import 'package:task_manager/app/modules/home/tasks_bloc/tasks_event.dart';
import 'package:task_manager/app/shared/models/task.dart';

class AddEditTodoPage extends StatefulWidget {
  const AddEditTodoPage({super.key, this.task});
  final Task? task;

  @override
  State<AddEditTodoPage> createState() => _AddEditTodoPageState();
}

class _AddEditTodoPageState extends State<AddEditTodoPage> {
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    if (widget.task != null) {
      textEditingController.text = widget.task?.todo ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: textEditingController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (widget.task != null) {
                  context.read<TasksBloc>().add(TaskUpdated(
                      task: widget.task!
                          .copyWith(todo: textEditingController.text)));
                } else {
                  context.read<TasksBloc>().add(
                        TaskAdded(
                          task: Task(
                              todo: textEditingController.text,
                              id: 0,
                              userId: context.read<AppBloc>().state.user!.id,
                              completed: false),
                        ),
                      );
                }
                Navigator.of(context).pop();
              },
              child: Text(widget.task == null ? 'Add' : "Edit"),
            ),
          ],
        ),
      ),
    );
  }
}
