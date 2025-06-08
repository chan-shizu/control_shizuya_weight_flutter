import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(selectedIndex == 0 ? Icons.home : Icons.home_outlined),
          label: 'ホーム',
        ),
        BottomNavigationBarItem(
          icon: Icon(selectedIndex == 1
              ? Icons.calendar_today
              : Icons.calendar_month_outlined),
          label: '活動報告',
        ),
        BottomNavigationBarItem(
          icon: Icon(
              selectedIndex == 2 ? Icons.settings : Icons.settings_outlined),
          label: '応援メッセージ',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      onTap: onItemTapped,
    );
  }
}
