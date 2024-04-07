import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smarthome/Constant/data/cat_icons.dart';
import 'package:smarthome/pages/cleaner.dart';
import 'package:smarthome/pages/lightcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constant/style.dart';
import '../Widget/widgets.dart';
import '../mqtt.dart';
import 'AddDevice.dart';

class RoomDetailPage extends StatefulWidget {
  final Map<String, dynamic> room;
  //final MqttService mqttService;
  RoomDetailPage({required this.room});

  @override
  _RoomDetailPageState createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  // late final MqttService mqttService = MqttService();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void initState() {
    super.initState();
    initializeMqttService();
    //initializeNotifications();
    initializeDeviceEntries();
  }

  // Future<void> initializeNotifications() async {
  //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid);
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  Future<void> _sendNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_temp_alert', // channel ID
      'High Temperature Alert', // channel name

      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }

  String temperature = '53.20';
  String humidity = '63.40';
  final List<DevideEntry1> deviceEntries = [];

  Future<void> initializeMqttService() async {
    await mqttService.connectToMqttServer();
    mqttService.subscribed('website/temperature', (data) {
      setState(() {
        print("temperature dataa " + data);
        temperature = data;
      });
      // if (double.parse(data) >= 64.50) {
      //   print("alert: $data");
      //   _sendNotification('High Temperature Alert', 'Temperature is $data');
      // }
    });
    mqttService.subscribed('website/humidity', (data1) {
      setState(() {
        print("humidity dataa " + data1);
        humidity = data1;
      });
    });
  }

  late final MqttService mqttService = MqttService();
  void initializeDeviceEntries() {
    deviceEntries.clear(); // Clear previous entries if needed
    deviceEntries.addAll([
      DevideEntry1(
          name: 'Light',
          page: ColorPickerPage(
            mqttService: mqttService,
          )),
      DevideEntry1(
          name: 'Cleaner',
          page: Cleaner(
            mqttService: mqttService,
          )),
    ]);
  }

  double _intensityValue = 50;
  double _intensityValue1 = 50;
  int _temperature = 10;

  // final List<String> devices = [
  //   'Apple TV',
  //   'Home Theater',
  //   'Speakers',
  //   'Smart Door Locks',
  //   'Device 3',
  //   'Device 4',
  //   'Device 5',
  // ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    widget.room['image'],
                    width: MediaQuery.of(context).size.width,
                    height: size.height * 0.35,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: Container(
                        width: size.width * 0.9,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        color: Colors.black.withOpacity(0.5),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                //   crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Room',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: size.width * fourteen,
                                            color: white),
                                      ),
                                      Text(
                                        widget.room['text'],
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: size.width * twenty,
                                            color: white),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'T= $temperature°C',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: size.width * fourteen,
                                            color: white),
                                      ),
                                      Text(
                                        'H= $humidity°C',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: size.width * fourteen,
                                            color: white),
                                      ),
                                    ],
                                  ),
                                ]),
                          ],
                        )),
                  ),
                ],
              ),
              SizedBox(width: size.width * 0.03),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ColorPickerPage(mqttService: mqttService),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: white),
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                        colors: [primary.withOpacity(0.7), primary]),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Stack(children: [
                            Center(
                              child: Text(
                                'Main Lights',
                                style: TextStyle(
                                    fontSize: size.width * fourteen,
                                    fontWeight: FontWeight.bold,
                                    color: white),
                              ),
                            ),
                            SizedBox(height: size.height * 0.045),
                            Positioned(
                              left: (size.width * 0.3 - 100) / 2,
                              right: (size.width * 0.3 - 100) / 2,
                              bottom: -1,
                              child: Container(
                                height: 4,
                                color: white, // Adjust the color as needed
                              ),
                            ),
                          ]),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Intensity',
                            style: TextStyle(
                                fontSize: size.width * twelve,
                                fontWeight: FontWeight.bold,
                                color: white),
                          ),
                          Slider(
                            value: _intensityValue,
                            activeColor: white,
                            inactiveColor: white.withOpacity(0.1),
                            min: 0,
                            max: 100000,
                            divisions: 100,
                            label: _intensityValue.round().toString(),
                            onChanged: (newValue) {
                              setState(() {
                                //  _intensityValue = newValue;
                                // String intensityMessage =
                                //     _intensityValue.round().toString();
                                // mqttService.publishMessage(
                                //     "website/ldrsensor/data", intensityMessage);
                                // print("inteeeeeee" + intensityMessage);
                                _intensityValue = newValue
                                    .roundToDouble(); // Update _intensityValue with new slider value
                                String intensityMessage =
                                    _intensityValue.round().toString();
                                mqttService.publishMessage(
                                    "website/ldrsensor/data", intensityMessage);
                                print("New intensity value: $intensityMessage");
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.03),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: white),
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                      colors: [primary.withOpacity(0.7), primary]),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(children: [
                      Center(
                        child: Text(
                          'Floor Lights',
                          style: TextStyle(
                              fontSize: size.width * fourteen,
                              fontWeight: FontWeight.bold,
                              color: white),
                        ),
                      ),
                      SizedBox(height: size.height * 0.045),
                      Positioned(
                        left: (size.width * 0.3 - 100) / 2,
                        right: (size.width * 0.3 - 100) / 2,
                        bottom: -1,
                        child: Container(
                          height: 4,
                          color: white, // Adjust the color as needed
                        ),
                      ),
                    ]),
                    Column(
                      children: [
                        Text(
                          'Intensity',
                          style: TextStyle(
                              fontSize: size.width * twelve,
                              fontWeight: FontWeight.bold,
                              color: white),
                        ),
                        Slider(
                          value: _intensityValue1,
                          activeColor: white,
                          inactiveColor: white.withOpacity(0.1),
                          min: 0,
                          max: 100,
                          divisions: 100, // To display discrete values
                          label: _intensityValue1.round().toString(),
                          onChanged: (newValue) {
                            setState(() {
                              _intensityValue1 = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: white),
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                      colors: [primary.withOpacity(0.7), primary]),
                ),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(children: [
                      Center(
                        child: Text(
                          'Air Conditioner',
                          style: TextStyle(
                              fontSize: size.width * fourteen,
                              fontWeight: FontWeight.bold,
                              color: white),
                        ),
                      ),
                      SizedBox(height: size.height * 0.045),
                      Positioned(
                        left: (size.width * 0.3 - 100) / 2,
                        right: (size.width * 0.3 - 100) / 2,
                        bottom: -1,
                        child: Container(
                          height: 4,
                          color: white, // Adjust the color as needed
                        ),
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_temperature°C',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: size.width * twenty,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: white),
                          onPressed: () {
                            setState(() {
                              if (_temperature < 32) _temperature += 1;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.remove,
                            color: white,
                          ),
                          onPressed: () {
                            setState(() {
                              _temperature -= 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              SizedBox(
                height: size.height * 0.16,
                width: double.infinity,
                child: CarouselSlider(
                  options: CarouselOptions(
                    initialPage: 1,
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    viewportFraction: 0.4,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                  ),
                  items: deviceEntries.map((device) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => device.page),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(colors: [
                                  primary.withOpacity(0.7),
                                  primary
                                ]),
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              width: size.width * 0.5,
                              height: 50,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: white),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        device.name,
                                        style: TextStyle(
                                          fontSize: size.width * twelve,
                                          color: white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: (size.width * 0.4 - 100) / 2,
                                    right: (size.width * 0.4 - 100) / 2,
                                    bottom: 10,
                                    child: Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Button(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddDeviceForm()),
                  );
                },
                text: 'Add Device',
                width: size.width * 0.7,
              ),
            ],
          ),
        ));
  }
}
