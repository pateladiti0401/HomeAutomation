import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/Widget/widgets.dart';

import '../Constant/style.dart';

class AddDeviceForm extends StatefulWidget {
  @override
  _AddDeviceFormState createState() => _AddDeviceFormState();
}

class _AddDeviceFormState extends State<AddDeviceForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _deviceTypeController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  Future<void> _saveFormData() async {
    // Get SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save form data
    prefs.setString('deviceName', _deviceNameController.text);
    prefs.setString('deviceType', _deviceTypeController.text);
    prefs.setString('room', _roomController.text);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Device added successfully'),
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
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
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: size.width * 0.05),
                    width: size.width * 1,
                    alignment: Alignment.center,
                    child: Text(
                      "Add Device",
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
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: size.width * fourteen,
                          color: white,
                        ),
                        controller: _deviceNameController,
                        decoration: InputDecoration(
                          labelText: 'Device Name',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: size.width * fourteen,
                            color: white,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the device name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: size.width * fourteen,
                          color: white,
                        ),
                        controller: _deviceTypeController,
                        decoration: InputDecoration(
                          labelText: 'Device Type',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: size.width * fourteen,
                            color: white,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the device type';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: size.width * fourteen,
                          color: white,
                        ),
                        controller: _roomController,
                        decoration: InputDecoration(
                          labelText: 'Room',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: size.width * fourteen,
                            color: white,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the room';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Button(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // Form is valid, add device logic here
                            // For demonstration purposes, print device details
                            print('Device Name: ${_deviceNameController.text}');
                            print('Device Type: ${_deviceTypeController.text}');
                            print('Room: ${_roomController.text}');

                            // Save form data to SharedPreferences
                            _saveFormData();

                            // Clear text field controllers
                            _deviceNameController.clear();
                            _deviceTypeController.clear();
                            _roomController.clear();
                          }
                        },
                        // onTap: () {
                        //   if (_formKey.currentState!.validate()) {
                        //     // Form is valid, add device logic here
                        //     // For demonstration purposes, print device details
                        //     print('Device Name: ${_deviceNameController.text}');
                        //     print('Device Type: ${_deviceTypeController.text}');
                        //     print('Room: ${_roomController.text}');
                        //     // Clear text field controllers
                        //     _deviceNameController.clear();
                        //     _deviceTypeController.clear();
                        //     _roomController.clear();
                        //   }
                        // },
                        text: 'Add Device',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    _deviceNameController.dispose();
    _deviceTypeController.dispose();
    _roomController.dispose();
    super.dispose();
  }
}
