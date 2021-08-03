import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/features/tasks/cubit/task_cubit.dart';
import 'package:todo/features/tasks/cubit/task_state.dart';
import 'package:todo/features/tasks/models/tasks_model.dart';
import 'package:todo/shared/styles/styles.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/helper_functions.dart';
import 'package:todo/utils/size_config.dart';

class TaskWidget extends StatelessWidget {
  final int? id;
  final String title;
  final String time;
  final String date;
  final Priority priority;
  final bool notification;
  final bool isDone;

  const TaskWidget(
      {required this.title,
      required this.time,
      required this.priority,
      required this.notification,
      required this.isDone,
      required this.id,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskStates>(
      builder: (context, state) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              color: Colors.red,
              icon: Icons.delete_forever,
              caption: "Delete",
              onTap: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text("Are you sure?"),
                          content: Text("Are you sure to delete this task?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  context.read<TaskCubit>().deleteTask(id);
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                )),
                          ],
                        ));
              },
            )
          ],
          child: Container(
            // margin: EdgeInsets.symmetric(vertical: 5 * heightMultiplier, horizontal: 7 * widthMultiplier),
            height: 13 * heightMultiplier,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.transparent),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.black12)),
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 5 * widthMultiplier,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                      color: isDone ? Colors.grey : getPriorityColor(priority),
                    ),
                  ),
                  Checkbox(
                    value: isDone,
                    onChanged: (bool? value) {
                      context.read<TaskCubit>().checkDone(Task(
                          id: id,
                          time: time,
                          title: title,
                          date: date,
                          notification: notification,
                          isDone: value ?? isDone,
                          priority: priority));
                    },
                    shape: CircleBorder(),
                  ),
                  Container(
                    child: Text(
                      title,
                      style: isDone ? doneTaskStyle() : null,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    width: 45 * widthMultiplier,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5 * widthMultiplier),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        time,
                        style: isDone ? doneTaskStyle() : null,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}