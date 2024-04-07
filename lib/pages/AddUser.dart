import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/Constant/style.dart';
import 'package:smarthome/Widget/widgets.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _emergencyController = TextEditingController();
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveFormData() async {
    // Get SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save form data
    prefs.setString('uname', _nameController.text);
    prefs.setString('uemail', _emailController.text);
    prefs.setString('urelation', _relationController.text);
    prefs.setString('uemergencyContact', _emergencyController.text);

    if (_image != null) {
      prefs.setString('uimagePath', _image!.path);
    }
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User data saved successfully'),
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
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.width * 0.10),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: size.width * 0.05),
                      width: size.width * 1,
                      alignment: Alignment.center,
                      child: Text(
                        "Add User",
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
                  padding: const EdgeInsets.all(0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (_image != null) ...[
                          SizedBox(
                            height: 200,
                            child: Image.file(_image!),
                          ),
                          SizedBox(height: 10),
                        ],
                        Button(
                          onTap: () => _pickImage(ImageSource.gallery),
                          text: 'Pick Image from Gallery',
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Button(
                          onTap: () => _pickImage(ImageSource.camera),
                          text: 'Take Picture',
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: size.width * fourteen,
                            color: white,
                          ),
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: size.width * fourteen,
                              color: white,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: size.width * fourteen,
                            color: white,
                          ),
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: size.width * fourteen,
                              color: white,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: size.width * fourteen,
                            color: white,
                          ),
                          controller: _relationController,
                          decoration: InputDecoration(
                            labelText: 'Relation',
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: size.width * fourteen,
                              color: white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: size.width * fourteen,
                            color: white,
                          ),
                          controller: _emergencyController,
                          decoration: InputDecoration(
                            labelText: 'Emergency Contact Number',
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: size.width * fourteen,
                              color: white,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Button(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              _saveFormData();
                            }
                          },
                          text: 'Submit',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
