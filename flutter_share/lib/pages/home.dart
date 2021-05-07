import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/pages/activity_feed.dart';
import 'package:flutter_share/pages/profile.dart';
import 'package:flutter_share/pages/search.dart';
import 'package:flutter_share/pages/timeline.dart';
import 'package:flutter_share/pages/upload.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    googleSignIn.onCurrentUserChanged.listen(
      (account) => handleSignIn(account),
      onError: (err) => print("Error is occured $err"),
    );
    googleSignIn
        .signInSilently(suppressErrors: false)
        .then((account) => handleSignIn(account))
        .catchError((err) => print("Error occured! $err"));
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  handleSignIn(account) {
    if (account != null) {
      print("User sign in with $account");
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  bool isAuth = false;

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChange(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  onTapChangePage(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChange,
        children: [
          Timeline(),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTapChangePage,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera, size: 35)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
        ],
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor,
          ],
        )),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "FlutterShare",
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90.0,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/google_signin_button.png"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
