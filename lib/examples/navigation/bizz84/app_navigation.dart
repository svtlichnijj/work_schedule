import 'package:flutter/material.dart';

class TabHelper {
  static MaterialColor color(TabItem tabItem) {
    var colors = {
      TabItem.red: Colors.red,
      // TabItem.blue: Colors.blue,
      TabItem.green: Colors.green,
    };

    return colors[tabItem] ?? Colors.red;
  }

  static String description(TabItem tabItem) {
    return tabItem.name.toString();
  }
}

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

enum TabItem { red, green, blue }

class ColorsListPage extends StatelessWidget {
  ColorsListPage({Key? key, required this.color, required this.title, required this.onPush}) : super(key: key);
  // ColorsListPage({this.color, this.title, this.onPush});
  final MaterialColor color;
  final String title;
  final ValueChanged<int> onPush;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: color,
        ),
        body: Container(
          color: Colors.white,
          child: _buildList(),
        ));
  }

  final List<int> materialIndices = [900, 800, 700, 600, 500, 400, 300, 200, 100, 50];

  Widget _buildList() {
    return ListView.builder(
        itemCount: materialIndices.length,
        itemBuilder: (BuildContext content, int index) {
          int materialIndex = materialIndices[index];
          return Container(
            color: color[materialIndex],
            child: ListTile(
              title: Text('$materialIndex', style: const TextStyle(fontSize: 24.0)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onPush(materialIndex),
            ),
          );
        });
  }
}

class ColorDetailPage extends StatelessWidget {
  const ColorDetailPage({Key? key, required this.color, required this.title, this.materialIndex = 500}) : super(key: key);
  // ColorDetailPage({this.color, this.title, this.materialIndex: 500});
  final MaterialColor color;
  final String title;
  final int materialIndex;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('$title[$materialIndex]'),
        backgroundColor: color,
      ),
      body: Container(
        color: color[materialIndex],
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key, required this.currentTab, required this.onSelectTab}) : super(key: key);
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentTab.index,
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          label: 'Calculate',
          icon: Icon(Icons.send_time_extension_rounded),
        ),
        BottomNavigationBarItem(
          label: 'Results',
          icon: Icon(Icons.window_rounded),
        ),
      ],
    );
  }
}

class TabNavigator extends StatelessWidget {
  const TabNavigator({Key? key, required this.navigatorKey, required this.tabItem}) : super(key: key);
  // TabNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  void _push(BuildContext context, {int materialIndex = 500}) {
    // void _push(BuildContext context, {int materialIndex: 500}) {
    var routeBuilders = _routeBuilders(context, materialIndex: materialIndex);

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => routeBuilders[TabNavigatorRoutes.detail]!(context)));
    // MaterialPageRoute(builder: (context) => routeBuilders[TabNavigatorRoutes.detail](context)));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
      {int materialIndex = 500}) {
    // {int materialIndex: 500}) {
    return {
      TabNavigatorRoutes.root: (context) => ColorsListPage(
        color: TabHelper.color(tabItem),
        title: TabHelper.description(tabItem),
        onPush: (materialIndex) =>
            _push(context, materialIndex: materialIndex),
      ),
      TabNavigatorRoutes.detail: (context) => ColorDetailPage(
        color: TabHelper.color(tabItem),
        title: TabHelper.description(tabItem),
        materialIndex: materialIndex,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: TabNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          print('--routeSettings.name');
          print(routeSettings.name);
          print('routeBuilders');
          print(routeBuilders);
          return MaterialPageRoute(
              builder: (context) => routeBuilders[routeSettings.name]!(context)
            // builder: (context) => routeBuilders[routeSettings.name](context)
          );
        });
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  // final navigatorKey = GlobalKey<NavigatorState>();
  TabItem currentTab = TabItem.red;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.red: GlobalKey<NavigatorState>(),
    TabItem.green: GlobalKey<NavigatorState>(),
    // TabItem.blue: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    setState(() {
      currentTab = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('navigatorKeys');
    print(navigatorKeys);
    return WillPopScope(
        onWillPop: () async => !await navigatorKeys[currentTab]!.currentState!.maybePop(),
        // !await navigatorKeys[currentTab].currentState.maybePop(),
        child: Scaffold(
          body: Stack(
              children: <Widget>[
                _buildOffstageNavigator(TabItem.red),
                _buildOffstageNavigator(TabItem.green),
                // _buildOffstageNavigator(TabItem.blue),
              ]
          ),
          // body: TabNavigator(
          //   navigatorKey: navigatorKey,
          //   tabItem: currentTab,
          // ),
          // body: _buildBody(),
          bottomNavigationBar: BottomNavigation(
            currentTab: currentTab,
            // onSelectTab: (TabItem tabItem) => setState(() {
            //   currentTab = tabItem;
            // }),
            onSelectTab: _selectTab,
          ),
        )
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    // print('---_currentTab');
    // print(currentTab);
    // print('tabItem');
    // print(tabItem);
    // print('_navigatorKeys[tabItem]');
    // print(navigatorKeys[tabItem]);
    // print('_navigatorKeys[tabItem]!');
    // print(navigatorKeys[tabItem]!);
    return Offstage(
      offstage: currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: navigatorKeys[tabItem]!,
        tabItem: tabItem,
      ),
    );
  }

// Widget _buildBody() {
//   return Container(
//       color: TabHelper.color(TabItem.red),
//       alignment: Alignment.center,
//       child: TextButton(
//       // child: FlatButton(
//         onPressed: _push,
//         child: const Text(
//           'PUSH',
//           style: TextStyle(fontSize: 32.0, color: Colors.white),
//         ),
//       )
//   );
// }
//
// void _push() {
//   Navigator.of(context).push(MaterialPageRoute(
//     // we'll look at ColorDetailPage later
//     builder: (context) => ColorDetailPage(
//       color: TabHelper.color(TabItem.red),
//       title: TabHelper.description(TabItem.red),
//     ),
//   ));
// }
}