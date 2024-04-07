import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/mqtt.dart';
import 'package:smarthome/pages/irrigation.dart';
import 'package:smarthome/pages/menu.dart';
import 'package:smarthome/pages/setting.dart';
import '../Constant/style.dart';
import 'home_page.dart';

class RootApp extends StatefulWidget {
  String? name;
  String? email;
  String? profilePictureUrl;
  RootApp({Key? key, this.email, this.name, this.profilePictureUrl})
      : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  late final MqttService mqttService;
  void initState() {
    super.initState();
    initializeMqttService();
  }

  Future<void> initializeMqttService() async {
    // mqttService = MqttService(); // Instantiate MQTT service
    // await mqttService.connectToMqttServer(); // Connect to MQTT server
  }

  @override
  Widget build(BuildContext context) {
    var systemNavigationBarHeight = MediaQuery.of(context).padding.bottom;
    return Scaffold(
        backgroundColor: backgroundColor,
        body: getBody(),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: systemNavigationBarHeight,
          ),
          child: getFooter(),
        ));
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: [
        HomePage(
          email: widget.email,
          name: widget.name,
        ),
        Menu(),
        // IrrigationPage(
        //   mqttService: mqttService,
        // ),
        SettingPage(
          email: widget.email,
          name: widget.name,
          profilePictureUrl: widget.profilePictureUrl,
        ),
      ],
    );
  }

  Widget getFooter() {
    List items = [
      Icons.home_outlined,
      Icons.menu_outlined,
      Icons.settings_outlined
    ];
    List itemsname = ["Home", "Menu", "Settings"];
    var size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 5, top: 10),
      height: size.height * 0.078,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: -7,
            offset: const Offset(0, -8),
          ),
        ],
        border:
            Border(top: BorderSide(width: 1, color: black.withOpacity(0.06))),
      ),
      child:
          // padding:
          //     const EdgeInsets.only(left: 20, right: 20, bottom:15, top: 15),
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          return InkWell(
            onTap: () {
              setState(() {
                pageIndex = index;
              });
            },
            child: Column(
              children: [
                Icon(
                  items[index],
                  size: 26,
                  color: pageIndex == index ? white : white.withOpacity(0.5),
                ),
                SizedBox(
                  height: size.height * 0.001,
                ),
                pageIndex == index
                    ? Container(
                        child: Text(
                          itemsname[index],
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * twelve),
                        ),
                      )
                    : Container()
              ],
            ),
          );
        }),
      ),
    );
  }
}
