import 'package:flutter/material.dart';

class YesNoAlertDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String yesOption;
  final String noOption;
  const YesNoAlertDialog({this.title = "Yes or No", this.subtitle, this.yesOption = "YES", this.noOption = "NO"});

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text(title),
      content: subtitle != null ? new Text(subtitle) : null,
      actions: <Widget> [
        new FlatButton(
          onPressed: () => Navigator.pop(context, false),
          child: new Text(noOption),
        ),
        new FlatButton(
          onPressed: () => Navigator.pop(context, true),
          child: new Text(yesOption),
        ),
      ],
    );
  }
}