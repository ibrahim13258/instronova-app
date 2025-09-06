// File: widgets/custom_bottom_navbar.dart
import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavbar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<String> icons = [
      AppAssets.homeIcon,
      AppAssets.reelsIcon,
      AppAssets.searchIcon,
      AppAssets.notificationsIcon,
      AppAssets.profileIcon,
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(6),
              decoration: isSelected
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.pink],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    )
                  : null,
              child: Image.asset(
                icons[index],
                height: 28,
                width: 28,
                color: isSelected
                    ? Colors.white
                    : isDark
                        ? Colors.white70
                        : Colors.black54,
              ),
            ),
          );
        }),
      ),
    );
  }
}
