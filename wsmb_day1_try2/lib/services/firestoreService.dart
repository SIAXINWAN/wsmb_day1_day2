import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/models/ride.dart';
import 'package:wsmb_day1_try2/models/rider.dart';
import 'package:wsmb_day1_try2/models/vehicle.dart';

class FirestoreService {
  static final firestore = FirebaseFirestore.instance;

  static Future<bool> isDuplicated(Human human) async {
    final queries = [
      firestore.collection('humans').where('icno', isEqualTo: human.icno).get(),
    ];

    final querySnapshot = await Future.wait(queries);

    final exists =
        querySnapshot.any((querySnapshot) => querySnapshot.docs.isNotEmpty);
    return exists;
  }

  static Future<Human?> addHuman(Human human) async {
    try {
      var collection = await firestore.collection('humans').get();
      human.id = 'H${collection.size + 1}';

      var doc = firestore.collection('humans').doc(human.id);
      doc.set(human.toJson());

      var humanDoc = await firestore.collection('humans').doc(human.id).get();
      Map<String, dynamic> data = humanDoc.data() as Map<String, dynamic>;
      Human newHuman = Human.fromJson(data);
      return newHuman;
    } catch (e) {
      return null;
    }
  }

  static Future<Human?> getHuman(String id) async {
    try{
      var doc = await firestore.collection('humans').doc(id).get();
      if(doc.exists){
        return Human.fromJson(doc.data()!,doc.id);
      }
      return null;
    }catch(e){
      return null;
    }
  }

  static Future<Vehicle?> getV(String id) async {
    try{
      var doc = await firestore.collection('vehicles').doc(id).get();
      if(doc.exists){
        return Vehicle.fromJson(doc.data()!,doc.id);

      }

      return null;
    }catch(e){
      return null;
    }
  }

  static Future<Human?> loginHuman(String ic, String password) async {
    try {
      var collection = await firestore
          .collection('humans')
          .where('icno', isEqualTo: ic)
          .where('password', isEqualTo: password)
          .get();

      if (collection.docs.isEmpty) {
        return null;
      }

      var doc = collection.docs.first;

      var human = Human.fromJson(doc.data());
      human.id = doc.id;
      return human;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateHuman(Human human, String id) async {
    try {
      await firestore.collection('humans').doc(id).update(human.toSome());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addVehicle(Vehicle vehicle) async {
    try {
      vehicle.id =
          'V${DateTime.now().millisecondsSinceEpoch}-${vehicle.driver_id}';
      var doc = firestore.collection('vehicles').doc(vehicle.id);
      doc.set(vehicle.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Vehicle>> getVehicle() async {
    try {
      var collection = await firestore.collection('vehicles').get();

      if (collection.docs.isEmpty) {
        return [];
      }

      var list =
          collection.docs.map((e) => Vehicle.fromJson(e.data(), e.id)).toList();
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> updateVehicle(Vehicle vehicle, String id) async {
    try {
      await firestore.collection('vehicles').doc(id).update(vehicle.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteVehicle(String vehicle_id) async {
    try {
      await firestore.collection('vehicles').doc(vehicle_id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addRide(Ride ride) async {
    try {
      ride.id = 'R${DateTime.now().millisecondsSinceEpoch}-${ride.vehicle_id}';
      var doc = firestore.collection('rides').doc(ride.id);
      doc.set(ride.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Ride>> getRide() async {
    try {
      var ride = await firestore.collection('rides').get();

      if (ride.docs.isEmpty) {
        return [];
      }

      var list = ride.docs.map((e) => Ride.fromJson(e.data(), e.id)).toList();
      return list;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> deleteRide(String ride_id) async {
    try {
      await firestore.collection('rides').doc(ride_id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Rider?> addRider(Rider rider) async {
    try {
      var collection = await firestore.collection('riders').get();
      rider.id = 'RI${collection.size + 1}';

      var doc = firestore.collection('riders').doc(rider.id);
      doc.set(rider.toJson());

      var riderDoc = await firestore.collection('riders').doc(rider.id).get();
      Map<String, dynamic> data = riderDoc.data() as Map<String, dynamic>;
      Rider newRider = Rider.fromJson(data);
      return newRider;
    } catch (e) {
      return null;
    }
  }

  static Future<Rider?> getRider(String id) async {
    try{
      var doc = await firestore.collection('riders').doc(id).get();
      if(doc.exists){
        return Rider.fromJson(doc.data()!,doc.id);
      }
      return null;
    }catch(e)
    {
      return null;
    }
    }

  static Future<Rider?> loginRider(String ic, String password) async {
    try {
      var collection = await firestore
          .collection('riders')
          .where('icno', isEqualTo: ic)
          .where('password', isEqualTo: password)
          .get();

      if (collection.docs.isEmpty) {
        return null;
      }

      var doc = collection.docs.first;

      var rider = Rider.fromJson(doc.data());
      rider.id = doc.id;
      return rider;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateRider(Rider rider, String id) async {
    try {
      await firestore.collection('rdiers').doc(id).update(rider.toSome());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> joinRide(Ride ride, Vehicle vehicle, Rider rider) async {
    try {
      if (vehicle.capacity <= ride.riderIds.length) {
        return false;
      }
      if (ride.riderIds.contains(rider.id)) {
        return false;
      }

      ride.riderIds.add(rider.id!);

      var doc = firestore.collection('rides').doc(ride.id!);
      doc.set(ride.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> cancelRide(
      Ride ride, Vehicle vehicle, Rider rider) async {
    try {
      if (!ride.riderIds.contains(rider.id)) {
        return false;
      }

      ride.riderIds.remove(rider.id!);
      var doc = firestore.collection('rides').doc(ride.id!);
      doc.set(ride.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool>likeRide(
    Ride ride, Vehicle vehicle, Rider rider
  )async{
    try{
      if(ride.like.contains(rider.id)){
        return false;
      }

      ride.like.add(rider.id!);
      var doc = firestore.collection('rides').doc(ride.id);
      doc.set(ride.toJson());
      return true;
    }catch(e){
      return false;
    }
  }

  static Future<bool>unlikeRide(
    Ride ride, Vehicle vehicle, Rider rider
  )async{
    try{
      if(!ride.like.contains(rider.id)){
        return false;
      }

      ride.like.remove(rider.id);
      var doc = firestore.collection('rides').doc(ride.id!);
      doc.set(ride.toJson());
      return true;
    }catch(e){
      return false;
    }
  }

  
}
