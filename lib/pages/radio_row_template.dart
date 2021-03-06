import 'package:flutter/material.dart';
import 'package:flutter_radio/model/radio.dart';
import 'package:flutter_radio/services/player_provider.dart';
import 'package:flutter_radio/utils/hex_color.dart';
import 'package:provider/provider.dart';

class RadioRowTemplate extends StatefulWidget {
  final RadioModel radioModel;
  final bool isFavouriteOnlyRadios;

  const RadioRowTemplate({Key key, this.radioModel, this.isFavouriteOnlyRadios})
      : super(key: key);
  @override
  _RadioRowTemplateState createState() => _RadioRowTemplateState();
}

class _RadioRowTemplateState extends State<RadioRowTemplate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSongRow();
  }

  Widget _buildSongRow() {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    final bool _isSelectdRadio =
        this.widget.radioModel.id == playerProvider.currentRadio.id;

    return ListTile(
      title: new Text(
        this.widget.radioModel.radioName,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          color: HexColor("#182545"),
        ),
      ),
      leading: _image(this.widget.radioModel.radioPic),
      subtitle: new Text(this.widget.radioModel.radioDesc, maxLines: 2),
      trailing: Wrap(
        spacing: -10.0,
        runSpacing: 0.0,
        children: <Widget>[
          _buildPlayStopIcon(playerProvider, _isSelectdRadio),
          _buildAddFavouriteIcon()
        ],
      ),
    );
  }

  Widget _buildPlayStopIcon(
      PlayerProvider playerProvider, bool _isSelectedSong) {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    return IconButton(
      icon: _buildAudioButton(playerProvider, _isSelectedSong),
      onPressed: () {
        if (!playerProvider.isStopped() && _isSelectedSong) {
          playerProvider.stopRadio();
        } else {
          if (!playerProvider.isLoading()) {
            playerProvider.initAudioPlugin();
            playerProvider.setAudioPlayer(this.widget.radioModel);
            playerProvider.playRadio();
          }
        }
      },
    );
  }

  Widget _buildAudioButton(PlayerProvider model, bool _isSelectedSong) {
    if (_isSelectedSong) {
      if (model.isLoading()) {
        return Center(
          child: CircularProgressIndicator(strokeWidth: 2.0),
        );
      }

      if (!model.isStopped()) {
        return Icon(Icons.stop);
      }

      if (model.isStopped()) {
        return Icon(Icons.play_circle_filled);
      }
    } else {
      return Icon(Icons.play_circle_filled);
    }

    return new Container();
  }

  Widget _buildAddFavouriteIcon() {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: true);

    return IconButton(
      icon: this.widget.radioModel.isBookmarked
          ? Icon(Icons.favorite_border)
          : Icon(Icons.favorite_border),
      color: HexColor("#9097A6"),
      onPressed: () {
        playerProvider.radioBookmarked(
          this.widget.radioModel.id,
          !this.widget.radioModel.isBookmarked,
          isFavouriteOnly: this.widget.isFavouriteOnlyRadios,
        );
      },
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
