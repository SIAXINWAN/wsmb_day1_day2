import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/services/firestoreService.dart';

class Vehicle {
  final String car_model;
  final int capacity;
  final String special_features;
  String? image;
  final String driver_id;
  String? id;

  Vehicle(
      {this.id,
      this.image,
      required this.car_model,
      required this.capacity,
      required this.special_features,
      required this.driver_id});

  static Future<bool> register(
      String model, int capacity, String feature, File? image) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    if (token == null) {
      return false;
    }
    String imageLink = '';
    if (image != null) {
      String fileName = 'Vehicle/${DateTime.now().microsecondsSinceEpoch}.jpg';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref(fileName).putFile(image);

      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      imageLink = downloadURL;
    }

    Vehicle vehicle = Vehicle(
        car_model: model,
        capacity: capacity,
        special_features: feature,
        driver_id: token,
        image: imageLink);

    var res = await FirestoreService.addVehicle(vehicle);
    return res;
  }

  Future<Human?> getDriver() async {
    if (driver_id == null) {
      return null;
    }
    var human = await FirestoreService.getHuman(driver_id!);
    return human;
  }

  factory Vehicle.fromJson(Map<String, dynamic> json, [String? vid]) {
    return Vehicle(
        id: vid,
        car_model: json['car_model'] ?? '',
        capacity: json['capacity'] ?? 0,
        special_features: json['special_features'] ?? 'None',
        driver_id: json['driver_id'],
        image: json['image'] ?? '');
  }

  toJson() {
    return {
      'id': id,
      'car_model': car_model,
      'capacity': capacity,
      'special_feature': special_features,
      'image': image,
      'driver_id': driver_id
    };
  }
}
