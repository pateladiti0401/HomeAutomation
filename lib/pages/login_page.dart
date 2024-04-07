import 'dart:convert';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/pages/rootapp.dart';

import '../Constant/Functions/functions.dart';
import '../Constant/style.dart';
import '../Widget/widgets.dart';
import 'login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: getBody(),
    );
  }

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> getGoogleLogin1() async {
    // try {
    //   final GoogleSignInAccount? googleSignInAccount =
    //       await googleSignIn.signIn();
    //   if (googleSignInAccount != null) {
    //     final GoogleSignInAuthentication googleAuth =
    //         await googleSignInAccount.authentication;
    //     final AuthCredential credential = GoogleAuthProvider.credential(
    //       accessToken: googleAuth.accessToken,
    //       idToken: googleAuth.idToken,
    //     );
    //     final UserCredential authResult =
    //         await _auth.signInWithCredential(credential);
    //     final User? user = authResult.user;
    //     return user;
    //   }
    // } catch (error) {
    //   print(error);
    //   // Handle error
    // }
    // return null;
    var googleUser = await SignIn.login();
    var userAuth = await googleUser!.authentication;
    print("uussseeeerrrrr" + googleUser.email);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', googleUser.displayName.toString());
    await prefs.setString('photo', googleUser.photoUrl.toString());
    await prefs.setString('email', googleUser.email);
    await prefs.setString('token', googleUser.id.toString());
    if (googleUser != null) {
      signIn(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RootApp(
                  email: googleUser.email,
                  name: googleUser.displayName.toString(),
                  profilePictureUrl: googleUser.photoUrl.toString(),
                )),
      );
    } else {
      showToast("Login Failedddd");
    }
  }

  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  Future<void> getGoogleLogin() async {
    print("click");
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // Get authentication tokens
        final authHeaders = await googleSignInAccount.authHeaders;

        // Get user information
        final googleName = googleSignInAccount.displayName;
        final googleEmail = googleSignInAccount.email;
        final googlePhotoUrl = googleSignInAccount.photoUrl;

        // Access token
        final googleToken = authHeaders['Authorization'];

        // Save user information to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('googleName', googleName ?? '');
        prefs.setString('googleEmail', googleEmail ?? '');
        prefs.setString('googlePhotoUrl', googlePhotoUrl ?? '');
        prefs.setString('googleToken', googleToken ?? '');

        // Use authHeaders to authenticate requests using googleapis
        // For example:
        // final client = http.Client();
        // final googleAPI = SomeGoogleAPI(client);
        // final response = await googleAPI.someMethod();
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return Material(
        child: Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              // height: size.height,
              child: Column(
                children: [
                  Container(
                    // padding: EdgeInsets.only(
                    //     top: size.width * 0.1, left: size.width * 0.05),
                    width: size.width,
                    height: size.height * 0.37,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [primary, secondary.withOpacity(0.7)]),
                        border: Border.all(
                          color: primary.withOpacity(0.7),
                          width: 1,
                        )),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.1,
                          ),
                          Container(
                            alignment: Alignment.center,
                            // margin: EdgeInsets.only(left: size.width * 0.5),
                            // width: size.width * 0.229,
                            height: size.width * 0.229,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/logo-white.png'),
                                    fit: BoxFit.contain)),
                          ),
                          // SizedBox(
                          //   height: size.height * 0.1,
                          // ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.05,
                                  vertical: size.height * 0.03),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Welcome to",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontFamily: 'Montserrat',
                                        letterSpacing: 0.5,
                                        fontSize: size.width * twenty,
                                        color: white.withOpacity(0.4)),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Text(
                                    "Smart Home",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        letterSpacing: 2.5,
                                        fontSize: size.width * twentyeight,
                                        color: white),
                                  )
                                ],
                              )),
                        ]),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        "Sign in or create a FREE account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: size.width * twentyfour,
                            color: textColor),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    // margin: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "Experience the Future of Home Management",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: size.width * sixteen,
                            color: offline),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    // margin: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "Manage your home from anytime, anywhere",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: size.width * sixteen,
                            color: offline),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => RootApp()),
                  //     );
                  //   },
                  //   child: Container(
                  //     height: size.width * 0.12,
                  //     width: size.width * 0.6,
                  //     padding: EdgeInsets.only(
                  //         left: size.width * twenty,
                  //         right: size.width * twenty),
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(12),
                  //         // color: (widget.color != null) ? widget.color : buttonColor,
                  //         gradient:
                  //             LinearGradient(colors: [primary, secondary]),
                  //         border: Border.all(
                  //           color: primary.withOpacity(0.7),
                  //           width: 1,
                  //         )),
                  //     child: FittedBox(
                  //         fit: BoxFit.contain,
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(
                  //               "Guest Login",
                  //               style: TextStyle(
                  //                   fontFamily: 'Montserrat',
                  //                   fontSize: size.width * fourteen,
                  //                   color: white,
                  //                   fontWeight: FontWeight.bold,
                  //                   letterSpacing: 1),
                  //             ),
                  //           ],
                  //         )),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: size.height * 0.03,
                  // ),
                  InkWell(
                    onTap: () async {
                      getGoogleLogin1();
                      // User? user = await getGoogleLogin1();
                      // if (user != null) {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => RootApp()),
                      //   );
                      // } else {
                      //   showToast("Login Failed");
                      // }
                    },
                    child: Container(
                      height: size.width * 0.12,
                      width: size.width * 0.6,
                      padding: EdgeInsets.only(
                          left: size.width * twenty,
                          right: size.width * twenty),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          // color: (widget.color != null) ? widget.color : buttonColor,
                          gradient:
                              LinearGradient(colors: [primary, secondary]),
                          border: Border.all(
                            color: primary.withOpacity(0.7),
                            width: 1,
                          )),
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                //padding: EdgeInsets.all(size.width * 0.01),
                                width: size.width * 0.06,
                                height: size.width * 0.06,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/google.png'),
                                        fit: BoxFit.contain)),
                              ),
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                              Text(
                                "Sign in with Google",
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: size.width * fourteen,
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   //padding: EdgeInsets.all(size.width * 0.01),
            //   width: double.infinity   ,
            //   height: size.height * 0.45,
            //   decoration: const BoxDecoration(
            //       image: DecorationImage(
            //           image: AssetImage(
            //               'assets/images/backpic.png'),
            //           fit: BoxFit.contain)),
            // ),
          ],
        ),
      ),
    ));
  }
}
