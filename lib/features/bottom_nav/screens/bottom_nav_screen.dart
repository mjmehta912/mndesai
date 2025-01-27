import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/constants/image_constants.dart';
import 'package:mndesai/features/bill_entry/screens/bill_entry_screen.dart';
import 'package:mndesai/features/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:mndesai/features/point_calculation/screens/point_calculation_screen.dart';
import 'package:mndesai/features/profile/screens/profile_screen.dart';
import 'package:mndesai/features/virtual_card_generation/screens/virtual_card_generation_screen.dart';

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
    GlobalKey<NavigatorState>(),
  ];

  List<Widget> get pages => [
        BillEntryScreen(),
        PointCalculationScreen(),
        VirtualCardGenerationScreen(),
        ProfileScreen(),
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
                icon: kIconBill,
                iconFilled: kIconBillFilled,
                index: 0,
                isSelected: _controller.selectedIndex.value == 0,
                onTap: () {
                  _controller.changeIndex(0);
                  _navigatorKeys[0].currentState?.pushReplacementNamed('/');
                },
              ),
              _buildNavItem(
                icon: kIconPoints,
                iconFilled: kIconPointsFilled,
                index: 1,
                isSelected: _controller.selectedIndex.value == 1,
                onTap: () {
                  _controller.changeIndex(1);
                  _navigatorKeys[1].currentState?.pushReplacementNamed('/');
                },
              ),
              _buildNavItem(
                icon: kIconVirtualCard,
                iconFilled: kIconVirtualCardFilled,
                index: 2,
                isSelected: _controller.selectedIndex.value == 2,
                onTap: () {
                  _controller.changeIndex(2);
                  _navigatorKeys[2].currentState?.pushReplacementNamed('/');
                },
              ),
              _buildNavItem(
                icon: kIconServices,
                iconFilled: kIconServicesFilled,
                index: 3,
                isSelected: _controller.selectedIndex.value == 3,
                onTap: () {
                  _controller.changeIndex(3);
                  _navigatorKeys[3].currentState?.pushReplacementNamed('/');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String iconFilled,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SvgPicture.asset(
        isSelected ? iconFilled : icon,
        height: 25,
        colorFilter: ColorFilter.mode(kColorWhite, BlendMode.srcIn),
      ),
    );
  }
}
