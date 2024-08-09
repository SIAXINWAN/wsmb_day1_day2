import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/models/ride.dart';
import 'package:wsmb_day1_try2/models/vehicle.dart';
import 'package:wsmb_day1_try2/pages/4ride/1addRide.dart';
import 'package:wsmb_day1_try2/pages/rider/filterRidePage.dart';
import 'package:wsmb_day1_try2/services/firestoreService.dart';
import 'package:wsmb_day1_try2/widgets/rideCard.dart';

class RidePage extends StatefulWidget {
  const RidePage({
    super.key,
  });

  @override
  State<RidePage> createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  List<Ride> rideList = [];
  List<Vehicle> vehicleList = [];
  List<Human> humanList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRideList();
  }

  void getRideList() async {
    vehicleList = await FirestoreService.getVehicle();
    rideList = await FirestoreService.getRide();
    for (var r in rideList) {
      var d = await r.getDriver();
      humanList.add(d!);
    }
    for (var v in rideList) {
      var e = await v.getVehicle();
      vehicleList.add(e!);
    }
    setState(() {});
  }

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void takeDate() async {
    final tempDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(
          Duration(days: 30),
        ),
        initialDate: selectedDate ?? DateTime.now());
    if (tempDate != null) {
      setState(() {
        selectedDate = tempDate;
      });
    }
  }

  void takeTime() async {
    final tempTime = await showTimePicker(
        context: context, initialTime: selectedTime ?? TimeOfDay.now());
    if (tempTime != null) {
      setState(() {
        selectedTime = tempTime;
      });
    }
  }

  void clearDate() {
    setState(() {
      selectedDate = null;
    });
  }

  void clearTime() {
    setState(() {
      selectedTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var fliterList = rideList.where((e) {
      bool dateMatch = selectedDate == null ||
          (e.date.year == selectedDate!.year &&
              e.date.month == selectedDate!.month &&
              e.date.day == selectedDate!.day);
      bool timeMatch = selectedTime == null ||
          (e.date.hour == selectedTime!.hour &&
              e.date.minute == selectedTime!.minute);
      return dateMatch && timeMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Ride'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Center(
            child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Are you want to next page?'),
                      duration: Duration(seconds: 3),
                      action: SnackBarAction(
                          label: 'Alert',
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                  );
                },
                child: Text(
                  'Next',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                )),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: TextFormField()),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (vehicleList.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'You have to add vehicle first')));
                                return null;
                              }
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => AddRidePage(
                                            vehicleList: vehicleList,
                                          )));
                            },
                            child: Icon(Icons.add)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                              onPressed: takeDate,
                              child: Text(selectedDate == null
                                  ? 'Select Date'
                                  : "Date : ${selectedDate!.toLocal().toString().replaceRange(10, null, '')}")),
                          if (selectedDate != null)
                            ElevatedButton(
                                onPressed: () {
                                  clearDate();
                                },
                                child: Text('Clear')),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                              onPressed: takeTime,
                              child: Text(selectedTime == null
                                  ? 'Select Time'
                                  : 'Time : ${selectedTime!.format(context)}')),
                          if (selectedTime != null)
                            ElevatedButton(
                                onPressed: () {
                                  clearTime();
                                },
                                child: Text('Clear')),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: fliterList.length,
                        itemBuilder: (context, index) {
                          return RideCard(
                            vehicle: vehicleList[index],
                            ride: fliterList[index],
                            human: humanList[index],
                          );
                        })),
              ],
            ),
          ),
        ],
      )),
      bottomNavigationBar: ElevatedButton(
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FilterRidePage(
                      rideList: rideList,
                    )));
          },
          child: Text('Filter Page')),
    );
  }
}
