import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  var title;
  var message;
  SecondScreen({this.title,this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
              child: Column(
                children: <Widget>[
                  Text(title),
                  Text(message)
                ],
              ),
            )
        )
    );
  }
}
