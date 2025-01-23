import 'package:flutter/material.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/fonts.dart';

class TextStyles {
  static TextStyle kRegularDMSans({
    double fontSize = FontSizes.k20FontSize,
    Color color = kColorTextPrimary,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.dmSansRegular,
    );
  }

  static TextStyle kMediumDMSans({
    double fontSize = FontSizes.k20FontSize,
    Color color = kColorTextPrimary,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.dmSansMedium,
    );
  }

  static TextStyle kSemiBoldDMSans({
    double fontSize = FontSizes.k20FontSize,
    Color color = kColorTextPrimary,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.dmSansSemiBold,
    );
  }

  static TextStyle kBoldDMSans({
    double fontSize = FontSizes.k20FontSize,
    Color color = kColorTextPrimary,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.dmSansBold,
    );
  }
}
