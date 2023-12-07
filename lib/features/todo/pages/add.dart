import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/common/helpers/notifications_helper.dart';
import 'package:todo_app/common/models/task_model.dart';
import 'package:todo_app/common/utils/constants.dart';
import 'package:todo_app/common/widgets/appstyle.dart';
import 'package:todo_app/common/widgets/custom_otn_btn.dart';
import 'package:todo_app/common/widgets/custom_text.dart';
import 'package:todo_app/common/widgets/height_spacer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:todo_app/common/widgets/showDialog.dart';
import 'package:todo_app/features/todo/controllers/dates/dates_provider.dart';
import 'package:todo_app/features/todo/controllers/todo/todo_provider.dart';
import 'package:todo_app/features/todo/pages/homepage.dart';

class AddTasks extends ConsumerStatefulWidget {
  const AddTasks({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddTasksState();
  }
}

class _AddTasksState extends ConsumerState<AddTasks> {
  final TextEditingController title = TextEditingController();
  final TextEditingController desc = TextEditingController();
  List<int> notification = [];
  late NotificationsHelper notifierHelper;
  late NotificationsHelper controller;
  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    notifierHelper = NotificationsHelper(ref: ref);
    Future.delayed(const Duration(seconds: 0), () {
      controller = NotificationsHelper(ref: ref);
    });
    notifierHelper.intializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    var scheduleDate = ref.watch(dateProvider);
    var start = ref.watch(startTimeProvider);
    var finish = ref.watch(finishTimeProvider);
    ref.watch(todoProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: ListView(
          children: [
            const HeightSpacer(hieght: 20),
            CustomTextField(
              hintText: "Add title",
              controller: title,
              hintStyle: appstyle(16, AppConst.kGreyLight, FontWeight.w600),
            ),
            const HeightSpacer(hieght: 20),
            CustomTextField(
              hintText: "Add Description",
              controller: desc,
              hintStyle: appstyle(16, AppConst.kGreyLight, FontWeight.w600),
            ),
            const HeightSpacer(hieght: 20),
            CustomOtlnBtn(
              onTap: () {
                picker.DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(2023, 9, 1),
                    maxTime: DateTime(2024, 8, 1),
                    theme: const picker.DatePickerTheme(
                        doneStyle:
                            TextStyle(color: AppConst.kGreen, fontSize: 16)),
                    onConfirm: (date) {
                  ref.read(dateProvider.notifier).setDate(date.toString());
                }, currentTime: DateTime.now(), locale: picker.LocaleType.en);
              },
              height: 52.h,
              width: AppConst.kWidth,
              color: AppConst.kLight,
              color2: AppConst.kBlueLight,
              text: scheduleDate == ""
                  ? "Set Date"
                  : scheduleDate.substring(0, 10),
            ),
            const HeightSpacer(hieght: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomOtlnBtn(
                  onTap: () {
                    picker.DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        //minTime: DateTime(2020, 5, 5, 20, 50),
                        //maxTime: DateTime(2020, 6, 7, 05, 09),
                        onConfirm: (date) {
                      ref
                          .read(startTimeProvider.notifier)
                          .setStart(date.toString());
                      notification =
                          ref.read(startTimeProvider.notifier).dates(date);
                    }, locale: picker.LocaleType.en);
                  },
                  height: 52.h,
                  width: AppConst.kWidth * 0.4,
                  color: AppConst.kLight,
                  color2: AppConst.kBlueLight,
                  text: start == "" ? "Start Time" : start.substring(10, 16),
                ),
                CustomOtlnBtn(
                  onTap: () {
                    picker.DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2020, 5, 5, 20, 50),
                        maxTime: DateTime(2020, 6, 7, 05, 09),
                        onConfirm: (date) {
                      ref
                          .read(finishTimeProvider.notifier)
                          .setFinish(date.toString());
                    }, locale: picker.LocaleType.en);
                  },
                  height: 52.h,
                  width: AppConst.kWidth * 0.4,
                  color: AppConst.kLight,
                  color2: AppConst.kBlueLight,
                  text: finish == "" ? "End Time" : finish.substring(10, 16),
                ),
              ],
            ),
            const HeightSpacer(hieght: 20),
            CustomOtlnBtn(
              onTap: () {
                if (title.text.isNotEmpty &&
                    desc.text.isNotEmpty &&
                    scheduleDate.isNotEmpty &&
                    start.isNotEmpty &&
                    finish.isNotEmpty) {
                  Task task = Task(
                      title: title.text,
                      desc: desc.text,
                      isCompleted: 0,
                      date: scheduleDate,
                      startTime: start.substring(10, 16),
                      endTime: finish.substring(10, 16),
                      remind: 0,
                      repeat: "yes");
                  notifierHelper.scheduledNotification(notification[0],
                      notification[1], notification[2], notification[3], task);
                  ref.read(todoProvider.notifier).addItem(task);
                  //ref.read(finishTimeProvider.notifier).setFinish('');
                  //ref.read(startTimeProvider.notifier).setStart('');
                  //ref.read(dateProvider.notifier).setDate('');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                } else {
                  showAlertDialog(
                      context: context, message: "Failed to add task");
                }
              },
              height: 52.h,
              width: AppConst.kWidth,
              color: AppConst.kLight,
              color2: AppConst.kGreen,
              text: "Submit",
            ),
          ],
        ),
      ),
    );
  }
}
