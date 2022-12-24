import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:work_schedule/examples/navigation/hans_muller_separate/destination.dart';
import 'package:work_schedule/examples/navigation/hans_muller_separate/destination_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage> {
  late List<Key> _destinationKeys;
  late List<AnimationController> _faders;
  late AnimationController _hide;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _faders = allDestinations.map<AnimationController>((Destination destination) {
      return AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    }).toList();
    _faders[_currentIndex].value = 1.0;
    _destinationKeys = List<Key>.generate(allDestinations.length, (int index) => GlobalKey()).toList();
    _hide = AnimationController(vsync: this, duration: kThemeAnimationDuration);
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders) {
      controller.dispose();
    }
    _hide.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
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

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scaffold(
        body: SafeArea(
          top: false,
          // child: WillPopScope(
          //   onWillPop: () async => false,
            // onWillPop: () async {
              // bool nextBool = Random().nextBool();
              // print('nextBool');
              // print(nextBool);
              // return nextBool;
              // return true;
              // return DestinationView(
              //     destination: allDestinations[_currentIndex],
              //     onNavigation: () {
              //   _hide.forward();
              // },
              // ).currentState.maybePop(),
            // },
            child: Stack(
            fit: StackFit.expand,
            children: allDestinations.map((Destination destination) {
              final Widget view = FadeTransition(
                opacity: _faders[destination.index].drive(CurveTween(curve: Curves.fastOutSlowIn)),
                child: KeyedSubtree(
                  key: _destinationKeys[destination.index],
                  child: DestinationView(
                    destination: destination,
                    onNavigation: () {
                      _hide.forward();
                    },
                  ),
                ),
              );
              if (destination.index == _currentIndex) {
                _faders[destination.index].forward();

                return view;
              } else {
                _faders[destination.index].reverse();

                if (_faders[destination.index].isAnimating) {
                  return IgnorePointer(child: view);
                }

                return Offstage(child: view);
              }
            }).toList(),
          ),
          // ),
        ),
        bottomNavigationBar: ClipRect(
          child: SizeTransition(
            sizeFactor: _hide,
            axisAlignment: -1.0,
            child: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: allDestinations.map((Destination destination) {
                return NavigationDestination(
                  icon: Icon(destination.icon),
                  label: destination.title,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}