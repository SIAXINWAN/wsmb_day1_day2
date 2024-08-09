import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/models/ride.dart';
import 'package:wsmb_day1_try2/models/vehicle.dart';
import 'package:wsmb_day1_try2/services/firestoreService.dart';
import 'package:wsmb_day1_try2/widgets/vehicleCard.dart';

class ShowVehiclePage extends StatefulWidget {
  const ShowVehiclePage({super.key});

  @override
  State<ShowVehiclePage> createState() => _ShowVehiclePageState();
}

class _ShowVehiclePageState extends State<ShowVehiclePage> {
  List<Vehicle> vehiclelist = [];

  List<Human> human = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVehicleList();
  }

  void getVehicleList() async {
   
    vehiclelist = await FirestoreService.getVehicle();
    for (var h in vehiclelist) {
      var d = await h.getDriver();
      human.add(d!);
    }
    setState(() {});
  }

  final modelController = TextEditingController();
  final capacityController = TextEditingController();
  final featuresController = TextEditingController();
  final driverController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String modelFilter = '';
  String capacityFilter = '';
  String featuresFilter = '';
  String driverFilter = '';
  TimeOfDay? selectedTime;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    var filterList = vehiclelist.where((e) {
      bool modelMatch =
          e.car_model.toLowerCase().contains(modelFilter.toLowerCase());
      bool capacityMatch = e.capacity
          .toString()
          .toLowerCase()
          .contains(capacityFilter.toLowerCase());
      bool featuresMatch = e.special_features
          .toLowerCase()
          .contains(featuresFilter.toLowerCase());
      return modelMatch && capacityMatch && featuresMatch;
    }).toList();

    var humanList = human.where((e) {
      bool driverMatch =
          e.name.toLowerCase().contains(driverFilter.toLowerCase());
      return driverMatch;
    }).toList();

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Show Vehicle',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: modelController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                suffixIcon: modelController.text.isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            modelController.clear();
                                            modelFilter = '';
                                          });
                                        },
                                        icon: Icon(Icons.clear))
                                    : null,
                                label: Text('Car Model'),
                                hintText: 'Search car model'),
                            onChanged: (value) {
                              setState(() {
                                modelFilter = value.trim();
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: capacityController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                suffixIcon: capacityController.text.isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            capacityController.clear();
                                            capacityFilter = '';
                                          });
                                        },
                                        icon: Icon(Icons.clear))
                                    : null,
                                label: Text('Capacity'),
                                hintText: 'Search capacity'),
                            onChanged: (value) {
                              setState(() {
                                capacityFilter = value.trim();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: featuresController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                suffixIcon: featuresController.text.isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            featuresController.clear();
                                            featuresFilter = '';
                                          });
                                        },
                                        icon: Icon(Icons.clear))
                                    : null,
                                label: Text('Special Feature'),
                                hintText: 'Search special feature'),
                            onChanged: (value) {
                              setState(() {
                                featuresFilter = value.trim();
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: driverController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                suffixIcon: driverController.text.isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            driverController.clear();
                                            driverFilter = '';
                                          });
                                        },
                                        icon: Icon(Icons.clear))
                                    : null,
                                label: Text('Search driver'),
                                hintText: 'Search driver'),
                            onChanged: (value) {
                              setState(() {
                                driverFilter = value.trim();
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: filterList.length > humanList.length
                      ? humanList.length
                      : filterList.length,
                  itemBuilder: (context, index) {
                    return VehicleCard(
                      vehicle: filterList[index],
                      human: humanList[index],
                    );
                  }))
        ],
      )),
    );
  }
}
