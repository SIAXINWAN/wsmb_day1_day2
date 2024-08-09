import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/models/ride.dart';
import 'package:wsmb_day1_try2/models/vehicle.dart';
import 'package:wsmb_day1_try2/services/firestoreService.dart';

class AddRidePage extends StatefulWidget {
  const AddRidePage({
    Key? key,
    required this.vehicleList,
  }) : super(key: key);

  final List<Vehicle> vehicleList;

  @override
  State<AddRidePage> createState() => _AddRidePageState();
}

class _AddRidePageState extends State<AddRidePage> {
  final originController = TextEditingController();
  final destController = TextEditingController();
  final fareController = TextEditingController();
  final riderController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  DateTime? dateTime;
  String? vehicle_id;
  List<String>rider = [];

  void splitText(){
    setState(() {
      rider = riderController.text.split(',').map((e)=>
      e.trim()).where((e)=>e.isNotEmpty).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    originController.text = 'Mydin';
    destController.text = 'Utem';
    fareController.text = '30';
    vehicle_id = widget.vehicleList[0].id!;
  }

  void submitForm() async {
    if (dateTime == null || dateTime!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid date time')));
      return;
    }

    if (vehicle_id == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select a vehicle')));
      return;
    }

    if (formKey.currentState!.validate()) {
      splitText();
      var res = await Ride.registerRide(
          dateTime!,
          double.parse(fareController.text),
          originController.text,
          destController.text,
          vehicle_id!,
          rider);
      if (res) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Your ride is added successfully'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'))
                  ],
                ));
        Navigator.of(context).pop();
      } else {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Warning'),
                  content: Text('Something went wrong'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'))
                  ],
                ));
      }
    }
  }

  void takeDateTime() async {
    var tempDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 30)));
    if (tempDate == null) {
      return;
    }

    var tempTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: DateTime.now().hour, minute: DateTime.now().minute));
    if (tempTime == null) {
      return;
    }

    dateTime = DateTime(tempDate.year, tempDate.month, tempDate.day,
        tempTime.hour, tempTime.minute);

    if (dateTime!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid time')));
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kongsi Kereta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                      controller: originController,
                      decoration: InputDecoration(
                          label: Text('Origin'), hintText: 'enter your origin'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your origin';
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: destController,
                      decoration: InputDecoration(
                          label: Text('Destination'),
                          hintText: 'enter your destination'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your destination';
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: fareController,
                      decoration: InputDecoration(
                        suffixIcon: fareController.text.isNotEmpty?
                        IconButton(onPressed: (){
                          fareController.clear();
                        }, icon: Icon(Icons.clear)):null,
                          label: Text('Fare'), hintText: 'enter your fare'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your fare';
                        }
                        return null;
                      }),
                      TextFormField(
                      controller: riderController,
                      decoration: InputDecoration(
                          label: Text('Rider'), hintText: 'enter your rider'),
                      validator: (value){
                        splitText();
                        if(rider.length>widget.vehicleList.firstWhere((v)=>v.id ==vehicle_id).capacity){
                          return 'Too many riders';
                        }
                        return null;
                      },
                        
                      ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButton(
                      items: [
                        for (int i = 0; i < widget.vehicleList.length; i++)
                          DropdownMenuItem(
                            child: Text(widget.vehicleList[i].car_model),
                            value: widget.vehicleList[i].id,
                          ),
                      ],
                      value: vehicle_id,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        vehicle_id = value;
                        setState(() {});
                      }),
                  SizedBox(height: 20),
                  dateTime == null
                      ? TextButton(
                          onPressed: takeDateTime, child: Text('Take Time'))
                      : Text(dateTime.toString().substring(0, 16)),
                  SizedBox(height: 30),
                  ElevatedButton(onPressed: submitForm, child: Text('Submit'))
                ],
              )),
        ),
      ),
    );
  }
}
