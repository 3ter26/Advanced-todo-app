import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/common/utils/constants.dart';
import 'package:todo_app/common/widgets/appstyle.dart';
import 'package:todo_app/common/widgets/custom_otn_btn.dart';
import 'package:todo_app/common/widgets/custom_text.dart';
import 'package:todo_app/common/widgets/height_spacer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:todo_app/features/todo/controllers/dates/dates_provider.dart';
import 'package:todo_app/features/todo/controllers/todo/todo_provider.dart';

class UpdateTask extends ConsumerStatefulWidget {
  const UpdateTask({
    super.key,
    required this.id,
  });
  final int id;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UpdateTaskState();
  }
}

class _UpdateTaskState extends ConsumerState<UpdateTask> {
  final TextEditingController title = TextEditingController(text: titles);
  final TextEditingController desc = TextEditingController(text: descs);

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
                        minTime: DateTime(2020, 5, 5, 20, 50),
                        maxTime: DateTime(2020, 6, 7, 05, 09),
                        onConfirm: (date) {
                      ref
                          .read(startTimeProvider.notifier)
                          .setStart(date.toString());
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
                  ref.read(todoProvider.notifier).updateItem(
                        widget.id,
                        title.text,
                        desc.text,
                        0,
                        scheduleDate,
                        start.substring(10, 16),
                        finish.substring(10, 16),
                      );
                  ref.read(finishTimeProvider.notifier).setFinish('');
                  ref.read(startTimeProvider.notifier).setStart('');
                  ref.read(dateProvider.notifier).setDate('');
                  Navigator.pop(context);
                } else {
                  // ignore: avoid_print
                  print("Failed to add tasks");
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
