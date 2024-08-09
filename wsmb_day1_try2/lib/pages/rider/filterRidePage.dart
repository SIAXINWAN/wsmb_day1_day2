import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wsmb_day1_try2/models/ride.dart';
import 'package:wsmb_day1_try2/models/rider.dart';

class FilterRidePage extends StatefulWidget {
  const FilterRidePage({
    Key? key,
    required this.rideList,
  }) : super(key: key);

  final List<Ride> rideList;

  @override
  State<FilterRidePage> createState() => _FilterRidePageState();
}

class _FilterRidePageState extends State<FilterRidePage> {
  int selectedSegment = 0;
  List<Ride> filteredRides = [];
  String? token;

  @override
  void initState() {
    super.initState();
    filterRides();
  }

  void filterRides() async {
    Rider? rider = await Rider.getRiderbyToken();

    setState(() {
      if (selectedSegment == 0) {
        filteredRides = widget.rideList
            .where((ride) => ride.riderIds.contains(rider?.id))
            .toList();
      } else if (selectedSegment == 1) {
        filteredRides = widget.rideList
            .where((ride) => ride.like.contains(rider?.id))
            .toList();
      }
    });
  }

  Widget _buildSegmentButton(int index, String text) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedSegment = index;
            filterRides();
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selectedSegment == index ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selectedSegment == index ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRideCard(Ride ride) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Origin: ${ride.origin}', style: TextStyle(fontSize: 16)),
            Text('Destination: ${ride.destination}',
                style: TextStyle(fontSize: 16)),
            Text('Date: ${ride.date.toString().substring(0, 16)}',
                style: TextStyle(fontSize: 16)),
            Text('Fare: RM${ride.fare}', style: TextStyle(fontSize: 16)),
            Text('Riders: ${ride.rider.join(", ")}',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filtered Rides')),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _buildSegmentButton(0, 'Joined'),
                SizedBox(width: 10),
                _buildSegmentButton(1, 'Liked'),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: filteredRides.isEmpty
                ? Center(child: Text('No rides found'))
                : ListView.builder(
                    itemCount: filteredRides.length,
                    itemBuilder: (context, index) {
                      return _buildRideCard(filteredRides[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
