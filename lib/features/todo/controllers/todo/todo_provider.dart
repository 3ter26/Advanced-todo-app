import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/common/helpers/db_helper.dart';
import 'package:todo_app/common/models/task_model.dart';
import 'package:todo_app/common/utils/constants.dart';

class TodoNotifier extends StateNotifier<List<Task>> {
  TodoNotifier() : super([]);

  void refresh() async {
    final data = await DbHelper.getItems();
    state = data.map((e) => Task.fromJson(e)).toList();
  }

  void addItem(Task task) async {
    await DbHelper.createItem(task);
    refresh();
  }

  dynamic getRandomColor() {
    Random random = Random();
    int randomIndex = random.nextInt(colors.length);
    return colors[randomIndex];
  }

  void updateItem(
    int id,
    String title,
    String desc,
    int isCompleted,
    String date,
    String startTime,
    String endTime,
  ) async {
    await DbHelper.updateItem(
        id, title, desc, isCompleted, date, startTime, endTime);
    refresh();
  }

  Future<void> deleteTodo(int id) async {
    await DbHelper.deleteItem(id);
    refresh();
  }

  void markAsCompleted(
    int id,
    String title,
    String desc,
    int isCompleted,
    String date,
    String startTime,
    String endTime,
  ) async {
    await DbHelper.updateItem(id, title, desc, 1, date, startTime, endTime);
    refresh();
  }

//today
  String getToday() {
    DateTime today = DateTime.now();
    return today.toString().substring(0, 10);
  }

//tomorrow
  String getTomorrow() {
    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.toString().substring(0, 10);
  }

  String getDayAfter() {
    DateTime tomorrow = DateTime.now().add(const Duration(days: 2));
    return tomorrow.toString().substring(0, 10);
  }

//afterTomorrow
  List<String> last30days() {
    DateTime today = DateTime.now();
    DateTime oneMonthAgo = today.subtract(const Duration(days: 30));
    List<String> dates = [];
    for (int i = 0; i < 30; i++) {
      DateTime date = oneMonthAgo.add(Duration(days: i));
      dates.add(date.toString().substring(0, 10));
    }
    return dates;
  }

  bool getStatus(Task data) {
    bool? isCompleted;

    if (data.isCompleted == 0) {
      isCompleted = false;
    } else {
      isCompleted = true;
    }
    return isCompleted;
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Task>>((ref) {
  return TodoNotifier();
});
