// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:todo_app/common/models/task_model.dart';
import 'package:todo_app/common/utils/constants.dart';
import 'package:todo_app/features/todo/controllers/todo/todo_provider.dart';
import 'package:todo_app/features/todo/pages/update_task.dart';
import 'package:todo_app/features/todo/widgets/todo_tile.dart';

class TodayTask extends ConsumerWidget {
  const TodayTask({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Task> listData = ref.watch(todoProvider);
    //String today = ref.read(todoProvider.notifier).getToday();
    var todayList =
        listData.where((element) => element.isCompleted == 0).toList();
    return ListView.builder(
        itemCount: todayList.length,
        itemBuilder: (context, index) {
          final data = todayList[index];
          bool isCompleted = ref.read(todoProvider.notifier).getStatus(data);
          dynamic color = ref.read(todoProvider.notifier).getRandomColor();
          return TodoTile(
            delete: () {
              ref.read(todoProvider.notifier).deleteTodo(data.id ?? 0);
            },
            editWidget: GestureDetector(
              onTap: () {
                titles = data.title.toString();
                descs = data.desc.toString();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateTask(
                              id: data.id ?? 0,
                            )));
              },
              child: const Icon(MaterialCommunityIcons.circle_edit_outline),
            ),
            title: data.title,
            color: color,
            desc: data.desc,
            start: data.startTime,
            end: data.endTime,
            switcher: Switch(
              value: isCompleted,
              onChanged: (value) {
                ref.read(todoProvider.notifier).markAsCompleted(
                    data.id ?? 0,
                    data.title.toString(),
                    data.desc.toString(),
                    1,
                    data.date.toString(),
                    data.startTime.toString(),
                    data.endTime.toString());
              },
            ),
          );
        });
  }
}
