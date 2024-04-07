import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/pages/rootapp.dart';
import 'package:smarthome/pages/loading.dart';
import 'package:smarthome/pages/nointernet.dart';
import '../Constant/data/cat_icons.dart';
import 'login_page.dart';

import '../Constant/style.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

dynamic package;

class _LoadingPageState extends State<LoadingPage> {
  bool _isLoading = false;
  var demopage = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCheck();
  }

  // Future<bool> checkLoginStatus() async {
  //   await SignIn.googleSignIn.signInSilently(suppressErrors: false);
  //   return SignIn.googleSignIn.currentUser != null;
  // }

  Future<void> getCheck() async {
    if (internet == true) {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("Bearer");
      var name = prefs.getString("name");
      var email = prefs.getString("email");
      var profilePic = prefs.getString("photo");
      print("name: " + name.toString());
      print("token: " + token.toString());

      (name != null && name != "")
          ? Future.delayed(Duration(seconds: 5), () {
              print("RootApp");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RootApp(
                          name: name,
                          email: email,
                          profilePictureUrl: profilePic,
                        )),
              );
            })
          : Future.delayed(Duration(seconds: 5), () {
              print("LoginPage");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            });
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: Scaffold(
        backgroundColor: white,
        body: Stack(
          children: [
            Container(
              height: media.height * 1,
              width: media.width * 1,
              decoration: BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(media.width * 0.01),
                      width: media.width * 0.429,
                      height: media.width * 0.429,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/logo.png'),
                              fit: BoxFit.contain)),
                    ),
                  ),

                  // Text("FIT FIN PHY"),
                ],
              ),
            ),

            //loader
            (_isLoading == true && internet == true)
                ? const Positioned(top: 0, child: Loading())
                : Container(),
            //internet is not connected
            (internet == false)
                ? Positioned(
                    top: 0,
                    child: NoInternet(
                      onTap: () {
                        print("internet");
                        setState(() {
                          internetTrue();
                          getCheck();
                        });
                      },
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }
}
