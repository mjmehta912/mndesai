import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/extensions/app_size_extensions.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';

class AppDropdown extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    required this.hintText,
    this.searchHintText,
    this.fillColor,
    this.showSearchBox,
    required this.onChanged,
    this.validatorText,
    this.enabled,
  });

  final List<String> items;
  final String? selectedItem;
  final String hintText;
  final String? searchHintText;
  final Color? fillColor;
  final bool? showSearchBox;
  final ValueChanged<String?>? onChanged;
  final String? validatorText;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      selectedItem: selectedItem,
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorText;
        }
        return null;
      },
      items: (filter, infiniteScrollProps) => items,
      enabled: enabled ?? true,
      decoratorProps: DropDownDecoratorProps(
        baseStyle: TextStyles.kMediumDMSans(
          fontSize: FontSizes.k16FontSize,
          color: kColorTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
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
          disabledBorder: outlineInputBorder(
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
          fillColor: fillColor ?? kColorLightGrey,
          suffixIconColor: kColorTextPrimary,
        ),
      ),
      popupProps: PopupProps.menu(
        fit: FlexFit.loose,
        constraints: BoxConstraints(
          maxHeight: 300,
        ),
        menuProps: MenuProps(
          backgroundColor: kColorWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        itemBuilder: (context, item, isDisabled, isSelected) => Padding(
          padding: AppPaddings.p10,
          child: Text(
            item,
            style: TextStyles.kRegularDMSans(
              color: kColorTextPrimary,
              fontSize: FontSizes.k16FontSize,
            ).copyWith(
              height: 1.25,
            ),
          ),
        ),
        showSearchBox: showSearchBox ?? true,
        searchFieldProps: TextFieldProps(
          style: TextStyles.kRegularDMSans(
            fontSize: FontSizes.k16FontSize,
            color: kColorTextPrimary,
          ),
          cursorColor: kColorTextPrimary,
          cursorHeight: 20,
          decoration: InputDecoration(
            hintText: searchHintText ?? 'Search',
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
            fillColor: fillColor ?? kColorLightGrey,
            suffixIconColor: kColorTextPrimary,
          ),
        ),
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
