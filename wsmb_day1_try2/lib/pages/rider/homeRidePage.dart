import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/pages/4ride/ridePage.dart';
import 'package:wsmb_day1_try2/pages/firstPage.dart';
import 'package:wsmb_day1_try2/pages/rider/filterRidePage.dart';
import 'package:wsmb_day1_try2/services/firestoreService.dart';

class HomeRidePage extends StatefulWidget {
  const HomeRidePage({super.key});

  @override
  State<HomeRidePage> createState() => _HomeRidePageState();
}

class _HomeRidePageState extends State<HomeRidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RidePage()));
                },
                child: Text('View Ride List')),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => FirstPage()));
              },
              child: Text('First Page')),
          SizedBox(
            height: 40,
          ),
        ],
      )),
    );
  }
}
