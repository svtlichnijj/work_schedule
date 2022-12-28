import 'package:flutter/material.dart';

class DismissibleBackgroundBuilder extends StatelessWidget {
  final double detailsProgress;
  final DismissDirection direction;
  final Color? color;
  final List<Widget> children;

  const DismissibleBackgroundBuilder({
    Key? key,
    required this.detailsProgress,
    this.direction = DismissDirection.startToEnd,
    this.color,
    this.children = const <Widget>[]
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          EdgeInsetsGeometry marginOnly = direction == DismissDirection.startToEnd
              ? EdgeInsets.only(right: constraints.maxWidth * (1.001 - detailsProgress))
              : EdgeInsets.only(left: constraints.maxWidth * (1.001 - detailsProgress));

          return Container(
            margin: marginOnly,
            color: color,
            child: SizedBox.square(
              dimension: constraints.maxHeight,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
