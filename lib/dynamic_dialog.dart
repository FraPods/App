import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicDialog extends StatefulWidget {
  DynamicDialog(Key? key, this.dialogData) : super(key: key);
  final DialogData dialogData;

  @override
  _DynamicDialogState createState() => _DynamicDialogState();
}

class _DynamicDialogState extends State<DynamicDialog> {
  DialogData _dialogData = DialogData("title", "message");

  @override
  void initState() {
    _dialogData = widget.dialogData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_dialogData.title),
      content: Text(_dialogData.message),
    );
  }
}

class DialogData {
  final String title;
  final String message;

  DialogData(this.title, this.message);
}