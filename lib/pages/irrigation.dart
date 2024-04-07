import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../Constant/style.dart';
import '../Widget/widgets.dart';
import '../mqtt.dart';

class IrrigationPage extends StatefulWidget {
  // final MqttService mqttService;
  // IrrigationPage({required this.mqttService});

  @override
  _IrrigationPageState createState() => _IrrigationPageState();
}

class _IrrigationPageState extends State<IrrigationPage> {
  String soilStatus = 'Unknown';
  bool _isLightOn = false;
  bool isSwitched = false;
  bool isCut = false;
  late final MqttService mqttService = MqttService();
  MqttClient? client;

  @override
  void initState() {
    super.initState();
    initializeMqttService();
  }

  Future<void> initializeMqttService() async {
    await mqttService.connectToMqttServer();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: backgroundColor,
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.width * 0.10),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: size.width * 0.05),
                  width: size.width * 1,
                  alignment: Alignment.center,
                  child: Text(
                    "Smart Graden",
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
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: white,
                        )))
              ],
            ),
            // Text(
            //   'Soil Status: $soilStatus',
            //   style: TextStyle(fontSize: 20),
            // ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        Text(
                          "Humidity".toUpperCase(),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: size.width * fourteen,
                              fontWeight: FontWeight.bold,
                              color: white),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        CircularPercentIndicator(
                          radius: 80.0,
                          lineWidth: 10.0,
                          percent: 0.45,
                          startAngle: 180,
                          backgroundColor: Colors.grey,
                          progressColor: primary.withOpacity(0.7),
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            "45%",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: size.width * twentyfour,
                                fontWeight: FontWeight.bold,
                                color: white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: size.width * 0.09),
                    Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        Text(
                          "Temp".toUpperCase(),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: size.width * fourteen,
                              fontWeight: FontWeight.bold,
                              color: white),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        CircularPercentIndicator(
                          radius: 80.0,
                          lineWidth: 10.0,
                          percent: 0.55,
                          startAngle: 180,
                          backgroundColor: Colors.grey,
                          progressColor: primary.withOpacity(0.7),
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            "55%",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: size.width * twentyfour,
                                fontWeight: FontWeight.bold,
                                color: white),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Auto Irrigate",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: size.width * sixteen,
                      fontWeight: FontWeight.bold,
                      color: white),
                ),
                SizedBox(height: size.height * 0.03),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                      mqttService.publishMessage(
                          'servo/control', isSwitched ? 'on' : 'off');
                    });
                  },
                  activeTrackColor: white.withOpacity(0.7),
                  activeColor: primary,
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Grass Cutter",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: size.width * sixteen,
                      fontWeight: FontWeight.bold,
                      color: white),
                ),
                SizedBox(height: size.height * 0.03),
                Switch(
                  value: isCut,
                  onChanged: (value) {
                    setState(() {
                      isCut = value;
                      mqttService.publishMessage(
                          'cutter/machine', isCut ? 'on' : 'off');
                    });
                  },
                  activeTrackColor: white.withOpacity(0.7),
                  activeColor: primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
