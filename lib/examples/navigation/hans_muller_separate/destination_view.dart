import 'package:flutter/material.dart';

import 'package:work_schedule/examples/navigation/hans_muller_separate/destination.dart';
import 'package:work_schedule/examples/navigation/hans_muller_separate/navigation_pages.dart';

class ViewNavigatorObserver extends NavigatorObserver {
  ViewNavigatorObserver(this.onNavigation);

  final VoidCallback onNavigation;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onNavigation();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onNavigation();
  }
}

class DestinationView extends StatefulWidget {
  const DestinationView({ Key? key, required this.destination, required this.onNavigation }) : super(key: key);

  final Destination destination;
  final VoidCallback onNavigation;

  @override
  State<DestinationView> createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: <NavigatorObserver>[
        ViewNavigatorObserver(widget.onNavigation),
      ],
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch(settings.name) {
              case '/':
                return RootPage(destination: widget.destination);
              case '/list':
                return ListPage(destination: widget.destination);
              case '/text':
                return TextPage(destination: widget.destination);
              default:
                return RootPage(destination: widget.destination);
            }
          },
        );
      },
    );
  }
}
/*
// class _DestinationViewState extends State<DestinationView> {
//   late TextEditingController _textController;
//   // TextEditingController _textController;
//
//   @override
//   void initState() {
//     super.initState();
//     _textController = TextEditingController(
//       text: 'sample text: ${widget.destination.title}',
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.destination.title} Text'),
//         backgroundColor: widget.destination.color,
//       ),
//       backgroundColor: widget.destination.color[100],
//       body: Container(
//         padding: const EdgeInsets.all(32.0),
//         alignment: Alignment.center,
//         child: TextField(controller: _textController),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _textController.dispose();
//     super.dispose();
//   }
// }
 */