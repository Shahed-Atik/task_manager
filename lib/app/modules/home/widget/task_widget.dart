import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_manager/app/modules/home/tasks_bloc/tasks_bloc.dart';
import 'package:task_manager/app/modules/home/tasks_bloc/tasks_event.dart';

import 'package:task_manager/app/shared/models/task.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  const TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    String taskStatus = task.completed ? 'Complete' : 'On-going';
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            autoClose: true,
            onPressed: (context) {
              context.read<TasksBloc>().add(TaskDeleted(task: task));
            },
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.all(20),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: [
          if (!task.completed)
            SlidableAction(
              autoClose: true,
              onPressed: (context) {
                context
                    .read<TasksBloc>()
                    .add(TaskUpdated(task: task.copyWith(completed: true)));
              },
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(20),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              icon: Icons.done,
              label: 'Complete',
            ),
        ],
      ),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                width: 2,
                color: task.completed
                    ? Theme.of(context).disabledColor
                    : Colors.transparent),
            color: task.completed
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.primaryContainer,
          ),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.todo,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: task.completed ? Colors.grey : null),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'by User ${task.userId}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: task.completed
                              ? Colors.grey
                              : const Color(0XFF322a1d).withOpacity(0.7)),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: task.completed
                            ? Colors.grey.withOpacity(0.8)
                            : Theme.of(context).colorScheme.surface,
                        child: Text(taskStatus,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: task.completed
                                    ? Theme.of(context).colorScheme.surface
                                    : Theme.of(context).primaryColor)),
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
