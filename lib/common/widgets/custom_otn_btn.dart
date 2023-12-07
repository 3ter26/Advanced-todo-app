import 'package:flutter/material.dart';
import 'package:todo_app/common/widgets/appstyle.dart';
import 'package:todo_app/common/widgets/reusable_text.dart';

class CustomOtlnBtn extends StatelessWidget {
  const CustomOtlnBtn({
    super.key,
    this.onTap,
    required this.height,
    required this.width,
    this.color2,
    required this.color,
    required this.text,
  });

  final void Function()? onTap;
  final double width;
  final double height;
  final Color? color2;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color2,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(width: 1, color: color),
        ),
        child: Center(
          child: ReusableText(
              text: text, style: appstyle(18, color, FontWeight.bold)),
        ),
      ),
    );
  }
}
