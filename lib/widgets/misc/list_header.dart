import 'package:flutter/material.dart';

class ListHeader extends StatelessWidget {
  final String text;
  ListHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.fromLTRB(15.0, 25.0, 5.0, 5.0),
      child: new Text(text, style: Theme.of(context).textTheme.caption),
    );
  }
}