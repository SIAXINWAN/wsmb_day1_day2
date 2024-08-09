import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/models/ride.dart';
import 'package:wsmb_day1_try2/models/rider.dart';
import 'package:wsmb_day1_try2/models/vehicle.dart';
import 'package:wsmb_day1_try2/services/firestoreService.dart';

class RideCard extends StatefulWidget {
  const RideCard({
    super.key,
    required this.ride,
    required this.human,
    required this.vehicle,
  });
  final Ride ride;
  final Human human;
  final Vehicle vehicle;

  @override
  State<RideCard> createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {
  bool isJoin = false;
  Rider? rider;
  bool isLiked = false;

  void checkStatus() async {
    rider = await Rider.getRiderbyToken();
    isJoin = widget.ride.riderIds.contains(rider?.id ?? '');
    isLiked = widget.ride.like.contains(rider?.id ?? '');
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (isLiked == true)
            ? Colors.green
            : const Color.fromARGB(255, 185, 86, 86),
        border: Border.all(
          width: 3,
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(4),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: CircleAvatar(
              radius: 10,
              backgroundImage: NetworkImage(widget.human.image!),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Origin'),
                  Text('Destination'),
                  Text('Date Time'),
                  Text('Fare'),
                  Text('Driver'),
                  Text('Capacity'),
                  (widget.ride.rider.isNotEmpty) ? Text('Rider') : Text(''),
                  (isJoin != true) ? Text('') : Text('Joined')
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
                    Text(': ${widget.ride.origin}'),
                    Text(': ${widget.ride.destination}'),
                    Text(
                        ': ${widget.ride.date.toString().replaceRange(16, null, '')}'),
                    Text(': RM${widget.ride.fare}'),
                    Text(': ${widget.human.name}'),
                    Text(': ${widget.vehicle.capacity}'),
                    Text(': ${widget.ride.rider.join(', ')}')
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
                      await FirestoreService.deleteRide(widget.ride.id ?? '');
                    },
                    child: Icon(Icons.cancel_presentation_rounded)),
                (isJoin != false)
                    ? ElevatedButton(
                        onPressed: () async {
                          var res = await FirestoreService.cancelRide(
                              widget.ride, widget.vehicle, rider!);
                          if (!res) {
                            return;
                          }
                        },
                        child: Icon(Icons.cancel))
                    : ElevatedButton(
                        onPressed: () async {
                          var res = await FirestoreService.joinRide(
                              widget.ride, widget.vehicle, rider!);
                          if (!res) {
                            return;
                          }
                        },
                        child: Icon(Icons.join_inner)),
              ],
            ),
          ),
          (isLiked != false)
              ? ElevatedButton(
                  onPressed: () async {
                    var res = await FirestoreService.unlikeRide(
                        widget.ride, widget.vehicle, rider!);
                    if (!res) {
                      return;
                    }
                  },
                  child: Icon(Icons.thumb_up_off_alt))
              : ElevatedButton(
                  onPressed: () async {
                    var res = await FirestoreService.likeRide(
                        widget.ride, widget.vehicle, rider!);
                    if (!res) {
                      return;
                    }
                  },
                  child: Icon(Icons.favorite_outline_rounded)),
        ],
      ),
    );
  }
}
