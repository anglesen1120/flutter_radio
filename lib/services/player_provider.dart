import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radio/utils/db_services.dart';
import '../model/radio.dart';
import 'db_download_services.dart';

enum RadioPlayerState { LOADING, STOPPED, PLAYING, PAUSED, COMPLETE }

class PlayerProvider with ChangeNotifier {
  AudioPlayer _audioPlayer;
  RadioModel _radioDetails;

  List<RadioModel> _radiosFetcher;
  List<RadioModel> get allRadio => _radiosFetcher;
  int get totalRecords => _radiosFetcher != null ? _radiosFetcher.length : 0;
  RadioModel get currentRadio => _radioDetails;

  getPlayerState() => _playerState;
  getAudioPlayer() => _audioPlayer;
  getCurrentRadio() => _radioDetails;

  RadioPlayerState _playerState = RadioPlayerState.STOPPED;
  StreamSubscription _positionSubcription;

  PlayerProvider() {
    _initStreams();
  }

  void _initStreams() {
    _radiosFetcher = List<RadioModel>();
    if (_radioDetails == null) {
      _radioDetails = new RadioModel(id: 0);
    }
  }

  void resetStreams() {
    _initStreams();
  }

  void initAudioPlugin() {
    if (_playerState == RadioPlayerState.STOPPED) {
      _audioPlayer = new AudioPlayer();
    } else {
      _audioPlayer = getAudioPlayer();
    }
  }

  setAudioPlayer(RadioModel radioModel) async {
    _radioDetails = radioModel;
    await initAudioPlayer();
  }

  initAudioPlayer() async {
    updatePlayerState(RadioPlayerState.LOADING);
    _positionSubcription =
        _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      if (_playerState == RadioPlayerState.LOADING && p.inMilliseconds > 0) {
        updatePlayerState(RadioPlayerState.PLAYING);
      }
      notifyListeners();
    });

    _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) async {
      print("Flutter : state : " + state.toString());
      if (state == AudioPlayerState.PLAYING) {
      } else if (state == AudioPlayerState.STOPPED ||
          state == AudioPlayerState.COMPLETED) {
        updatePlayerState(RadioPlayerState.STOPPED);
        notifyListeners();
      }
    });
  }

  playRadio() async {
    await _audioPlayer.play(currentRadio.radioURL, stayAwake: true);
  }

  stopRadio() async {
    if (_audioPlayer != null) {
      _positionSubcription?.cancel();
      updatePlayerState(RadioPlayerState.STOPPED);
      await _audioPlayer.stop();
    }
  }

  bool isPlaying() {
    return getPlayerState() == RadioPlayerState.PLAYING;
  }

  bool isLoading() {
    return getPlayerState() == RadioPlayerState.LOADING;
  }

  bool isStopped() {
    return getPlayerState() == RadioPlayerState.STOPPED;
  }

  fetchAllRadios(
      {String searchQuery = "", bool isFavouriteOnly = false}) async {
    _radiosFetcher = await DBDownloadServices.fetchLocalDB(
        searchQuery: searchQuery, isFavouriteOnly: isFavouriteOnly);
    notifyListeners();
  }

  void updatePlayerState(RadioPlayerState radioPlayerState) {
    _playerState = radioPlayerState;
    notifyListeners();
  }

  Future<void> radioBookmarked(int radioId, bool isFavourite,
      {bool isFavouriteOnly = false}) async {
    int isFavouriteVal = isFavourite ? 1 : 0;
    await DatabaseServices.init();
    await DatabaseServices.rawInsert(
      "INSERT OR REPLACE INTO radios_bookmarks (id, isFavourite) VALUES ($radioId, $isFavouriteVal)",
    );

    fetchAllRadios(isFavouriteOnly: isFavouriteOnly);
  }
}
