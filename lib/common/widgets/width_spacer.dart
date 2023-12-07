import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidthSpacer extends StatelessWidget {
  const WidthSpacer({
    super.key,
    required this.wdith,
  });

  final double wdith;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wdith.w,
    );
  }
}
