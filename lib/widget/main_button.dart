import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qahwati/core/colors.dart';
import 'package:qahwati/core/theme/text_style.dart';

class MainButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final bool outlined;
  final Widget? child;

  const MainButton({
    super.key,
    this.text = '',
    this.onTap,
    this.width,
    this.height,
    this.color,
    this.textColor,
    this.outlined = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: (height ?? 52).h,
        decoration: BoxDecoration(
          color: outlined
              ? ColorsManager.lightButton
              : (color ?? ColorsManager.coffeeButton),
          borderRadius: BorderRadius.circular(100.r),
        ),
        alignment: Alignment.center,
        child: child ??
            Text(
              text,
              style: TextStyles(context).font16BlackRegular.copyWith(
                    color: textColor ?? Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
      ),
    );
  }
}
