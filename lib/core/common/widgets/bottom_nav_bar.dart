import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTabTapped;

  const BottomNavBar({super.key, required this.currentIndex, this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Bottom navigation bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Left side navigation items
              _buildNavItem(context, 0, Icons.home_rounded, 'Home', '/home'),
              _buildNavItem(
                context,
                2,
                Icons.restaurant_menu_rounded,
                'Meals',
                '/meals',
              ),
              _buildNavItem(
                context,
                3, // Adjusted index for community
                Icons.group_rounded,
                'Community',
                '/community', // Adjusted path for community,
              ),
              _buildNavItem(
                context,
                1,
                Icons.show_chart_rounded,
                'Progress',
                '/progress-tracker',
              ),
              _buildNavItem(
                context,
                4,
                Icons.favorite_rounded,
                'Wellness',
                '/wellness',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    String path,
  ) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () {
        // Use the callback if provided, otherwise use direct navigation
        if (onTabTapped != null) {
          onTabTapped!(index);
        } else if (currentIndex != index) {
          // Only navigate if we're not already on this tab
          context.go(path);
        }
      },
      customBorder: const CircleBorder(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              size: index == 3 ? 26 : 24, // Slightly larger icon for nutrition
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize:
                    index == 3 ? 13 : 12, // Slightly larger text for nutrition
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
