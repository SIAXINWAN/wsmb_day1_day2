import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/firebase_options.dart';
import 'package:wsmb_day1_try2/pages/firstPage.dart';
import 'package:wsmb_day1_try2/pages/takePhoto.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled:true);
  runApp(const MyApp(home: FirstPage()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.home});
  final Widget home;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}

final List<Ride> ridelist = [
    Ride(10.5),
    Ride(20.75),
    Ride(15.25),
    Ride(30.0),
  ];

  @override
  Widget build(BuildContext context) {
    double totalFare = ridelist.fold(0.0, (sum, ride) => sum + ride.fare);

    return Center(
      child: Text(
        'Total Fare: \$${totalFare.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 24),
      ),