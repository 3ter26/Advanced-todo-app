import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/common/utils/constants.dart';
import 'package:todo_app/common/widgets/appstyle.dart';
import 'package:todo_app/common/widgets/height_spacer.dart';
import 'package:todo_app/common/widgets/reusable_text.dart';
import 'package:todo_app/common/widgets/width_spacer.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({
    super.key,
    this.payload,
  });

  final String? payload;
  @override
  Widget build(BuildContext context) {
    var title = payload!.split('|')[0];
    var desc = payload!.split('|')[1];
    var date = payload!.split('|')[2];
    var start = payload!.split('|')[3];
    var end = payload!.split('|')[4];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
          child: Stack(
        clipBehavior: Clip
            .none, //this will not make things to be 'Clip'. It wil make things 'Overlap'.
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
            child: Container(
              width: AppConst.kWidth,
              height: AppConst.kHeight * 0.7,
              decoration: BoxDecoration(
                color: AppConst.kBkLight,
                borderRadius:
                    BorderRadius.all(Radius.circular(AppConst.kRadius)),
              ),
              child: Padding(
                  padding: EdgeInsets.all(12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(
                        text: "Reminder",
                        style: appstyle(40, AppConst.kLight, FontWeight.bold),
                      ),
                      const HeightSpacer(hieght: 5),
                      Container(
                        width: AppConst.kWidth,
                        padding: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                            color: AppConst.kYellow,
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.h))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ReusableText(
                              text: "Today",
                              style: appstyle(
                                  16, AppConst.kBkDark, FontWeight.bold),
                            ),
                            const WidthSpacer(wdith: 15),
                            ReusableText(
                              text: "From : $start To : $end",
                              style: appstyle(
                                  15, AppConst.kBkDark, FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const HeightSpacer(hieght: 10),
                      ReusableText(
                        text: title,
                        style: appstyle(30, AppConst.kBkDark, FontWeight.bold),
                      ),
                      const HeightSpacer(hieght: 10),
                      Text(
                        desc,
                        maxLines: 8,
                        textAlign: TextAlign.justify,
                        style: appstyle(16, AppConst.kLight, FontWeight.normal),
                      ),
                    ],
                  )),
            ),
          ),
          Positioned(
              right: 10,
              top: 4.2,
              child: Image.asset(
                'assets/images/orig.png',
                width: 70.w,
                height: 70.h,
              ))
        ],
      )),
    );
  }
}
