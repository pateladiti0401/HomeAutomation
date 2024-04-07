import 'package:flutter/material.dart';

import '../Constant/style.dart';
import '../Widget/widgets.dart';

class RoomForm extends StatefulWidget {
  @override
  _RoomFormState createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {
  String _roomName = '';
  List<String> _selectedDevices = [];
  List<String> _availableDevices = [
    'Light',
    'Fan',
    'Air Conditioner',
    'Speaker',
    'Security Camera',
  ];

  void _addRoom() {
    // Add functionality to save room details to database or perform other actions
    print('Room Name: $_roomName');
    print('Selected Devices: $_selectedDevices');
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
    // Example: Save room details to database
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
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: size.width * 0.05),
                    width: size.width * 1,
                    alignment: Alignment.center,
                    child: Text(
                      "Add Room",
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextField(
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: size.width * fourteen,
                        color: white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Room Name',
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: size.width * fourteen,
                          color: white,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _roomName = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Select Devices:',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: size.width * sixteen,
                        color: white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      verticalDirection: VerticalDirection.down,
                      spacing: 13,
                      children: _availableDevices
                          .map(
                            (device) => FilterChip(
                              selectedColor: primary.withOpacity(0.4),
                              label: Text(device),
                              selected: _selectedDevices.contains(device),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedDevices.add(device);
                                  } else {
                                    _selectedDevices.remove(device);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: size.height * 0.52),
                    Button(
                      onTap: () {
                        _addRoom();
                      },
                      text: 'Add Room',
                      width: size.width * 0.7,
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
