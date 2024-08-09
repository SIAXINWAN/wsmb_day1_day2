import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/models/vehicle.dart';
import 'package:wsmb_day1_try2/services/firestoreService.dart';

class VehicleCard extends StatefulWidget {
  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.human,
  });
  final Vehicle vehicle;
  final Human human;

  @override
  State<VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(4),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.vehicle.image!),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Car model'),
                  Text('Capacity'),
                  Text('Special Feature'),
                  Text('Driver')
                ],
              ),
              SizedBox(
                width: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(': ${widget.vehicle.car_model}'),
                    Text(': ${widget.vehicle.capacity}'),
                    Text(': ${widget.vehicle.special_features}'),
                    Text(': ${widget.human.name}')
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MaterialButton(
                    onPressed: () async {
                      await FirestoreService.deleteVehicle(
                          widget.vehicle.id ?? '');
                    },
                    child: Icon(Icons.cancel_presentation_rounded)),
                ElevatedButton(onPressed: () {}, child: Icon(Icons.edit)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
