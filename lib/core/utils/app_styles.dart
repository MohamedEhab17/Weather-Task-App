import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/constants/app_font_family.dart';

abstract class AppStyles {
  // Roboto
  static TextStyle styleRoboto24 = TextStyle(
    fontSize: 24.sp,
    fontFamily: AppFontFamily.roboto,
    fontWeight: FontWeight.w600,
  );
  static TextStyle styleRoboto16 = TextStyle(
    fontSize: 16.sp,
    fontFamily: AppFontFamily.roboto,
    fontWeight: FontWeight.w400,
  );
  static TextStyle styleRoboto12 = TextStyle(
    fontSize: 12.sp,
    fontFamily: AppFontFamily.roboto,
    fontWeight: FontWeight.w600,
  );
  static TextStyle styleRoboto20 = TextStyle(
    fontSize: 20.sp,
    fontFamily: AppFontFamily.roboto,
    fontWeight: FontWeight.w600,
  );

  // Inter
  static TextStyle styleInter8 = TextStyle(
    fontSize: 8.sp,
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w400,
  );
  static TextStyle styleInter10 = TextStyle(
    fontSize: 10.sp,
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w500,
  );
  static TextStyle styleInter12 = TextStyle(
    fontSize: 12.sp,
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w500,
  );
  static TextStyle styleInter14 = TextStyle(
    fontSize: 14.sp,
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w500,
  );
  static TextStyle styleInter16 = TextStyle(
    fontSize: 16.sp,
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w500,
  );
  static TextStyle styleInter18 = TextStyle(
    fontSize: 18.sp,
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w600,
  );
  static TextStyle styleInter20 = TextStyle(
    fontSize: 20.sp,
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w500,
  );
  static TextStyle styleInter24 = TextStyle(
    fontSize: 24.sp,
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w600,
  );
  static TextStyle styleInter32 = TextStyle(
    fontSize: 32.sp,
    fontFamily: AppFontFamily.inter,
    fontWeight: FontWeight.w500,
  );

  // ScriptMT
  static TextStyle styleScriptMT32 = TextStyle(
    fontSize: 32.sp,
    fontFamily: AppFontFamily.scriptMT,
    fontWeight: FontWeight.w400,
  );
}
