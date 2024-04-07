import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';

import '../Constant/style.dart';

class WeatherDetailItem extends StatelessWidget {
  final String title;
  final String value;

  const WeatherDetailItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: size.width * fourteen,
            color: white,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: size.width * twelve,
            color: white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class Button extends StatefulWidget {
  dynamic onTap;
  final String text;
  dynamic color;
  dynamic borcolor;
  dynamic textcolor;
  dynamic width;
  dynamic height;
  dynamic grad1;
  dynamic grad2;
  dynamic fontsize;
  dynamic icon;

  Button({
    required this.onTap,
    required this.text,
    this.color,
    this.borcolor,
    this.textcolor,
    this.width,
    this.height,
    this.grad1,
    this.grad2,
    this.fontsize,
    this.icon,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: widget.height ?? media.width * 0.12,
        width: (widget.width != null) ? widget.width : null,
        padding: EdgeInsets.only(
            left: media.width * twenty, right: media.width * twenty),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // color: (widget.color != null) ? widget.color : buttonColor,
            gradient: LinearGradient(colors: [
              (widget.grad1 != null ? widget.grad1 : primary),
              (widget.grad2 != null ? widget.grad2 : secondary)
            ]),
            border: Border.all(
              color: (widget.borcolor != null) ? widget.borcolor : white,
              width: 1,
            )),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            widget.text,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: (widget.fontsize != null)
                    ? widget.fontsize
                    : media.width * sixteen,
                color: (widget.textcolor != null) ? widget.textcolor : white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1),
          ),
        ),
      ),
    );
  }
}

//input field style

// ignore: must_be_immutable
class InputField extends StatefulWidget {
  dynamic icon;
  dynamic onTap;
  final String text;
  final TextEditingController textController;
  dynamic inputType;
  dynamic maxLength;
  dynamic color;

  // ignore: use_key_in_widget_constructors
  InputField(
      {this.icon,
      this.onTap,
      required this.text,
      required this.textController,
      this.inputType,
      this.maxLength,
      this.color});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return TextFormField(
      maxLength: (widget.maxLength == null) ? null : widget.maxLength,
      keyboardType: (widget.inputType == null)
          ? TextInputType.emailAddress
          : widget.inputType,
      controller: widget.textController,
      decoration: InputDecoration(
          counterText: '',
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: inputfocusedUnderline,
            width: 1.2,
            style: BorderStyle.solid,
          )),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: (widget.color == null) ? inputUnderline : widget.color,
            width: 1.2,
            style: BorderStyle.solid,
          )),
          prefixIcon: (widget.icon != null)
              ? Icon(
                  widget.icon,
                  size: media.width * 0.064,
                  color: textColor,
                )
              : null,
          hintText: widget.text,
          hintStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: media.width * sixteen,
            color: hintColor,
          )),
      onChanged: widget.onTap,
    );
  }
}

//text field style

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  dynamic icon;
  dynamic onTap;
  dynamic onSubmitted;
  dynamic focusNode;
  final String text;
  final TextEditingController textController;
  dynamic inputType;
  dynamic maxLength;
  dynamic color;
  dynamic suffix;

  // ignore: use_key_in_widget_constructors
  CustomTextField(
      {this.icon,
      this.onTap,
      this.focusNode,
      this.onSubmitted,
      required this.text,
      required this.textController,
      this.inputType,
      this.maxLength,
      this.suffix,
      this.color});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return TextField(
      focusNode: widget.focusNode,
      onSubmitted: widget.onSubmitted,
      controller: widget.textController,
      onChanged: widget.onTap,
      keyboardType: (widget.inputType == null)
          ? TextInputType.emailAddress
          : widget.inputType,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: thirdColor, width: 2.0),
            borderRadius: BorderRadius.circular(12),
            gapPadding: 1,
          ),
          labelText: widget.text,
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              color: primary,
              fontSize: media.width * fourteen),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: (widget.color != null) ? widget.color : primary,
                width: 1.5),
            borderRadius: BorderRadius.circular(12),
            gapPadding: 1,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: -5),
          suffixIcon: Container(
            width: media.width * eight,
            alignment: Alignment.topLeft,
            child: Align(
              alignment: Alignment.topLeft,
              widthFactor: 0.0,
              heightFactor: 1.0,
              child: Text(
                widget.suffix ?? '',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: fourthColor.withRed(400),
                    fontSize: media.width * fourteen),
              ),
            ),
          ),
          // prefixIcon: (widget.icon != null)
          //     ? Icon(
          //         widget.icon,
          //         size: media.width * 0.064,
          //         color: fourthColor.withRed(400),
          //       )
          //     : null,
          // suffixIcon: (widget.icon != null)
          //     ? Icon(
          //   widget.icon,
          //   size: media.width * 0.044,
          //   color: fourthColor.withRed(400),
          // )
          //     : null,
          suffixStyle: TextStyle(
              fontFamily: 'Montserrat',
              color: fourthColor.withRed(400),
              fontSize: media.width * twentyfour),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), gapPadding: 1),
          isDense: true),
    );
  }
}

Widget noDataWidget(BuildContext? context) {
  var media = MediaQuery.of(context!).size;

  return Center(
      child: Text(
    "No Data Found",
    style: TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
      color: fourthColor.withRed(400),
      fontSize: media.width * sixteen,
    ),
    textAlign: TextAlign.center,
  ));
}

Widget noDataGIFWidget(BuildContext? context) {
  var media = MediaQuery.of(context!).size;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: media.width * 0.05,
      ),
      Container(
        height: media.width * 0.7,
        width: media.width * 0.7,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/nodatafound.gif'),
                fit: BoxFit.contain)),
      ),
      SizedBox(
        height: media.width * 0.02,
      ),
      SizedBox(
          width: media.width * 0.9,
          child: Text(
            "No Data Found",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              color: textColor.withRed(400),
              fontSize: media.width * sixteen,
            ),
            textAlign: TextAlign.center,
          ))
    ],
  );
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: primary,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16,
      toastLength: Toast.LENGTH_LONG);
}

class DialogExample extends StatelessWidget {
  dynamic onTap;
  final String title;
  dynamic content;
  dynamic textController;
  dynamic inputType;
  dynamic maxLength;
  dynamic color;

  DialogExample(
      {this.onTap,
      required this.title,
      this.content,
      required this.textController,
      this.inputType,
      this.maxLength,
      this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}
