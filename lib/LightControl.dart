import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:home_automation_system/main.dart';
import 'apptheme.dart';

import 'package:flutter/material.dart';
import 'package:home_automation_system/main.dart';

import 'apptheme.dart';

class LightControlPage extends StatefulWidget {
  @override
  State<LightControlPage> createState() => _LightControlPageState();
}

class _LightControlPageState extends State<LightControlPage> {
  bool kitchenLightOn = false;
  bool bedroomLightOn = false;
  bool meetingLightOn = false;
  String kitchenLight = 'OFF';
  String bedroomLight = 'OFF';
  String meetingLight = 'OFF';

  void sendKitchenLightStatusToFirebase(String status) {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('LightControl')
        .child('KitchenLightStatus');
    databaseReference.set(status);
  }

  void sendMeetingLightSatusToFirebase(String status) {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('LightControl')
        .child('MeetingLightStatus');
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
          'Light Control',
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
                  "assets/lights.jpeg",
                  height: 150.0,
                  width: 100.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 18.0),
                Text(
                  "Lights",
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
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                LightControlCard(
                  lightName: "Kitchen Light",
                  lightIcon: Icons.lightbulb_sharp,
                  lightStatus: kitchenLightOn,
                  onTap: () {
                    setState(() {
                      kitchenLightOn = !kitchenLightOn;
                    });

                    kitchenLight = kitchenLightOn ? 'ON' : 'OFF';
                    sendKitchenLightStatusToFirebase(kitchenLight);
                  },
                ),
                LightControlCard(
                  lightName: "Meeting Light",
                  lightIcon: Icons.lightbulb_sharp,
                  lightStatus: meetingLightOn,
                  onTap: () {
                    setState(() {
                      meetingLightOn = !meetingLightOn;
                    });
                    meetingLight = meetingLightOn ? 'ON' : 'OFF';
                    sendMeetingLightSatusToFirebase(meetingLight);
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

class LightControlCard extends StatelessWidget {
  final String lightName;
  final IconData lightIcon;
  final bool lightStatus;
  final VoidCallback onTap;

  const LightControlCard({
    required this.lightName,
    required this.lightIcon,
    required this.lightStatus,
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
              Icon(
                lightIcon,
                size: 60.0,
                color: lightStatus ? Colors.amber : Colors.grey[400],
              ),
              SizedBox(height: 10.0),
              Text(
                lightName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: lightStatus ? Colors.yellow : Colors.white,
                ),
              ),
              SizedBox(height: 6.0),
              Text(
                lightStatus ? 'ON' : 'OFF',
                style: TextStyle(
                  fontSize: 15,
                  color: lightStatus ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
