import 'package:flutter/material.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';

class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppbar({
    super.key,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.leading,
    this.automaticallyImplyLeading,
    this.actions,
    this.bgColor,
  });

  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Widget? leading;
  final bool? automaticallyImplyLeading;
  final List<Widget>? actions;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading ?? false,
      backgroundColor: bgColor ?? kColorWhite,
      forceMaterialTransparency: true,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle ??
                TextStyles.kRegularDMSans(
                  fontSize: FontSizes.k24FontSize,
                  color: kColorTextPrimary,
                ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: subtitleStyle ??
                  TextStyles.kRegularDMSans(
                    fontSize: FontSizes.k16FontSize,
                    color: kColorTextPrimary,
                  ),
            ),
        ],
      ),
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
