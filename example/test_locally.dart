import 'package:locally/locally.dart';
import 'package:flutter/material.dart';

class Checks extends StatefulWidget {
  @override
  _ChecksState createState() => _ChecksState();
}

class _ChecksState extends State<Checks> {

  Locally locally;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locally = Locally(
      context: this.context,
      body: 'You have a new message',
      title: 'New message',
      appIcon: 'pronoun',
    );
    locally.show();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
