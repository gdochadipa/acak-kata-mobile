import 'package:acakkata/pages/home_page/account_page.dart';
import 'package:acakkata/pages/home_page/home_page.dart';
import 'package:acakkata/pages/home_page/setting_page.dart';
import 'package:acakkata/service/coba_echo_socket.dart';
import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 1;
  // CobaEchoSocket echoSocket = CobaEchoSocket();

  @override
  void initState() {
    // TODO: implement initState
    // echoSocket.fireSocket();
    super.initState();
  }

  Widget customBottomNav() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          backgroundColor: backgroundColor3,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  child: Image.asset(
                    'assets/images/icon_person.png',
                    width: 25,
                    color: currentIndex == 0 ? primaryColor : grayColor2,
                  ),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  child: Image.asset(
                    'assets/images/icon_home.png',
                    width: 25,
                    color: currentIndex == 1 ? primaryColor : grayColor2,
                  ),
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  child: Image.asset(
                    'assets/images/icon_gear.png',
                    width: 25,
                    color: currentIndex == 2 ? primaryColor : grayColor2,
                  ),
                ),
                label: '')
          ],
        ),
      ),
    );
  }

  Widget body() {
    switch (currentIndex) {
      case 0:
        return AccountPage();
        break;
      case 1:
        return HomePage();
        break;
      case 2:
        return SettingPage();
        break;
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          // bottomNavigationBar: customBottomNav(),
          body: body(),
        ),
        onWillPop: () async => false);
  }
}
