import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:todo_app/common/models/task_model.dart';
import 'package:todo_app/common/utils/constants.dart';
import 'package:todo_app/features/todo/controllers/todo/todo_provider.dart';
import 'package:todo_app/features/todo/widgets/todo_tile.dart';

class CompletedTask extends ConsumerWidget {
  const CompletedTask({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Task> listData = ref.watch(todoProvider);
    List lastMonth = ref.read(todoProvider.notifier).last30days();
    var completedList = listData
        .where((element) =>
            element.isCompleted == 1 ||
            lastMonth.contains(element.date!.substring(0, 10)))
        .toList();
    return ListView.builder(
        itemCount: completedList.length,
        itemBuilder: (context, index) {
          final data = completedList[index];
          dynamic color = ref.read(todoProvider.notifier).getRandomColor();
          return TodoTile(
              delete: () {
                ref.read(todoProvider.notifier).deleteTodo(data.id ?? 0);
              },
              editWidget: const SizedBox.shrink(),
              title: data.title,
              color: color,
              desc: data.desc,
              start: data.startTime,
              end: data.endTime,
              switcher: const Icon(
                AntDesign.checkcircle,
                color: AppConst.kGreen,
              ));
        });
  }
}
