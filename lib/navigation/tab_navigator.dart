import 'package:flutter/material.dart';
import 'package:work_schedule/examples/flutter_calendar_view/main.dart';

import 'package:work_schedule/examples/table_calendar/main.dart';
import 'package:work_schedule/navigation/tab_item.dart';
import 'package:work_schedule/view/pages/assets_page.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({ Key? key, required this.navigatorKey, required this.tabItem, required this.onNavigation}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  final VoidCallback onNavigation;

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        observers: <NavigatorObserver>[
          ViewNavigatorObserver(onNavigation),
        ],
        onGenerateRoute: (RouteSettings routeSettings) {
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (BuildContext context) => routeBuilders[routeSettings.name]!(context),
          );
        }
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return  {
      '/': (context) => tabItem == TabItem.assets
          ? const AssetsPage()
          : tabItem == TabItem.calendar ? const StartPage() : const MyApp2(),
    };
  }
}

class ViewNavigatorObserver extends NavigatorObserver {
  final VoidCallback onNavigation;

  ViewNavigatorObserver(this.onNavigation);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onNavigation();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onNavigation();
  }
}
