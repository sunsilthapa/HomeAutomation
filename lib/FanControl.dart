import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'apptheme.dart';
import 'main.dart';

class FanControlPage extends StatefulWidget {
  @override
  State<FanControlPage> createState() => _FanControlPageState();
}

class _FanControlPageState extends State<FanControlPage> {
  bool kitchenFanOn = false;
  String kitchenFan = 'OFF';

  void sendKitchenFanStatusToFirebase(String status) {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('FanControl')
        .child('FanStatus');
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
          'Fan Control',
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
                  "assets/fan_black.jpg",
                  height: 150.0,
                  width: 100.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 18.0),
                Text(
                  "Fans",
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
                FanControlCard(
                  fanName: "Kitchen Fan",
                  fanIcon:
                      FontAwesomeIcons.fan, // Replace with appropriate fan icon
                  fanStatus: kitchenFanOn,
                  onTap: () {
                    setState(() {
                      kitchenFanOn = !kitchenFanOn;
                    });

                    kitchenFan = kitchenFanOn ? 'ON' : 'OFF';
                    sendKitchenFanStatusToFirebase(kitchenFan);
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

class FanControlCard extends StatelessWidget {
  final String fanName;
  final IconData fanIcon;
  final bool fanStatus;
  final VoidCallback onTap;

  const FanControlCard({
    required this.fanName,
    required this.fanIcon,
    required this.fanStatus,
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
                fanIcon,
                size: 60.0,
                color: fanStatus ? Colors.amber : Colors.grey[400],
              ),
              SizedBox(height: 8.0),
              Text(
                fanName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: fanStatus ? Colors.yellow : Colors.white,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                fanStatus ? 'ON' : 'OFF',
                style: TextStyle(
                  fontSize: 15,
                  color: fanStatus ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
