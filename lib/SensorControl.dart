// import 'package:flutter/material.dart';
//
// class SensorControlPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sensor Control'),
//       ),
//       body: Center(
//         child: Text('This is the Sensor Control Page'),
//       ),
//     );
//   }
// }
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:home_automation_system/services/firebase_cloud_messiging_service.dart';
import 'package:home_automation_system/services/notification_services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'NotificationCount.dart';
import 'apptheme.dart';
import 'main.dart';

class SensorControl extends StatefulWidget {
  const SensorControl({Key? key}) : super(key: key);

  @override
  State<SensorControl> createState() => _SensorControlState();
}

class _SensorControlState extends State<SensorControl> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late DatabaseReference _databaseReference;
  double humidity = 0.0;
  double temperature = 0.0;
  int gas = 0;
  int flame = 0;
  double soil = 0.0;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.reference();
    _listenToSensorValues();
    _configureFirebaseMessaging();
  }

  void _listenToSensorValues() {
    _databaseReference
        .child('SensorData')
        .child('humidity')
        .onValue
        .listen((event) {
      final humidityValue = event.snapshot.value as double?;
      if (humidityValue != null) {
        setState(() {
          humidity = humidityValue / 100.0;
        });
        print('Humidity: $humidity');
      }
    });

    _databaseReference
        .child('SensorData')
        .child('temperature')
        .onValue
        .listen((event) {
      final temperatureValue = event.snapshot.value as double?;
      if (temperatureValue != null) {
        setState(() {
          temperature = temperatureValue / 100.0;
        });
      }
    });

    _databaseReference
        .child('SensorData')
        .child('gasSensor')
        .onValue
        .listen((event) {
      final gasValue = event.snapshot.value as int?;
      if (gasValue != null) {
        setState(() {
          // gas = ((gasValue - 100) / (300 - 100)) * 100.0;
          gas = gasValue;
        });
        print('GasValue: $gas');
        if (gas >= 500) {
          // Send push notification
          _sendPushNotification("gas");
        }
      }
    });

    _databaseReference
        .child('SensorData')
        .child('flameSensor')
        .onValue
        .listen((event) {
      final flameValue = event.snapshot.value as int?;
      if (flameValue != null) {
        setState(() {
          flame = flameValue;
        });
        print("FlameValue: $flame");
        if (flame == 0) {
          // Send push notification
          _sendPushNotification("flame");
        }
      }
    });

    _databaseReference
        .child('SensorData')
        .child('soilMoisture')
        .onValue
        .listen((event) {
      final moistureValue = event.snapshot.value as double?;
      if (moistureValue != null) {
        setState(() {
          soil = moistureValue / 100.0;
        });
      }
    });
  }

  void _configureFirebaseMessaging() {
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
      // Send this token to your server to associate it with the device
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground notification messages here
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }

      NotificationService.displayFcm(
          notification: message.notification!, buildContext: context);
      // print('Foreground Notification Received: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification messages opened from the app UI or when the app is in the background
      print('Notification Opened: ${message.notification?.title}');
      NotificationService.displayFcm(
          notification: message.notification!, buildContext: context);
    });
  }

  Future<void> _sendPushNotification(String alertType) async {
    String? token = await _firebaseMessaging.getToken();
    String title = '';
    String body = '';

    if (alertType == 'gas') {
      title = 'Gas Alert';
      body = 'Gas value is 0';
    } else if (alertType == 'flame') {
      title = 'Flame Alert';
      body = 'Flame value is 0';
    }

    await FCMService.sendPushMessage(
      token,
      {},
      {
        'title': title,
        'body': body,
      },
    );

    final notificationCount =
        Provider.of<NotificationCount>(context, listen: false);
    // Update the notification count
    notificationCount.updateCount(notificationCount.count + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              'SENSORS CONTROL',
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
                      builder: (context) =>
                          MyHomePage(title: "HOME AUTOMATION")),
                );
              },
            )),
        body: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Flame and Gas Alert",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Color(0xFF7a6bbc),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  flame == 0 ? Colors.red : Colors.green,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.fireplace_outlined,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Flame $flame',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  gas >= 600 ? Colors.red : Colors.green,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.gas_meter_outlined,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Gas $gas',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Temperature and Humidity",
                style: TextStyle(
                    color: Color(0xFF7a6bbc),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 6, bottom: 6),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    IndicatorItem(
                      icon: Icons.thermostat_outlined,
                      iconColor: Colors.deepPurple.shade100,
                      title: 'Temperature',
                      percent: temperature,
                      progressColor: Colors.deepPurple,
                      backgroundColor: Colors.deepPurple.shade100,
                      radius: 50,
                      lineWidth: 10,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text("${temperature.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 30)),
                    ),
                    IndicatorItem(
                      icon: Icons.water_drop_outlined,
                      iconColor: Colors.green.shade100,
                      title: 'Humidity',
                      percent: humidity,
                      progressColor: Colors.green,
                      backgroundColor: Colors.green.shade100,
                      radius: 50,
                      lineWidth: 10,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text("${humidity.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 30)),
                    ),
                    // IndicatorItem(
                    //   icon: Icons.gas_meter_outlined,
                    //   iconColor: Colors.blue.shade100,
                    //   title: 'Soil Moisture ',
                    //   percent: soil,
                    //   progressColor: Colors.blue,
                    //   backgroundColor: Colors.blue.shade100,
                    //   radius: 50,
                    //   lineWidth: 10,
                    //   circularStrokeCap: CircularStrokeCap.round,
                    //   center: Text("${soil.toStringAsFixed(2)}",
                    //       style: TextStyle(fontSize: 30)),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class IndicatorItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final double percent;
  final Color progressColor;
  final Color backgroundColor;
  final double radius;
  final double lineWidth;
  final CircularStrokeCap circularStrokeCap;
  final Widget center;
  final Color iconColor;

  IndicatorItem({
    required this.icon,
    required this.title,
    required this.percent,
    required this.progressColor,
    required this.backgroundColor,
    required this.radius,
    required this.lineWidth,
    required this.circularStrokeCap,
    required this.center,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 3.0),
            CircularPercentIndicator(
              radius: radius,
              lineWidth: lineWidth,
              percent: percent,
              progressColor: progressColor,
              backgroundColor: backgroundColor,
              circularStrokeCap: circularStrokeCap,
              center: center,
            ),
            ListTile(
              minLeadingWidth: 2,
              leading: Icon(
                icon,
                color: iconColor,
              ),
              title: Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
