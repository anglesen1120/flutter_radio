import 'package:flutter/material.dart';
import 'package:flutter_radio/model/radio.dart';
import 'package:flutter_radio/pages/radio_row_template.dart';

class RadioPage extends StatefulWidget {
  RadioPage({Key key}) : super(key: key);

  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  RadioModel radioModel = new RadioModel(
      id: 1,
      radioName: "Test radio 1",
      radioDesc: "Test Radio Desc",
      radioPic: "http://isharpeners.com/sc_logo.png");
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          RadioRowTemplate(radioModel: radioModel),
          RadioRowTemplate(radioModel: radioModel),
        ],
      ),
    );
  }
}
