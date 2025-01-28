import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mndesai/constants/color_constants.dart';
import 'package:mndesai/constants/image_constants.dart';
import 'package:mndesai/features/bill_entry/screens/bill_entry_screen.dart';
import 'package:mndesai/features/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:mndesai/features/point_calculation/screens/points_calculation_screen.dart';
import 'package:mndesai/features/profile/screens/profile_screen.dart';
import 'package:mndesai/features/virtual_card_generation/screens/virtual_card_generation_screen.dart';
import 'package:mndesai/utils/extensions/app_size_extensions.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({
    super.key,
  });

  final BottomNavController _controller = Get.put(
    BottomNavController(),
  );

  final List<Widget> pages = [
    KeyedPage(
      key: UniqueKey(),
      page: const BillEntryScreen(),
    ),
    KeyedPage(
      key: UniqueKey(),
      page: const PointsCalculationScreen(),
    ),
    KeyedPage(
      key: UniqueKey(),
      page: const VirtualCardGenerationScreen(),
    ),
    KeyedPage(
      key: UniqueKey(),
      page: ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: kColorWhite,
        body: Obx(
          () => pages[_controller.selectedIndex.value],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          color: kColorPrimary,
          buttonBackgroundColor: kColorWhite,
          backgroundColor: kColorWhite,
          animationDuration: const Duration(
            milliseconds: 100,
          ),
          animationCurve: Curves.bounceIn,
          height: 50.appHeight,
          index: _controller.selectedIndex.value,
          items: [
            Obx(
              () => SvgPicture.asset(
                _controller.selectedIndex.value == 0
                    ? kIconBillFilled
                    : kIconBill,
                height: 20.appHeight,
                colorFilter: ColorFilter.mode(
                  _controller.selectedIndex.value == 0
                      ? kColorPrimary
                      : kColorWhite,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Obx(
              () => SvgPicture.asset(
                _controller.selectedIndex.value == 1
                    ? kIconPointsFilled
                    : kIconPoints,
                height: 20.appHeight,
                colorFilter: ColorFilter.mode(
                  _controller.selectedIndex.value == 1
                      ? kColorPrimary
                      : kColorWhite,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Obx(
              () => SvgPicture.asset(
                _controller.selectedIndex.value == 2
                    ? kIconVirtualCardFilled
                    : kIconVirtualCard,
                height: 20.appHeight,
                colorFilter: ColorFilter.mode(
                  _controller.selectedIndex.value == 2
                      ? kColorPrimary
                      : kColorWhite,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Obx(
              () => SvgPicture.asset(
                _controller.selectedIndex.value == 3
                    ? kIconServicesFilled
                    : kIconServices,
                height: 20.appHeight,
                colorFilter: ColorFilter.mode(
                  _controller.selectedIndex.value == 3
                      ? kColorPrimary
                      : kColorWhite,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
          onTap: (index) {
            _controller.changeIndex(index);
          },
        ),
      ),
    );
  }
}

class KeyedPage extends StatelessWidget {
  final Widget page;
  const KeyedPage({
    required Key key,
    required this.page,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return page;
  }
}
