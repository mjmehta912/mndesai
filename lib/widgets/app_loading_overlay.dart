import 'package:flutter/material.dart';
import 'package:mndesai/constants/color_constants.dart';

class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: kColorBlackWithOpacity,
          ),
        ),
        Center(
          child: CircularProgressIndicator(
            color: kColorWhite,
          ),
        ),
      ],
    );
  }
}
