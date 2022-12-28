import 'package:flutter/material.dart';

import 'package:work_schedule/navigation/tab_item.dart';

class ButtonNavigation extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  const ButtonNavigation({Key? key, required this.currentTab, required this.onSelectTab }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            label: 'Assets',
            icon: Icon(Icons.web_asset)
        ),
        BottomNavigationBarItem(
            label: 'Calendar',
            icon: Icon(Icons.calendar_month)
        ),
        BottomNavigationBarItem(
            label: 'Calendars',
            icon: Icon(Icons.calendar_view_month)
        ),
      ],
      onTap: (index) =>
          onSelectTab(
            TabItem.values[index],
          ),
      currentIndex: currentTab.index,
    );
  }
}
