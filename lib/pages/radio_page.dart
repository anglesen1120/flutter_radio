import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radio/model/radio.dart';
import 'package:flutter_radio/pages/radio_row_template.dart';
import 'package:flutter_radio/services/db_download_services.dart';
import 'package:flutter_radio/services/player_provider.dart';
import 'package:flutter_radio/utils/hex_color.dart';
import 'package:provider/provider.dart';
import 'now_playing_template.dart';

class RadioPage extends StatefulWidget {
  final bool isFavouriteOnly;
  RadioPage({Key key, this.isFavouriteOnly}) : super(key: key);

  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  final _searchQuery = new TextEditingController();
  Timer _debounce;
  AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    playerProvider.initAudioPlugin();
    playerProvider.resetStreams();
    playerProvider.fetchAllRadios();

    _searchQuery.addListener(_onSeachChanged);
  }

  _onSeachChanged() {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(microseconds: 500), () {
      playerProvider.fetchAllRadios(
          searchQuery: _searchQuery.text,
          isFavouriteOnly: this.widget.isFavouriteOnly);
    });
  }

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
          _nowPlaying(),
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
              controller: _searchQuery,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _noData() {
    String noDataTxt = "";
    bool showTextMessage = false;

    if (this.widget.isFavouriteOnly ||
        (this.widget.isFavouriteOnly && _searchQuery.text.isNotEmpty)) {
      noDataTxt = "No Favorites";
      showTextMessage = true;
    } else if (_searchQuery.text.isNotEmpty) {
      noDataTxt = "No Radio Found";
      showTextMessage = true;
    }

    return Column(
      children: [
        new Expanded(
          child: Center(
            child: showTextMessage
                ? new Text(
                    noDataTxt,
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Widget _radioList() {
    return Consumer<PlayerProvider>(
      builder: (context, radioModel, child) {
        if (radioModel.totalRecords > 0) {
          return new Expanded(
            child: Padding(
              child: ListView(
                children: <Widget>[
                  ListView.separated(
                    itemCount: radioModel.totalRecords,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return RadioRowTemplate(
                        radioModel: radioModel.allRadio[index],
                        isFavouriteOnlyRadios: this.widget.isFavouriteOnly,
                      );
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
        if (radioModel.totalRecords == 0) {
          return Expanded(child: _noData());
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _nowPlaying() {
    var providerPlayer = Provider.of<PlayerProvider>(context, listen: true);
    return Visibility(
      visible: providerPlayer.getPlayerState() == RadioPlayerState.PLAYING,
      child: NowPlaying(
        radioTitle: providerPlayer.currentRadio.radioName,
        radioImageUrl: providerPlayer.currentRadio.radioPic,
      ),
    );
  }
}
