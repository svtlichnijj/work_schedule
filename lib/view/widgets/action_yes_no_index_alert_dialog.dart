import 'package:flutter/material.dart';

class ActionYesNoIndexAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String falseText;
  final String trueText;
  final Function(bool isTrue, int index) callback;

  const ActionYesNoIndexAlertDialog({
    Key? key,
    this.title = 'Are you sure?',
    this.content = '',
    this.falseText = 'Cancel',
    this.trueText = 'OK',
    required this.callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            callback(false, 0);
            Navigator.pop(context, false);
          },
          child: Text(falseText),
        ),
        TextButton(
          onPressed: () {
            callback(true, 0);
            Navigator.pop(context, true);
          },
          child: Text(trueText),
        ),
      ],
    );
  }
}
