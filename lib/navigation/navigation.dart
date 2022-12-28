import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:work_schedule/navigation/bottom_navigation.dart';
import 'package:work_schedule/navigation/tab_item.dart';
import 'package:work_schedule/navigation/tab_navigator.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> with TickerProviderStateMixin<Navigation> {
  TabItem _currentTab = TabItem.assets;
  late AnimationController _hide;

  @override
  void initState() {
    super.initState();

    _hide = AnimationController(vsync: this, duration: kThemeAnimationDuration);
  }

  @override
  void dispose() {
    _hide.dispose();

    super.dispose();
  }

  final Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.assets: GlobalKey<NavigatorState>(),
    TabItem.calendar: GlobalKey<NavigatorState>(),
    TabItem.calendars: GlobalKey<NavigatorState>(),
  };

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification && notification.metrics.axis == Axis.vertical) {
        switch (notification.direction) {
          case ScrollDirection.forward:
            _hide.forward();
            break;
          case ScrollDirection.reverse:
            _hide.reverse();
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }

    return false;
  }

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst); // pop to first route
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: WillPopScope(
        onWillPop: () async => !await _navigatorKeys[_currentTab]!.currentState!.maybePop(),
        child: Scaffold(
          body: SafeArea(
            top: false,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _buildOffstageNavigator(TabItem.assets),
                _buildOffstageNavigator(TabItem.calendar),
                _buildOffstageNavigator(TabItem.calendars),
              ],
            ),
          ),
          bottomNavigationBar: ClipRect(
            child: SizeTransition(
                sizeFactor: _hide,
                axisAlignment: -1.0,
                child: ButtonNavigation(
                  currentTab: _currentTab,
                  onSelectTab: _selectTab,
                )
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem]!,
        tabItem: tabItem,
        onNavigation: () {
          _hide.forward();
        },
      ),
    );
  }
}
