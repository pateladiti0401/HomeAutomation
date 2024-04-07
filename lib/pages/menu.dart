import 'package:flutter/material.dart';
import 'package:smarthome/mqtt.dart';
import 'package:smarthome/pages/Camera.dart';
import 'package:smarthome/pages/Roomdetail.dart';
import 'package:smarthome/pages/irrigation.dart';
import 'package:smarthome/pages/users.dart';

import '../Constant/style.dart';
import 'agent3d.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final List<MenuEntry> menuEntries = [
    MenuEntry(name: 'Camera', page: CameraPage()),
    MenuEntry(name: 'Irrigation', page: IrrigationPage()),
    MenuEntry(
        name: 'Rooms',
        page: RoomDetailPage(
          room: {'text': 'Kitchen', 'image': 'assets/images/kitchen.png'},
        )),
    MenuEntry(name: 'Users', page: User()),
    // MenuEntry(name: 'Agent', page: AgentPage()),
  ];

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
                    "Menu",
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
            Expanded(
              child: ListView.builder(
                itemCount: menuEntries.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => menuEntries[index].page),
                      );
                    },
                    child: MenuItem(name: menuEntries[index].name),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuEntry {
  final String name;
  final Widget page;

  MenuEntry({required this.name, required this.page});
}

class MenuItem extends StatelessWidget {
  final String name;

  MenuItem({required this.name});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: primary,
        border: Border.all(
          color: white,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: size.width * fourteen,
            color: white,
          ),
        ),
      ),
    );
  }
}

class MusicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Page'),
      ),
      body: Center(
        child: Text('Music Page Content'),
      ),
    );
  }
}
