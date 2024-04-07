import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../Constant/style.dart';

class CameraPage extends StatelessWidget {
  final List<String> imageUrls = [
    'assets/images/front_cam.jpg',
    'assets/images/living_cam.jpg',
    'assets/images/living_room.png'
  ];
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
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: size.width * 0.05),
                    width: size.width * 1,
                    alignment: Alignment.center,
                    child: Text(
                      "Cameras",
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
              SizedBox(
                height: size.height * 0.03,
              ),
              Column(
                children: [
                  Image.asset(
                    "assets/images/living_room.png",
                    width: MediaQuery.of(context).size.width,
                    height: size.height * 0.35,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    "Living Room",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: size.width * fourteen,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Text(
                "Devices",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: size.width * sixteen,
                    fontWeight: FontWeight.bold,
                    color: white),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 16 / 9, // Full width
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                ),
                items: imageUrls.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 0.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
