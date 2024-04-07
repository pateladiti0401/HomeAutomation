import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:smarthome/mqtt.dart';

import '../Constant/style.dart';

class ColorPickerPage extends StatefulWidget {
  final MqttService mqttService;
  ColorPickerPage({required this.mqttService});

  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color _selectedColor = Colors.yellow;
  bool _isLightOn = false;
  TimeOfDay selectedTime = TimeOfDay(hour: 18, minute: 0);
  TimeOfDay selectedTimeTo = TimeOfDay(hour: 22, minute: 0);

  Future<void> _selectTime(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _selectTimeTo(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTimeTo) {
      setState(() {
        selectedTimeTo = picked;
      });
    }
  }

  void _setColor(Color color) {
    setState(() {
      _selectedColor = color;
      int red = _selectedColor.red;
      int green = _selectedColor.green;
      int blue = _selectedColor.blue;
      Map<String, dynamic> colorJson = {
        'red': red,
        'green': green,
        'blue': blue,
      };

      // Convert JSON object to string
      String jsonMessage = jsonEncode(colorJson);

      // Publish MQTT message with JSON string
      widget.mqttService.publishMessage('light/color', jsonMessage);
    });
  }

  // void _toggleLight() {
  //   setState(() {
  //     _isLightOn = !_isLightOn;
  //     print(_isLightOn);
  //     widget.mqttService
  //         .publishMessage('website/status', _isLightOn ? 'on' : 'off');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor,
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.width * 0.10),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: size.width * 0.05),
                width: size.width, // Adjust width as needed
                height: size.height * 0.08,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Align children horizontally
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Align children vertically
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: white,
                      ),
                    ),
                    Text(
                      "LED Light",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: size.width * twenty,
                        fontWeight: FontWeight.w600,
                        color: white,
                      ),
                    ),
                    Switch(
                      value: _isLightOn,
                      onChanged: (value) {
                        setState(() {
                          _isLightOn = value;
                          widget.mqttService.publishMessage(
                              'website/status', _isLightOn ? 'on' : 'off');
                        });
                      },
                      activeTrackColor: white.withOpacity(0.7),
                      activeColor: primary,
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: _isLightOn ? _selectedColor : Colors.transparent,
                      blurRadius: 70,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.lightbulb,
                    size: 100,
                    color: _isLightOn ? _selectedColor : Colors.grey[400],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                child: CircleColorPicker(
                  textStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: size.width * 0,
                    color: backgroundColor,
                  ),
                  onChanged: _setColor,
                  size: const Size(240, 240),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              // Button(
              //   onTap: _toggleLight,
              //   text: _isLightOn ? 'Turn Off' : 'Turn On',
              //   width: size.width * 0.7,
              // ),
              Text(
                "Schedule",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: size.width * eighteen,
                    fontWeight: FontWeight.bold,
                    color: white),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "From",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: size.width * fourteen,
                            fontWeight: FontWeight.bold,
                            color: white.withOpacity(0.7)),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Container(
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: white),
                          gradient: LinearGradient(
                            colors: [secondary, primary],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            _selectTime(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (selectedTime != null && selectedTime != '')
                                    ? Text(
                                        selectedTime.format(context),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: white,
                                            fontSize: size.width * sixteen),
                                      )
                                    : Text(
                                        TimeOfDay(hour: 18, minute: 00)
                                            .format(context),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: white,
                                            fontSize: size.width * sixteen),
                                      ),
                                Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Icon(
                                      Icons.watch_later_outlined,
                                      color: white,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "To",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: size.width * fourteen,
                            fontWeight: FontWeight.bold,
                            color: white.withOpacity(0.7)),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Container(
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: white),
                          gradient: LinearGradient(
                            colors: [secondary, primary],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            _selectTimeTo(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (selectedTimeTo != null && selectedTimeTo != '')
                                    ? Text(
                                        selectedTimeTo.format(context),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: white,
                                            fontSize: size.width * sixteen),
                                      )
                                    : Text(
                                        TimeOfDay(hour: 22, minute: 0)
                                            .format(context),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: white,
                                            fontSize: size.width * sixteen),
                                      ),
                                Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Icon(
                                      Icons.watch_later_outlined,
                                      color: white,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
