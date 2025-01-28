import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/extensions/app_size_extensions.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';

class AppDatePickerTextFormField extends StatefulWidget {
  const AppDatePickerTextFormField({
    super.key,
    required this.dateController,
    required this.hintText,
    this.fillColor,
    this.enabled = true,
    this.validator,
    this.onChanged,
  });

  final TextEditingController dateController;
  final String hintText;
  final Color? fillColor;
  final bool enabled;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChanged;

  @override
  State<AppDatePickerTextFormField> createState() =>
      _AppDatePickerTextFormFieldState();
}

class _AppDatePickerTextFormFieldState
    extends State<AppDatePickerTextFormField> {
  static const String dateFormat = 'dd-MM-yyyy';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate =
        _parseDate(widget.dateController.text) ?? DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: kColorPrimary,
            colorScheme: const ColorScheme.light(
              primary: kColorPrimary,
              onPrimary: kColorWhite,
              surface: kColorWhite,
            ),
            textTheme: TextTheme(
              headlineLarge: TextStyles.kRegularDMSans(
                fontSize: FontSizes.k24FontSize,
                color: kColorBlack,
              ),
              bodyLarge: TextStyles.kRegularDMSans(
                fontSize: FontSizes.k16FontSize,
                color: kColorBlack,
              ),
              titleLarge: TextStyles.kRegularDMSans(
                fontSize: FontSizes.k18FontSize,
                color: kColorBlack,
              ),
              displayLarge: TextStyles.kRegularDMSans(
                fontSize: FontSizes.k18FontSize,
                color: kColorBlack,
              ),
              labelLarge: TextStyles.kRegularDMSans(
                fontSize: FontSizes.k18FontSize,
                color: kColorBlack,
              ),
            ),
            dialogBackgroundColor: kColorWhite,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(
        () {
          widget.dateController.text =
              DateFormat(dateFormat).format(pickedDate);
        },
      );

      if (widget.onChanged != null) {
        widget.onChanged!(widget.dateController.text);
      }
    }
  }

  DateTime? _parseDate(String dateString) {
    try {
      return DateFormat(dateFormat).parseStrict(dateString);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.dateController,
      cursorColor: kColorTextPrimary,
      cursorHeight: 20,
      enabled: widget.enabled,
      validator: widget.validator,
      style: TextStyles.kMediumDMSans(
        fontSize: FontSizes.k18FontSize,
        color: kColorTextPrimary,
      ),
      readOnly: true,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyles.kRegularDMSans(
          fontSize: FontSizes.k16FontSize,
          color: kColorGrey,
        ),
        errorStyle: TextStyles.kRegularDMSans(
          fontSize: FontSizes.k16FontSize,
          color: kColorRed,
        ),
        border: outlineInputBorder(
          borderColor: kColorLightGrey,
          borderWidth: 1,
        ),
        focusedBorder: outlineInputBorder(
          borderColor: kColorTextPrimary,
          borderWidth: 1,
        ),
        enabledBorder: outlineInputBorder(
          borderColor: kColorLightGrey,
          borderWidth: 1,
        ),
        errorBorder: outlineInputBorder(
          borderColor: kColorRed,
          borderWidth: 1,
        ),
        contentPadding: AppPaddings.combined(
          horizontal: 16.appWidth,
          vertical: 8.appHeight,
        ),
        filled: true,
        fillColor: widget.fillColor ?? kColorLightGrey,
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.calendar_today_rounded,
            size: 20,
            color: kColorTextPrimary,
          ),
          onPressed: widget.enabled ? () => _selectDate(context) : null,
        ),
        suffixIconColor: kColorTextPrimary,
      ),
    );
  }

  OutlineInputBorder outlineInputBorder({
    required Color borderColor,
    required double borderWidth,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }
}
