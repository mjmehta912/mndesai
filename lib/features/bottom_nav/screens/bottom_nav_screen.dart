import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/features/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:mndesai/features/point_calculation/screens/point_calculation_screen.dart';
import 'package:mndesai/features/virtual_card_generation/screens/virtual_card_generation_screen.dart';
import 'package:mndesai/styles/font_sizes.dart';
import 'package:mndesai/styles/text_styles.dart';
import 'package:mndesai/utils/extensions/app_size_extensions.dart';
import 'package:mndesai/utils/screen_utils/app_paddings.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({
    super.key,
  });

  final BottomNavController _controller = Get.put(
    BottomNavController(),
  );

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  List<Widget> get pages => [
        Center(),
        PointCalculationScreen(),
        VirtualCardGenerationScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => pages[_controller.selectedIndex.value],
      ),
      bottomNavigationBar: Obx(
        () => Container(
          height: 0.075.screenHeight,
          padding: AppPaddings.p10,
          decoration: BoxDecoration(
            color: kColorPrimary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                label: 'Bill \nEntry',
                index: 0,
                isSelected: _controller.selectedIndex.value == 0,
                onTap: () {
                  _controller.changeIndex(0);
                  _navigatorKeys[0].currentState?.pushReplacementNamed('/');
                },
              ),
              _buildNavItem(
                label: 'Point \nCalculation',
                index: 1,
                isSelected: _controller.selectedIndex.value == 1,
                onTap: () {
                  _controller.changeIndex(1);
                  _navigatorKeys[1].currentState?.pushReplacementNamed('/');
                },
              ),
              _buildNavItem(
                label: 'Card \nGeneration',
                index: 2,
                isSelected: _controller.selectedIndex.value == 2,
                onTap: () {
                  _controller.changeIndex(2);
                  _navigatorKeys[2].currentState?.pushReplacementNamed('/');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Text(
        label,
        style: isSelected
            ? TextStyles.kBoldDMSans(
                color: kColorWhite,
                fontSize: FontSizes.k14FontSize,
              ).copyWith(
                height: 1,
              )
            : TextStyles.kSemiBoldDMSans(
                color: kColorWhite,
                fontSize: FontSizes.k12FontSize,
              ).copyWith(
                height: 1,
              ),
        textAlign: TextAlign.center,
      ),
    );
  }
}