enum TabItem {
  employees('employees'),
  calendar('calendar'),
  calendars('calendars');

  final String name;

  const TabItem(this.name);
}

// class TabNavigatorRoutes {
//   static const String employees = '/';
//   static const String calendar = '/calendar';
//
//   // // OR
//   //
//   // static final Map<TabItem, String> _routes = {
//   //   TabItem.employees: '/',
//   //   TabItem.calendar: '/calendar',
//   // };
//   //
//   // static String getTabNavigatorRoute(TabItem tabItem) {
//   //   return _routes[tabItem] ?? '/';
//   // }
// }