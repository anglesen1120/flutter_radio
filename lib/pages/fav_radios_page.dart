import 'package:flutter/material.dart';
import 'package:flutter_radio/pages/radio_page.dart';

class FavRadioPage extends StatelessWidget {
  const FavRadioPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new RadioPage(
      isFavouriteOnly: true,
    );
  }
}
