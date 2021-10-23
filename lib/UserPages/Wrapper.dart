import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mjengoni/UserPages/GettingStartedScreen.dart';
import 'package:mjengoni/UserPages/HomePage.dart';
import 'package:mjengoni/UserPages/SetupProfilePage.dart';
import 'package:mjengoni/main.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String onlineUserId;
  String _controller;

  @override
  void initState() {
    super.initState();
    //showRevealDialog(context);

    getUser().then((user) async {
      if (user == null) {
        setState(() {
          _controller = 'out';
        });
      } else {
        // print(user.toString());
        final snapShot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();
        if (snapShot.exists) {
          setState(() {
            _controller = 'home';
          });
        } else {
          setState(() {
            _controller = 'info';
          });
        }
      }
    });
    Timer(
      Duration(seconds: 5),
      () {
        print('done');
        if (_controller == 'out') {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => GettingStartedScreen(),
              ),
              (r) => false);
        } else if (_controller == 'info') {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => SetupProfilePage(),
              ),
              (r) => false);
        } else if (_controller == 'home') {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => HomePage(),
              ),
              (r) => false);
        } else if (_controller == null) {
          MyApp.restartApp(context);
        }
      },
    );
  }

  Future<User> getUser() async {
    return _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  width: MediaQuery.of(context).size.width / 1.4,
                  image: AssetImage(
                    'assets/images/Mjengoni_logo.png',
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
