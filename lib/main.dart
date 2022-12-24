import 'package:flutter/material.dart';

// import 'package:work_schedule/examples/navigation/bizz84/app_navigation.dart';
// import 'package:work_schedule/examples/flutter_calendar_view/main.dart';
// import 'package:work_schedule/examples/table_calendar/main.dart';
// import 'package:work_schedule/examples/navigation/hans_muller/cross_fade.dart';
// import 'package:work_schedule/examples/navigation/hans_muller/navigator_scroll_fade_demo.dart';
// import 'package:work_schedule/examples/navigation/hans_muller/navigators_stack.dart';
// import 'package:work_schedule/examples/navigation/hans_muller_separate/home_page.dart';
import 'package:work_schedule/navigation/navigation.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // color: Colors.brown,
      // home: StartPage(),
      // home: MyApp(),
      // home: HomePage(),
      home: const Navigation(),
      // home: EmployeesListPage(),
      // home: CalendarPage(),
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.brown,
        elevatedButtonTheme: ElevatedButtonThemeData(
        // textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.inversePrimary),
            // foregroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.background),
            // foregroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.secondary),
            textStyle: const MaterialStatePropertyAll<TextStyle>(TextStyle(color: Colors.green)),
            // textStyle: MaterialStatePropertyAll().primary,
            // textTheme: ButtonTextTheme.primary,
            // textStyle: MaterialStatePropertyAll<TextStyle>(
            //     TextStyle(color: Colors.white60),
            // ),
            backgroundColor: const MaterialStatePropertyAll<Color>(Colors.brown),
            // backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor),
          ),
        ),
        // buttonTheme: const ButtonThemeData(
        //   // ButtonStyle(
        //   // textStyle: MaterialStatePropertyAll<TextStyle>(
        //   //     TextStyle(color: Colors.white60),
        //   // ),
        //   buttonColor: Colors.red,
        //   // buttonColor: Colors.brown,
        //   // backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor),
        //   textTheme: ButtonTextTheme.primary,
        //   // ),
        // ),
        // backgroundColor: Colors.brown,
      ),
    );
  }

}
