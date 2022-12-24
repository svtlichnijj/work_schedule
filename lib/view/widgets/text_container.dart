import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  final String text;
  final bool isTransparent;

  const TextContainer({ Key? key, required this.text, this.isTransparent = false }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor.withOpacity(isTransparent ? 0.0 : 1.0),
            fontSize: 18.0,
          ),
        )
    );
  }

  static getTextError(context, String textError) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
        child: Text(
          textError.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).errorColor,
            fontSize: 18.0,
          ),
        )
    );
  }

  static getTextErrorWithIcon(context, String textError, IconData? iconData) {
    return <Widget>[
      Center(
        child: Icon(
          iconData,
          color: Theme.of(context).errorColor,
          size: 60,
        ),
      ),
      getTextError(context, textError)
    ];
  }
}
