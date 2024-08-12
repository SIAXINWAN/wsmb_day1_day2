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

return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: InteractiveViewer(
                panEnabled: true, // 允许平移
                minScale: 0.5,   // 最小缩放比例
                maxScale: 3.0,   // 最大缩放比例
                child: Image.network(
                  'https://your-image-url-here.com',
                  fit: BoxFit.contain,
                ),
              ),
            );

import 'package:intl/intl.dart';

void main() {
  // 自定义格式的日期字符串
  String dateString = "12/08/2024 14:30";

  // 定义解析格式
  DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");

  // 解析字符串为 DateTime
  DateTime parsedDate = dateFormat.parse(dateString);

  // 获取当前时间
  DateTime now = DateTime.now();

  // 比较两个时间
  if (parsedDate.isBefore(now)) {
    print("The parsed date is before the current date.");
  } else if (parsedDate.isAfter(now)) {
    print("The parsed date is after the current date.");
  } else {
    print("The parsed date is exactly the current date.");
  }

  // 计算时间差（以天为单位）
  Duration difference = parsedDate.difference(now);
  print("Difference in days: ${difference.inDays}");
}