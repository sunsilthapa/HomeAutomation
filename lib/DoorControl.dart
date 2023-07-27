import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'apptheme.dart';
import 'main.dart';

class DoorControlPage extends StatefulWidget {
  @override
  State<DoorControlPage> createState() => _DoorControlPageState();
}

class _DoorControlPageState extends State<DoorControlPage> {
  bool frontDoorOpen = false;
  String frontDoorStatus = 'CLOSED';

  void sendFrontDoorStatusToFirebase(String status) {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('DoorControl')
        .child('DoorStatus');
    databaseReference.set(status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Door Control',
          style: AppTheme.myGlobalTextStyle,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF7a6bbc),
          ),
          tooltip: 'Home',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(title: "HOME AUTOMATION"),
              ),
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 100.0,
            height: 200.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/door.jpg",
                  height: 150.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 18.0),
                Text(
                  "Doors",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF7a6bbc),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                DoorControlCard(
                  doorName: "Front Door",
                  doorIcon: FontAwesomeIcons
                      .doorOpen, // Replace with appropriate door icon
                  doorStatus: frontDoorOpen,
                  onTap: () {
                    setState(() {
                      frontDoorOpen = !frontDoorOpen;
                    });

                    frontDoorStatus = frontDoorOpen ? 'OPEN' : 'CLOSED';
                    sendFrontDoorStatusToFirebase(frontDoorStatus);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DoorControlCard extends StatelessWidget {
  final String doorName;
  final IconData doorIcon;
  final bool doorStatus;
  final VoidCallback onTap;

  const DoorControlCard({
    required this.doorName,
    required this.doorIcon,
    required this.doorStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 200.0,
      child: Card(
        color: Color(0xFF7a6bbc),
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                doorIcon,
                size: 60.0,
                color: doorStatus ? Colors.amber : Colors.grey[400],
              ),
              SizedBox(height: 8.0),
              Text(
                doorName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: doorStatus ? Colors.yellow : Colors.white,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                doorStatus ? 'OPEN' : 'CLOSED',
                style: TextStyle(
                  fontSize: 15,
                  color: doorStatus ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
