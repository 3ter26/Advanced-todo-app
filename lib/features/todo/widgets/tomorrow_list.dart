import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/common/utils/constants.dart';
import 'package:todo_app/common/widgets/expansion_tile.dart';
import 'package:todo_app/features/todo/controllers/todo/todo_provider.dart';
import 'package:todo_app/features/todo/controllers/xpansion_provider.dart';
import 'package:todo_app/features/todo/pages/update_task.dart';
import 'package:todo_app/features/todo/widgets/todo_tile.dart';

class TomorrowList extends ConsumerWidget {
  const TomorrowList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider); //here we gwt the list
    var color = ref.read(todoProvider.notifier).getRandomColor();
    String tomorrow =
        ref.read(todoProvider.notifier).getTomorrow(); //here we get tmw's date
    var tomorrowTasks =
        todos.where((element) => element.date!.contains(tomorrow));

    return XpansionTile(
        text: "Tomorrow's Task",
        text2: "Tomorrow's tasks are shown here",
        onExpansionChanged: (bool expanded) {
          ref.read(xpansionProvider.notifier).setStart(!expanded);
        },
        trailing: Padding(
          padding: EdgeInsets.only(right: 12.0.w),
          child: ref.watch(xpansionProvider)
              ? const Icon(
                  AntDesign.circledown,
                )
              : const Icon(
                  AntDesign.closecircleo,
                ),
        ),
        children: [
          for (final todo in tomorrowTasks)
            TodoTile(
              color: color,
              title: todo.title,
              desc: todo.desc,
              start: todo.startTime,
              end: todo.endTime,
              delete: () {
                ref.read(todoProvider.notifier).deleteTodo(todo.id ?? 0);
              },
              editWidget: GestureDetector(
                onTap: () {
                  titles = todo.title.toString();
                  descs = todo.desc.toString();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateTask(
                                id: todo.id ?? 0,
                              )));
                },
                child: const Icon(MaterialCommunityIcons.circle_edit_outline),
              ),
              switcher: const SizedBox.shrink(),
            ),
        ]);
  }
}
