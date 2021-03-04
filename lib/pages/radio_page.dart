import 'package:flutter/material.dart';
import 'package:flutter_radio/model/radio.dart';
import 'package:flutter_radio/pages/radio_row_template.dart';
import 'package:flutter_radio/services/db_download_services.dart';
import 'package:flutter_radio/utils/HexColor.dart';

import 'now_playing_template.dart';

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
          _appLogo(),
          _searchBar(),
          _radioList(),
          NowPlaying(
            radioTitle: "Current Radio Playing",
            radioImageUrl: "http://isharpeners.com/sc_logo.png",
          )
        ],
      ),
    );
  }

  Widget _appLogo() {
    return Container(
      width: double.infinity,
      color: HexColor("#182545"),
      height: 80,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: new Text(
            "Radio App",
            style: TextStyle(
              fontSize: 30,
              color: HexColor("#ffffff"),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.search),
          new Flexible(
            child: new TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(5),
                hintText: 'Search Radio',
              ),
              // controller: _searchQuery,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _radioList() {
    return new FutureBuilder(
      future: DBDownloadServices.fetchLocalDB(),
      builder: (BuildContext context, AsyncSnapshot<List<RadioModel>> radios) {
        if (radios.hasData) {
          return new Expanded(
            child: Padding(
              child: ListView(
                children: <Widget>[
                  ListView.separated(
                    itemCount: radios.data.length,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return RadioRowTemplate(radioModel: radios.data[index]);
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  )
                ],
              ),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
