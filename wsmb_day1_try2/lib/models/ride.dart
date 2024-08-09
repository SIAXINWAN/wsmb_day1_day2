import 'package:shared_preferences/shared_preferences.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/models/vehicle.dart';
import 'package:wsmb_day1_try2/services/firestoreService.dart';

class Ride {
  final String origin;
  final String destination;
  final double fare;
  final DateTime date;
  final String vehicle_id;
  String? id;
  String? human_id;
  List<String>riderIds;
  List<String>like;
  List<String>rider;

  Ride(
      {this.id,
      List<String>?riderIds,
      this.human_id,
      required this.origin,
      required this.destination,
      required this.fare,
      required this.date,
      required this.vehicle_id,
      List<String>?rider,
      List<String>?like})
      :this.riderIds = riderIds??[],
      this.like = like??[],
      this.rider = rider??[]
      ;

  static Future<bool> registerRide(DateTime masa, double money, String tempat,
      String sampai, String id,List<String>riders) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    if (token == null) {
      return false;
    }
    Ride ride = Ride(
        human_id: token,
        origin: tempat,
        destination: sampai,
        fare: money,
        date: masa,
        vehicle_id: id,
        rider: riders);

    var res = await FirestoreService.addRide(ride);
    return res;
  }

  Future<Human?> getDriver() async {
    if (human_id == null) {
      return null;
    }
    var human = await FirestoreService.getHuman(human_id!);
    return human;
  }

  Future<Vehicle?>getVehicle()async{
    
    var vv = await FirestoreService.getV(vehicle_id);
    return vv;
  }

  factory Ride.fromJson(Map<String, dynamic> json, String id) {
    return Ride(
        id: id,
        human_id: json['human_id'] ?? '',
        origin: json['origin'] ?? '',
        destination: json['destination'] ?? '',
        fare: json['fare'] as double,
        date: DateTime.parse(json['date']),
        vehicle_id: json['vehicle_id'] ?? '',
        riderIds: (json['riderIds']as List<dynamic>?)?.map((e)=>e.toString()).toList()??[],
        like :(json['like']as List<dynamic>?)?.map((e)=>e.toString()).toList()??[],
        rider:(json['rider']as List<dynamic>?)?.map((e)=>e.toString()).toList()??[]
        );
  }

  toJson() {
    return {
      'id': id,
      'human_id': human_id,
      'origin': origin,
      'destination': destination,
      'fare': fare,
      'date': date.toString(),
      'vehicle_id': vehicle_id,
      'riderIds':riderIds,
      'like':like,
      'rider':rider
    };
  }
}
