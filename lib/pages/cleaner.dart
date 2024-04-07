import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smarthome/mqtt.dart';
import '../Constant/style.dart';

class Cleaner extends StatefulWidget {
  final MqttService mqttService;
  Cleaner({required this.mqttService});

  @override
  _CleanerState createState() => _CleanerState();
}

class _CleanerState extends State<Cleaner> {
  @override
  void initState() {
    super.initState();
    print("cleaner init");
    widget.mqttService.connectToMqttServer();
    // widget.mqttService.subscribeToMachineStatus();
    // widget.mqttService.machineStatus.listen((status) {
    //   print("dstata" + status.toString());
    //   setState(() {
    //     isSwitched = status;
    //   });
    // });
  }

  List<dynamic> _selectedDays = [];
  List<dynamic> _selectedTime = [];

  final List<dynamic> _daysOfWeek = [
    'S',
    'M',
    'T',
    'W',
    'Th',
    'F',
    'Sat',
  ];

  TimeOfDay selectedTime = TimeOfDay.now();
  bool isSwitched = false;
  Future<void> _selectTime(BuildContext context) async {
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

  pop() {
    Navigator.pop(context, true);
  }

  void _toggleDaySelection(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Home Cleaner",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: size.width * twenty,
                        fontWeight: FontWeight.w600,
                        color: white,
                      ),
                    ),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          widget.mqttService.publishMessage(
                              'cleaner/machine', isSwitched ? 'on' : 'off');
                        });
                      },
                      activeTrackColor: white.withOpacity(0.7),
                      activeColor: primary,
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.01),
              Image.asset(
                "assets/images/cleaner.jpg",
                width: MediaQuery.of(context).size.width,
                height: size.height * 0.28,
                fit: BoxFit.cover,
              ),
              SizedBox(height: size.height * 0.03),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                          colors: [primary.withOpacity(0.7), primary]),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Stack(
                      children: [
                        Container(
                          width: size.width * 0.24,
                          height: size.height * 0.14,
                          decoration: BoxDecoration(
                            border: Border.all(color: white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: white,
                                size: size.width * twentyfour,
                              ),
                              Text(
                                "Bedroom",
                                style: TextStyle(
                                  fontSize: size.width * fourteen,
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Location",
                                style: TextStyle(
                                  fontSize: size.width * twelve,
                                  color: white.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                            ],
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
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                          colors: [primary.withOpacity(0.7), primary]),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Stack(
                      children: [
                        Container(
                          width: size.width * 0.24,
                          height: size.height * 0.14,
                          decoration: BoxDecoration(
                            border: Border.all(color: white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.charging_station,
                                color: white,
                                size: size.width * twentyfour,
                              ),
                              Text(
                                "83%",
                                style: TextStyle(
                                  fontSize: size.width * fourteen,
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Power",
                                style: TextStyle(
                                  fontSize: size.width * twelve,
                                  color: white.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                            ],
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
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                          colors: [primary.withOpacity(0.7), primary]),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Stack(
                      children: [
                        Container(
                          width: size.width * 0.24,
                          height: size.height * 0.14,
                          decoration: BoxDecoration(
                            border: Border.all(color: white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.delete,
                                color: white,
                                size: size.width * twentyfour,
                              ),
                              Text(
                                "20%",
                                style: TextStyle(
                                  fontSize: size.width * fourteen,
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Bin",
                                style: TextStyle(
                                  fontSize: size.width * twelve,
                                  color: white.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                            ],
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
                  ),
                ],
              ),

//form
              SizedBox(
                height: size.height * 0.03,
              ),
              Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: white),
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                      colors: [secondary, primary],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: black.withOpacity(0.01),
                          spreadRadius: 20,
                          blurRadius: 10,
                          offset: Offset(0, 10))
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Specific days In week",
                            style: TextStyle(
                                textBaseline: TextBaseline.alphabetic,
                                fontFamily: 'Montserrat',
                                fontSize: size.width * fourteen,
                                fontWeight: FontWeight.bold,
                                color: white),
                          ),
                          Expanded(
                            child: Container(
                              width: 2,
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: CheckboxListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) =>
                                      BorderSide(width: 1.0, color: white),
                                ),
                                activeColor: white,
                                checkColor: primary,
                                value:
                                    _selectedDays.length == _daysOfWeek.length,
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      _selectedDays = List.from(_daysOfWeek);
                                    } else {
                                      _selectedDays.clear();
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (String day in _daysOfWeek)
                            GestureDetector(
                              onTap: () {
                                _toggleDaySelection(day);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: _selectedDays.contains(day)
                                            ? [
                                                white.withOpacity(0.8),
                                                white.withOpacity(0.4),
                                              ]
                                            : [
                                                primary.withOpacity(0.4),
                                                white.withOpacity(0.01)
                                              ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color: black.withOpacity(0.01),
                                            spreadRadius: 20,
                                            blurRadius: 10,
                                            offset: Offset(0, 10))
                                      ],
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Text(
                                      day,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: size.width * fourteen,
                                          fontWeight: FontWeight.bold,
                                          color: white),
                                    ),
                                  )),
                            ),
                        ],
                      ),
                    ],
                  )),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text(
                "time".toUpperCase(),
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: size.width * fourteen,
                    fontWeight: FontWeight.bold,
                    color: white),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: white),
                  gradient: LinearGradient(
                    colors: [secondary, primary],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
                // color: primary,
                // padding: EdgeInsets.only(top: media.height * 0.04),
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
                                TimeOfDay.now().format(context),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: white,
                                    fontSize: size.width * sixteen),
                              ),
                        Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Icon(
                              Icons.watch_later_outlined,
                              color: white,
                            )),
                      ],
                    ),
                  ),
                ),
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
