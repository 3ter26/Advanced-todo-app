import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/common/utils/constants.dart';
import 'package:todo_app/common/widgets/custom_otn_btn.dart';
import 'package:todo_app/common/widgets/height_spacer.dart';
import 'package:todo_app/features/auth/pages/login_page.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConst.kHeight,
      width: AppConst.kWidth,
      color: AppConst.kBkDark,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 80.w),
            child: Image.asset("assets/images/todo.png"),
          ),
          const HeightSpacer(hieght: 50),
          CustomOtlnBtn(
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            height: AppConst.kHeight * 0.06,
            width: AppConst.kWidth * 0.9,
            color: AppConst.kLight,
            text: "Login with a phone number",
          )
        ],
      ),
    );
  }
}
