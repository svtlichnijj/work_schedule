import 'package:flutter/material.dart';
import 'package:work_schedule/examples/flutter_calendar_view/main.dart';

import 'package:work_schedule/examples/table_calendar/main.dart';
import 'package:work_schedule/navigation/tab_item.dart';
import 'package:work_schedule/view/pages/employees_list_page.dart';

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
        // initialRoute: TabNavigatorRoutes.employees,
        observers: <NavigatorObserver>[
          ViewNavigatorObserver(onNavigation),
        ],
        onGenerateRoute: (RouteSettings routeSettings) {
          // print('--routeSettings.name');
          // print(routeSettings.name);
          // print('routeBuilders');
          // print(routeBuilders);
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (BuildContext context) => routeBuilders[routeSettings.name]!(context),
          );
        }
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return  {
      '/': (context) => tabItem == TabItem.employees
          ? const EmployeesListPage()
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