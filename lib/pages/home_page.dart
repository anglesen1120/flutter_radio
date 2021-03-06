import 'package:flutter/material.dart';
import 'package:flutter_radio/pages/fav_radios_page.dart';
import 'package:flutter_radio/pages/radio_page.dart';
import 'package:flutter_radio/utils/hex_color.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _childern = [
    new RadioPage(isFavouriteOnly: false),
    FavRadioPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: Scaffold(
      body: _childern[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HexColor("#182545"),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: HexColor("#ffffff"),
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        items: [
          _bottomNavItem(Icons.play_arrow, "Listen"),
          _bottomNavItem(Icons.favorite, "Favorite")
        ],
        onTap: onTabTapped,
      ),
    ));
  }

  _bottomNavItem(IconData icon, String title) {
    return BottomNavigationBarItem(
      icon: new Icon(
        icon,
        color: HexColor("#6d7381"),
      ),
      activeIcon: new Icon(
        icon,
        color: HexColor("#ffffff"),
      ),
      // ignore: deprecated_member_use
      title: new Text(
        title,
        style: TextStyle(
          color: HexColor("#ffffff"),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    if (!mounted) return;
    setState(() {
      _currentIndex = index;
    });
  }
}
