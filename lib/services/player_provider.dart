import 'package:flutter/material.dart';
import '../model/radio.dart';
import 'db_download_services.dart';

enum RadioPlayerState { LOADING, STOPPED, PLAYING, PAUSED, COMPLETE }

class PlayerProvider with ChangeNotifier {
  List<RadioModel> _radiosFetcher;
  List<RadioModel> get allRadio => _radiosFetcher;
  int get totalRecords => _radiosFetcher != null ? _radiosFetcher.length : 0;
  getPlayerState() => _playerState;

  RadioPlayerState _playerState = RadioPlayerState.STOPPED;
  PlayerProvider() {
    _radiosFetcher = List<RadioModel>();
  }

  fetchAllRadios() async {
    _radiosFetcher = await DBDownloadServices.fetchLocalDB();
  }

  void updatePlayerState(RadioPlayerState radioPlayerState) {
    _playerState = radioPlayerState;
    notifyListeners();
  }
}
