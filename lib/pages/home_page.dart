import 'dart:convert';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smarthome/Constant/data/cat_icons.dart';
import 'package:smarthome/Widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/mqtt.dart';
import 'package:smarthome/pages/AddRoom.dart';
import 'package:smarthome/pages/Roomdetail.dart';
import 'package:http/http.dart' as http;
import 'package:smarthome/pages/irrigation.dart';

import '../Constant/style.dart';
import 'cleaner.dart';
import 'lightcolors.dart';

class HomePage extends StatefulWidget {
  final String? name;
  final String? email;
  const HomePage({Key? key, this.name, this.email}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late final MqttService mqttService = MqttService();
  String _location = 'Windsor, Ontario';
  String _weatherCondition = 'Mostly Cloudy';
  String _temperature = '8°C';
  String _humidity = '36%';
  String _windSpeed = '10 km/h';
  IconData weatherIcon = Icons.cloudy_snowing;

  @override
  void initState() {
    super.initState();
    initializeMqttService();
    _fetchWeatherData();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fetchWeatherData();
    initializeMqttService();
  }

  Future<void> _sendNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'abc', // channel ID
      'dustbin Alert', // channel name

      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      1, // notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> initializeMqttService() async {
    await mqttService.connectToMqttServer();

    mqttService.subscribed('dustbin/percentage', (data) {
      setState(() {
        print("dustbin dataa " + data);
      });
      if (double.parse(data) == 95) {
        print("alert: $data");
        _sendNotification('Dustbin Full Alert', 'Your dustbin is $data% full');
      }
      if (double.parse(data) == 97) {
        print("alert: $data");
        _sendNotification('Dustbin Full Alert', 'Your dustbin is $data% full');
      }
      if (double.parse(data) == 99) {
        print("alert: $data");
        _sendNotification('Dustbin Full Alert', 'Your dustbin is $data% full');
      }
    });
  }

  Future<void> _fetchWeatherData() async {
    final apiKey = '42eea618682b56bd069c715f4da76fa7';
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$_location&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final jsonData = json.decode(response.body);
      setState(() {
        _weatherCondition = jsonData['weather'][0]['description'];
        final temp = jsonData['main']['temp'] as double;
        _temperature =
            int.parse(jsonData['main']['temp'].toStringAsFixed(0)).toString() +
                '°C';
        _humidity = jsonData['main']['humidity'].toString() + '%';
        _windSpeed = jsonData['wind']['speed'].toString() + ' km/h';
        String weatherIconCode = jsonData['weather'][0]['icon'];
        Icon weatherIcon = Icon(
          _getWeatherIcon(int.parse(weatherIconCode)),
          size: 24,
          color: white,
        );
      });
    } catch (error) {
      print('Error fetching weather data: $error');
    }
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
    final List<Map<String, dynamic>> items = [
      {'text': 'Kitchen', 'image': 'assets/images/kitchen.png'},
      {'text': 'Bedroom', 'image': 'assets/images/bedroom.jpg'},
      {'text': 'Living Room', 'image': 'assets/images/living_room.png'},
      {'text': 'Bathroom', 'image': 'assets/images/bathroom.jpg'}
    ];

    final List<DevideEntry> deviceEntries = [
      DevideEntry(
          name: 'Light',
          page: ColorPickerPage(
            mqttService: mqttService,
          )),
      DevideEntry(
          name: 'Cleaner',
          page: Cleaner(
            mqttService: mqttService,
          )),
      DevideEntry(name: 'Garden System', page: IrrigationPage()),
    ];

    return Material(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: size.height,
                width: size.width,
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.zero,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello " + widget.name.toString() ?? "Maria",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: size.width * eighteen,
                                      color: white),
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Text(
                                  // widget.name ?? "User",
                                  "welcome to Home",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: size.width * fourteen,
                                      fontWeight: FontWeight.bold,
                                      color: white.withOpacity(0.8)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Icon(Icons.notifications, color: white),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                      // height: size.height * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                            colors: [primary.withOpacity(0.7), primary]),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                weatherIcon,
                                size: size.height * twenty,
                                color: Colors.white,
                              ),
                              // SizedBox(width: 12.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    _weatherCondition.toUpperCase() ??
                                        'Mostly Cloudy',
                                        
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: size.width * twenty,
                                      color: white,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    _location ?? 'Windsor, Ontario',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: size.width * twelve,
                                      color: white.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(width: 12.0),
                              Text(
                                _temperature ?? '24°',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: size.width * fourty,
                                  color: white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.025),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WeatherDetailItem(
                                  title: 'Sensible', value: _temperature),
                              WeatherDetailItem(
                                  title: 'Participation', value: '4%'),
                              WeatherDetailItem(
                                  title: 'Humidity', value: _humidity),
                              WeatherDetailItem(
                                  title: 'Wind', value: _windSpeed),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rooms",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: size.width * sixteen,
                                fontWeight: FontWeight.bold,
                                color: white),
                          ),
                          Button(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RoomForm()),
                              );
                            },
                            text: 'Add',
                            // width: size.width * 0.1,
                            color: white,
                            textcolor: white,
                            grad1: backgroundColor,
                            grad2: backgroundColor,
                            borcolor: backgroundColor,
                          ),
                        ]),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    // Expanded(
                    //     child:
                    SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                aspectRatio: 16 / 9,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false,
                                initialPage: 2,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                              ),
                              items: items.map((item) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RoomDetailPage(
                                              room: item,
                                            ),
                                          ),
                                        );
                                      },
                                      child: _buildRoomItem(context, item),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ]),
                      //  )
                    ),

                    //second row
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Quick Access",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: size.width * sixteen,
                                fontWeight: FontWeight.bold,
                                color: white),
                          ),
                          // Button(
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => RoomForm()),
                          //     );
                          //   },
                          //   text: 'Add',
                          //   // width: size.width * 0.1,
                          //   color: white,
                          //   textcolor: white,
                          //   grad1: backgroundColor,
                          //   grad2: backgroundColor,
                          //   borcolor: backgroundColor,
                          // ),
                        ]),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    SizedBox(
                      height: size.height * 0.1,
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
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    width: size.width * 0.5,
                                    height: 50,
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: white),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildRoomItem(BuildContext context, Map<String, dynamic> item) {
  var size = MediaQuery.of(context).size;
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(horizontal: 5.0),
    decoration: BoxDecoration(
        // color: Colors.green,
        ),
    child: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          item['image'],
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            padding: EdgeInsets.all(8.0),
            child: Text(
              item['text'],
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: size.width * fourteen,
                  color: white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ),
  );
}

IconData _getWeatherIcon(int weatherConditionCode) {
  IconData iconData;

  // Map weather condition codes to corresponding Cupertino icons
  switch (weatherConditionCode) {
    case 200:
    case 201:
    case 202:
    case 210:
    case 211:
    case 212:
    case 221:
    case 230:
    case 231:
    case 232:
      // Thunderstorm
      iconData = CupertinoIcons.cloud_bolt;
      break;
    case 300:
    case 301:
    case 302:
    case 310:
    case 311:
    case 312:
    case 313:
    case 314:
    case 321:
      // Drizzle
      iconData = CupertinoIcons.cloud_drizzle;
      break;
    case 500:
    case 501:
    case 502:
    case 503:
    case 504:
      // Rain
      iconData = CupertinoIcons.cloud_rain;
      break;
    case 511:
    case 520:
    case 521:
    case 522:
    case 531:
      // Rain/snow
      iconData = CupertinoIcons.cloud_rain_fill;
      break;
    case 600:
    case 601:
    case 602:
    case 611:
    case 612:
    case 613:
    case 615:
    case 616:
    case 620:
    case 621:
    case 622:
      // Snow
      iconData = CupertinoIcons.snow;
      break;
    case 701:
    case 711:
    case 721:
    case 731:
    case 741:
    case 751:
    case 761:
    case 762:
    case 771:
    case 781:
      // Fog
      iconData = CupertinoIcons.cloud_fog;
      break;
    case 800:
      // Clear
      iconData = CupertinoIcons.sun_max;
      break;
    case 801:
    case 802:
    case 803:
    case 804:
      // Clouds
      iconData = CupertinoIcons.cloud_fill;
      break;
    default:
      // Default icon for unknown conditions
      iconData = CupertinoIcons.question;
  }

  return iconData;
}
