import 'package:flutter/material.dart';

class EditTextAlertDialog extends StatelessWidget {
  final String title;
  final String label;
  final String textIn;
  final String cancelText;
  final String submitText;
  final Function(String text, int index) callback;

  const EditTextAlertDialog({
    Key? key,
    this.title = 'Change text',
    this.label = 'Field name',
    this.textIn = '',
    this.cancelText = 'Cancel',
    this.submitText = 'Submit',
    required this.callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String callbackText = '';

    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: TextEditingController()..text = textIn,
        autofocus: true,
        decoration: InputDecoration(
            labelText: label,
        ),
        onChanged: (value) {
          callbackText = value;
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            callback(textIn, 0);
            Navigator.pop(context, textIn);
          },
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () {
            callback(callbackText, 0);
            Navigator.pop(context, callbackText);
          },
          child: Text(submitText),
        ),
      ],
    );
  }
}
