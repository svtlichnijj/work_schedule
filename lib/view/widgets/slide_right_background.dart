import 'package:flutter/material.dart';

class SlideRightBackground extends StatelessWidget {
  const SlideRightBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Align(
        alignment: Alignment.centerLeft,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox.square(
                dimension: constraints.maxHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}
