import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/rootapp.dart';
import '../data/cat_icons.dart';

class BearerClass {
  final String token;
  BearerClass({required this.token});

  BearerClass.fromJson(Map<String, dynamic> json) : token = json['token'];

  Map<String, dynamic> toJson() => {'token': token};
}

dynamic prefs;
String url = '';
List<BearerClass> bearerToken = <BearerClass>[];
Map<String, dynamic> userData = {};
String mapStyle = '';
getDetailsOfDevice() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    internet = false;
  } else {
    internet = true;
  }
  try {
    rootBundle.loadString('assets/map_style.json').then((value) {
      mapStyle = value;
    });
    // var token = await FirebaseMessaging.instance.getToken();
    // fcm = token;
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    print(e);
  }
}

signIn(BuildContext? context) async {
  dynamic result;
  final prefs = await SharedPreferences.getInstance();
  var name = prefs.getString("name");
  var email = prefs.getString("email");
  var profilePic = prefs.getString("photo");
  var id = prefs.getString("token");
  try {
    var response = await http.post(Uri.parse('${url}auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            "name": name,
            "email": email,
            "phone": "",
            "profile_url": profilePic,
            "social_id": id
          },
        ));
    if (response.statusCode == 200) {
      debugPrint("res1 " + response.body);
      userData = jsonDecode(response.body)['data'];

      bearerToken.add(BearerClass(token: userData['api_token'].toString()));
      prefs.setString('Bearer', bearerToken[0].token);

      print("bearetoken: " + prefs.getString("Bearer").toString());
      print(userData.toString());
      Navigator.push(
        context!,
        MaterialPageRoute(
            builder: (context) => RootApp(
                  email: email,
                  name: name,
                  profilePictureUrl: profilePic,
                )),
      );
    } else {
      debugPrint("res3 " + response.body);
      result = 'false';
    }
  } catch (e) {
    print(e);
  }
  return result;
}

singOut() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}auth/logout'), headers: {
      'Authorization': 'Bearer ${bearerToken[0].token}',
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      prefs.remove('Bearer');
print(response.body);
      result = 'success';
    } else {
      ////debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    print(e);
  }
  return result;
}
