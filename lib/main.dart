import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:home_automation_system/services/notification_services.dart';
import 'package:provider/provider.dart';
import 'DoorControl.dart';
import 'FanControl.dart';
import 'LightControl.dart';
import 'NotificationCount.dart';
import 'SensorControl.dart';
import 'WaterPumpControlPage.dart';
import 'apptheme.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background notification messages here
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationCount(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(),
        home: const MyHomePage(title: 'HOME AUTOMATION'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> images = [
    "assets/carousel1.png",
    "assets/carousel2.png",
    "assets/carousel3.png",
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final notificationCount = Provider.of<NotificationCount>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.title,
            style: AppTheme.myGlobalTextStyle,
          ),
          actions: <Widget>[
            Badge(
              position: BadgePosition.topEnd(top: -1, end: 1),
              showBadge: true,
              ignorePointer: false,
              badgeStyle: BadgeStyle(
                shape: BadgeShape.circle,
                badgeColor: Colors.blue,
                padding: EdgeInsets.all(5),
              ),
              badgeContent: Text(
                notificationCount.count.toString(),
                style: TextStyle(color: Colors.white),
              ),
              badgeAnimation: BadgeAnimation.rotation(
                animationDuration: Duration(seconds: 1),
                colorChangeAnimationDuration: Duration(seconds: 1),
                loopAnimation: false,
                curve: Curves.fastOutSlowIn,
                colorChangeAnimationCurve: Curves.easeInCubic,
              ), // Replace '5' with your notification count
              child: IconButton(
                icon: const Icon(Icons.notifications_active,
                    color: Color(0xFF7a6bbc)),
                tooltip: 'Notifications',
                onPressed: () {},
              ),
            ), //IconButton
            //IconButton
          ],
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Color(0xFF7a6bbc),
            ),
            tooltip: 'Home',
            onPressed: () {},
          )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 150,
                    initialPage: 0,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.95,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 2),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: images.map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(image),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: images.asMap().entries.map((entry) {
                    int index = entry.key;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      child: Container(
                        width: 10,
                        height: 10,
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 10.0,
                          children: [
                            SizedBox(
                              width: 106.0,
                              height: 100.0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LightControlPage(),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Color(0xFF7a6bbc),
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/bulb.png',
                                            width: 40.0,
                                            height: 40.0,
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(
                                            "Lights",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 106.0,
                              height: 100.0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FanControlPage(),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Color(0xFF7a6bbc),
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/fan.png',
                                            width: 40.0,
                                            height: 40.0,
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(
                                            "Fan",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 106.0,
                              height: 100.0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SensorControl(),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Color(0xFF7a6bbc),
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/sensor1.png',
                                            width: 40.0,
                                            height: 40.0,
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(
                                            "Sensors",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   width: 106.0,
                            //   height: 100.0,
                            //   child: InkWell(
                            //     onTap: () {
                            //       Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (_) => DoorControlPage(),
                            //         ),
                            //       );
                            //     },
                            //     child: Card(
                            //       color: Color(0xFF7a6bbc),
                            //       elevation: 2.0,
                            //       shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(8.0)),
                            //       child: Center(
                            //         child: Padding(
                            //           padding: EdgeInsets.all(5.0),
                            //           child: Column(
                            //             children: [
                            //               Image.asset(
                            //                 'assets/door.png',
                            //                 width: 40.0,
                            //                 height: 40.0,
                            //               ),
                            //               SizedBox(
                            //                 height: 4.0,
                            //               ),
                            //               Text(
                            //                 "Doors",
                            //                 style: TextStyle(
                            //                     fontWeight: FontWeight.bold,
                            //                     fontSize: 14,
                            //                     color: Colors.white),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              width: 106.0,
                              height: 100.0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => WaterPumpControlPage(),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Color(0xFF7a6bbc),
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/water_pump.png',
                                            width: 40.0,
                                            height: 40.0,
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(
                                            "Water Pump",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two cards per row
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return _buildCard(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    // Placeholder data for the cards (You can replace this with your own data)
    List<String> images = [
      'assets/lights.jpeg',
      'assets/fan_black.jpg',
      'assets/thermometer.webp',
      'assets/flame_black.jpg',
      'assets/gas_black.jpg',
      'assets/1.jpg',
    ];
    List<String> headings = [
      'Lights',
      'Fans',
      'DHT22 Sensor',
      'Flame Sensor',
      'Gas Sensor',
      'Water pump',
    ];
    List<String> subheadings = [
      'Total Number : 2',
      'Total Number : 1',
      'Total Number : 1',
      'Total Number : 1',
      'Total Number : 1',
      'Total Number : 1',
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            images[index],
            height: 85,
            width: 145,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            headings[index],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(subheadings[index]),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
