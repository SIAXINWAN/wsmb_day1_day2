

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

import 'package:intl/intl.dart';

setState(() {
  DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");

  if (selectedSegment == 0) {
    filteredRides = widget.rideList
        .where((ride) => 
            ride.riderIds.contains(rider?.id) && 
            dateFormat.parse(ride.date).isBefore(DateTime.now())
        )
        .toList();
  } else if (selectedSegment == 1) {
    filteredRides = widget.rideList
        .where((ride) => 
            ride.like.contains(rider?.id) && 
            dateFormat.parse(ride.date).isBefore(DateTime.now())
        )
        .toList();
  }
});

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Ride {
  int fare;
  String date;

  Ride(this.fare, this.date);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Filtered Fare Example'),
        ),
        body: FilteredRidesWidget(),
      ),
    );
  }
}

class FilteredRidesWidget extends StatefulWidget {
  @override
  _FilteredRidesWidgetState createState() => _FilteredRidesWidgetState();
}

class _FilteredRidesWidgetState extends State<FilteredRidesWidget> {
  List<Ride> ridelist = [
    Ride(10, "12/08/2024 14:30"),
    Ride(20, "12/08/2024 15:00"),
    Ride(30, "12/08/2024 16:00"),
  ];

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");
    DateTime now = DateTime.now();

    List<Ride> filteredRides = ridelist
        .where((ride) => dateFormat.parse(ride.date).isBefore(now))
        .toList();

    int totalFare = filteredRides.fold(0, (sum, ride) => sum + ride.fare);

    return Center(
      child: Text(
        'Total Fare of Filtered Rides: \$${totalFare}',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}


setState(() {
  final now = DateTime.now();
  
  if (selectedSegment == 0) {
    filteredRides = widget.rideList
        .where((ride) {
          final rideDate = DateTime.parse(ride.date);
          return ride.riderIds.contains(rider?.id) && rideDate.isAfter(now);
        })
        .toList();
  } else if (selectedSegment == 1) {
    filteredRides = widget.rideList
        .where((ride) {
          final rideDate = DateTime.parse(ride.date);
          return ride.like.contains(rider?.id) && rideDate.isBefore(now);
        })
        .toList();
  }
});


int totalFare = rideList.fold(0, (sum, ride) => sum + ride.fare);

double totalFare = rideList.fold(0, (sum, ride) => sum + ride.fare);

bool isJoin =false;
  @override
  String info = '';
  void initState() {
    // TODO: implement initState
    super.initState();
    updateIsJoin();
  }

  void updateIsJoin()async{
    var id = await Rider.getRiderByToken();
    isJoin = widget.ride.riderIds!.contains(id?.id??'');
    var res = await DatabaseService.getRideDetails(widget.ride.id!);
    info = 'People join: '+(widget.ride.riderIds!.length).toString()+ '/${res.$1!.capacity}';
  setState(() {

  });
  }
  @override
  Widget build(BuildContext context) {
    updateIsJoin();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black,width: 2),color: (isJoin)?Colors.green:Colors.white,),
      width:double.infinity,
      height: MediaQuery.of(context).size.height *0.15,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date ${widget.ride.date}'),
              Text('Fare ${widget.ride.fare.toStringAsFixed(2)}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Origin ${widget.ride.origin}'),
                  Text('Destination ${widget.ride.destination}')
                ],
              ),
              Text(info),
            ],
          ),),
          SizedBox(width: 30,),
          ElevatedButton(
            onPressed: ()async{
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context)=>RideDetailsPage(ride:widget.ride)));
                await widget.func();
            },
            child: Text('Details'))
        ],