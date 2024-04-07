import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/pages/login.dart';

import '../../Constant/Functions/functions.dart';
import '../Constant/style.dart';
import 'login_page.dart';

class SettingPage extends StatefulWidget {
  final String? name;
  final String? email;
  final String? profilePictureUrl;
  const SettingPage({Key? key, this.name, this.email, this.profilePictureUrl})
      : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  void getname() async {
    final prefs = await SharedPreferences.getInstance();
  }

  Future<void> scheduleNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final now = DateTime.now();
    var dt = Time(8, 0, 0);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'SmartHome',
      'Test Notification',
      dt,
      platformChannelSpecifics,
      payload: 'morning_notification',
    );
  }

  ImageProvider<Object> _getImageProvider(String? url) {
    try {
      if (url != null && Uri.parse(url).isAbsolute) {
        return NetworkImage(url);
      }
    } catch (e) {
      print('Error loading image from URL: $e');
    }
    return AssetImage('assets/images/logo-white.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          color: backgroundColor,
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.only(bottom: size.width * 0.05),
                                width: size.width * 1,
                                alignment: Alignment.center,
                                child: Text(
                                  "Setting",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: size.width * twenty,
                                      fontWeight: FontWeight.w600,
                                      color: white),
                                ),
                              ),
                              Positioned(
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.arrow_back_rounded,
                                          color: white)))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    //  gradient: LinearGradient(colors: [secondary, primary]),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: size.width * 0.25,
                        width: size.width * 0.25,
                        // decoration: BoxDecoration(
                        //   shape: BoxShape.circle,
                        //   image: DecorationImage(
                        //     image: AssetImage("assets/images/logo.png"),
                        //     fit: BoxFit.cover,
                        //   ),
                        // )
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:
                                    _getImageProvider(widget.profilePictureUrl),
                                fit: BoxFit.cover)),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text(
                        widget.name ?? 'Maria',
                        style: TextStyle(
                            fontSize: size.width * twenty, color: white),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      TextButton(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Location",
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: size.width * sixteen,
                                    color: white),
                              ),
                            ),
                            Text(
                              "Windsor, Ontario",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: size.width * sixteen,
                                  color: white),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      TextButton(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Emergency",
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: size.width * sixteen,
                                    color: white),
                              ),
                            ),
                            Text(
                              "911 Police",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: size.width * sixteen,
                                  color: white),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            var user = await SignIn.signOut;
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.clear();
                            singOut();
                            user == null
                                ? Navigator.push(
                                    context!,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  )
                                : print("not null");
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: size.width * sixteen,
                                  color: white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
