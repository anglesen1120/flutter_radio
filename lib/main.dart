import 'package:flutter/material.dart';
import 'package:flutter_radio/pages/home_page.dart';
import 'package:flutter_radio/pages/radio_page.dart';
import 'package:flutter_radio/services/player_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PlayerProvider(),
          child: RadioPage(),
        )
      ],
      child: MaterialApp(
        title: '',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Montserrat'),
        home: SafeArea(
          child: Scaffold(
            primary: false,
            body: HomePage(),
          ),
          bottom: false,
        ),
      ),
    );
  }
}
