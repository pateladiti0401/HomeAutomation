import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/pages/loadingpage.dart';
import 'package:smarthome/pages/rootapp.dart';
import 'package:flutter/material.dart';
import 'mqtt.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final mqttService = MqttService();
  // await mqttService.connectToMqttServer();

  setMarginsForSystemUI();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final MqttService mqttService = MqttService();
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  void requestPermissions() async {
    PermissionStatus notificationStatus =
        await Permission.notification.request();

    if (
        // cameraStatus.isGranted &&
        //   microphoneStatus.isGranted &&
        notificationStatus.isGranted) {
      // Permissions granted, you can proceed with your logic
    } else {
      // Permissions not granted, handle the scenario accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        // systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat'),
      //  home: LoadingPage(),
      home: ChangeNotifierProvider(
        create: (context) => MqttService(),
        child: LoadingPage(),
      ),
    );
  }
}

void setMarginsForSystemUI() {
  final SystemUiOverlayStyle light = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent.withAlpha(1),
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: false,
  );
  SystemChrome.setSystemUIOverlayStyle(light);
}
