import 'package:flutter/material.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.color,
    this.fontSize,
    this.style,
  });

  final VoidCallback onPressed;
  final String title;
  final Color? color;
  final double? fontSize;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Text(
        title,
        style: style ??
            TextStyles.kBoldDMSans(
              color: color ?? kColorPrimary,
              fontSize: fontSize ?? FontSizes.k18FontSize,
            ).copyWith(
              height: 1,
              decoration: TextDecoration.underline,
              decorationColor: color ?? kColorPrimary,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
