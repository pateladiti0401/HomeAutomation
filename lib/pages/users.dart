import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome/Widget/widgets.dart';
import 'package:smarthome/pages/AddUser.dart';

import '../Constant/style.dart';

class User1 {
  final String name;
  final String imagePath;

  User1({
    required this.name,
    required this.imagePath,
  });
}

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  final List<String> menuItems = [
    'Aditi Patel',
    'Farhat Elma',
    'Dhruv Maradiya',
    'Haseeb Shams',
    'Khalid Bagwan',
  ];
  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the page initializes
  }

// Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      List<dynamic> userDataList = jsonDecode(userDataString);
      setState(() {
        menuItems.clear();
        for (var userData in userDataList) {
          menuItems.add(User1(
            name: userData['uname'],
            imagePath: userData['uimagePath'],
          ) as String);
        }
      });
    }
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
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: size.width * 0.05),
                  width: size.width,
                  alignment: Alignment.center,
                  child: Text(
                    "Users",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: size.width * twenty,
                      fontWeight: FontWeight.w600,
                      color: white,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: size.width * 0.05,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_rounded),
                    color: white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: menuItems.length,
            //     itemBuilder: (context, index) {
            //       return MenuItem(
            //         name: menuItems[index],
            //         onRemove: () {
            //           setState(() {
            //             menuItems.removeAt(index);
            //           });
            //         },
            //       );
            //     },
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  User1 user = User1(
                    name: menuItems[index],
                    imagePath: 'assets/images/logo.png',
                  );
                  return UserItem(
                    user: user,
                  );
                },
              ),
            ),

            SizedBox(
              height: size.height * 0.03,
            ),
            Button(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddUserPage()),
                );
              },
              text: 'Add User',
            ),
          ],
        ),
      ),
    );
  }
}

class UserItem extends StatelessWidget {
  final User1 user;

  UserItem({required this.user});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: white),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: size.width * 0.08,
            backgroundImage: AssetImage(user.imagePath),
          ),
          SizedBox(width: 10),
          Text(
            user.name,
            style: TextStyle(
              color: white,
              fontFamily: 'Montserrat',
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String name;

  final VoidCallback onRemove;
  MenuItem({required this.name, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: primary,
            border: Border.all(
              color: white,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: size.width * 0.04,
                color: white,
              ),
            ),
            Button(
              onTap: onRemove,
              text: 'Remove',
              height: size.height * 0.03,
            ),
          ])),
    );
  }
}
