import 'package:flutter/material.dart';
import 'package:flutter_radio/utils/HexColor.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget _nowPlayingText(BuildContext context, String title, String imageUrl) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
      child: ListTile(
        title: new Text(
          title,
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            color: HexColor("#ffffff"),
          ),
        ),
        subtitle: new Text(
          "Now Playing",
          textScaleFactor: 0.8,
          style: new TextStyle(color: HexColor("#ffffff")),
        ),
      ),
    );
  }

  Widget _image(url, {size}) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(url),
      ),
      height: size == null ? 55 : size,
      width: size == null ? 55 : size,
      decoration: BoxDecoration(
          color: HexColor("#FFE5EC"),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ]),
    );
  }
}
