import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qahwati/core/colors.dart';

class TextStyles {
  final BuildContext context;
  const TextStyles(this.context);

  TextStyle get font12GraykRegular => TextStyle(
        fontSize: 12.sp,
        color: ColorsManager.gray,
        fontWeight: FontWeight.w400,
      );

  TextStyle get font14GrayRegular => TextStyle(
        fontSize: 14.sp,
        color: ColorsManager.gray,
        fontWeight: FontWeight.w400,
      );

  TextStyle get font14BlackRegular => TextStyle(
        fontSize: 14.sp,
        color: ColorsManager.dark,
        fontWeight: FontWeight.w400,
      );

  TextStyle get font16BlackRegular => TextStyle(
        fontSize: 16.sp,
        color: ColorsManager.dark,
        fontWeight: FontWeight.w400,
      );

  TextStyle get font16DarkBold => TextStyle(
        fontSize: 16.sp,
        color: ColorsManager.dark,
        fontWeight: FontWeight.w700,
      );

  TextStyle get font14PrimaryRegular => TextStyle(
        fontSize: 14.sp,
        color: ColorsManager.kPrimaryColor,
        fontWeight: FontWeight.w400,
      );

  TextStyle get font14WhiteRegular => TextStyle(
        fontSize: 14.sp,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      );

  TextStyle get font18BlackMedium => TextStyle(
        fontSize: 18.sp,
        color: ColorsManager.dark,
        fontWeight: FontWeight.w500,
      );

  TextStyle get font20DarkBold => TextStyle(
        fontSize: 20.sp,
        color: ColorsManager.dark,
        fontWeight: FontWeight.w700,
      );
}
