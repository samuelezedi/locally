library linkwell;

import 'package:flutter/material.dart';

Widget LinkWell {

RegExp exp = new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
List links = <String>[];

String text;
TextStyle style;
TextStyle linkStyle = TextStyle(color: Colors.blue);
TextAlign textAlign;

LinkWell({
  @required this.text,
  this.linkStyle,
  this.textAlign,
  this.style
}) {
  iterate(0);
  return richText();
}

iterate() {
  Iterable<RegExpMatch> matches = exp.allMatches(this.text);
  matches.forEach((match) {
    this.links.add(text.substring(match.start, match.end));
  });
}

richText() {

}

buildBody() {
  this.link.forEach((value){
    var wid = this.text.split(value.trim());
    var text = Text();
  });
}



}