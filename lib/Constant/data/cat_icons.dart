import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../pages/login.dart';

bool internet = true;
ValueNotifying valueNotifierHome = ValueNotifying();

class ValueNotifying {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

class DevideEntry {
  final String name;
  final Widget page;

  DevideEntry({required this.name, required this.page});
}

ValueNotifying valueNotifier = ValueNotifying();

class ValueNotifyingHome {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

class ValueNotifyingNotification {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

internetTrue() {
  internet = true;
  valueNotifierHome.incrementNotifier();
}

getDetailsOfDevice() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    internet = false;
  } else {
    internet = true;
  }
  try {
    final prefs = await SharedPreferences.getInstance();
    var token = await SignIn.login().then(
        (value) => value?.authentication.then((token) => token.accessToken));
    await prefs.setString('token', token.toString());
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

class DevideEntry1 {
  final String name;
  final Widget page;

  DevideEntry1({required this.name, required this.page});
}
