import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateNotifier extends StateNotifier<String> {
  DateNotifier() : super("");

  void setDate(String newState) {
    state = newState;
  }
}

class StartTimeNotifier extends StateNotifier<String> {
  StartTimeNotifier() : super("");

  void setStart(String newState) {
    state = newState;
  }

  List<int> dates(DateTime startDate) {
    DateTime now = DateTime.now();
    Duration difference = startDate.difference(now);

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    return [days, hours, minutes, seconds];
  }
}

class FinishTimeNotifier extends StateNotifier<String> {
  FinishTimeNotifier() : super("");

  void setFinish(String newState) {
    state = newState;
  }
}

final dateProvider = StateNotifierProvider<DateNotifier, String>((ref) {
  return DateNotifier();
});
final startTimeProvider =
    StateNotifierProvider<StartTimeNotifier, String>((ref) {
  return StartTimeNotifier();
});
final finishTimeProvider =
    StateNotifierProvider<FinishTimeNotifier, String>((ref) {
  return FinishTimeNotifier();
});
