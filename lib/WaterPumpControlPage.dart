import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'apptheme.dart';
import 'main.dart';

class WaterPumpControlPage extends StatefulWidget {
  @override
  State<WaterPumpControlPage> createState() => _WaterPumpControlPageState();
}

class _WaterPumpControlPageState extends State<WaterPumpControlPage> {
  bool waterPumpOn = false;
  String waterPump = 'OFF';

  void sendWaterPumpStatusToFirebase(String status) {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('WaterPumpControl')
        .child('WaterPumpStatus');
    try {
      databaseReference.set(status);
      print("success");
    } catch (error) {
      print('Error sending water pump status to Firebase: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Water Pump Control',
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
                  "assets/water_pump_black.jpg",
                  height: 150.0,
                  width: 100.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 18.0),
                Text(
                  "Water Pump",
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
                WaterPumpControlCard(
                  pumpName: "Water Pump",
                  pumpIcon: FontAwesomeIcons.tint,
                  pumpStatus: waterPumpOn,
                  onTap: () {
                    setState(() {
                      waterPumpOn = !waterPumpOn;
                    });
                    waterPump = waterPumpOn ? 'ON' : 'OFF';
                    sendWaterPumpStatusToFirebase(waterPump);
                    print(waterPump);
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

class WaterPumpControlCard extends StatelessWidget {
  final String pumpName;
  final IconData pumpIcon;
  final bool pumpStatus;
  final VoidCallback onTap;

  const WaterPumpControlCard({
    required this.pumpName,
    required this.pumpIcon,
    required this.pumpStatus,
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
                pumpIcon,
                size: 60.0,
                color: pumpStatus ? Colors.blueAccent : Colors.grey[400],
              ),
              SizedBox(height: 8.0),
              Text(
                pumpName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: pumpStatus ? Colors.blueAccent : Colors.white,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                pumpStatus ? 'ON' : 'OFF',
                style: TextStyle(
                  fontSize: 15,
                  color: pumpStatus ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
