import 'package:flutter/material.dart';

class SlideLeftBackground extends StatelessWidget {
  const SlideLeftBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment.centerRight,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox.square(
                dimension: constraints.maxHeight,
                child: Column(
                // child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
