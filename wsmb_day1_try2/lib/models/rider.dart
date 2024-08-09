import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wsmb_day1_try2/services/firestoreService.dart';

class Rider {
  final String name;
  final String icno;
  final bool gender;
  String? image;
  String? password;
  String? id;

  Rider(
      {this.id,
      this.image,
      required this.name,
      required this.icno,
      required this.gender});

  static Future<Rider?> register(
      Rider rider, String password, File image) async {
    var byte = utf8.encode(password);
    var hashedPassword = sha256.convert(byte).toString();

    rider.password = hashedPassword;

    String fileName = 'rider/${DateTime.now().microsecondsSinceEpoch}.jpg';
    UploadTask uploadTask =
        FirebaseStorage.instance.ref(fileName).putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    rider.image = downloadURL;

    var newRider = await FirestoreService.addRider(rider);
    if (newRider == null) {
      return null;
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('rider_token', rider.id.toString());
    return newRider;
  }

  static Future<Rider?>login(String ic, String password)async{
    var byte = utf8.encode(password);
    var hashedPassword = sha256.convert(byte).toString();

    var rider = await FirestoreService.loginRider(ic, hashedPassword);
    if(rider==null){
      return null;
    }
   SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('rider_token', rider.id.toString());
        return rider;
  }

  static Future<Rider?>getRiderbyToken()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('rider_token');
    if(token == null){
      return null;
    }
    var rider = await FirestoreService.getRider(token);
    return rider;
  }

  static Future<bool>signOut()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var logout = await pref.remove('rider_token');
    return logout;
  }

  factory Rider.fromJson(Map<String, dynamic> json, [String? id]) {
    return Rider(
        id: id,
        name: json['name'] ?? '',
        icno: json['icno'] ?? '',
        gender: json['gender'] as bool,
        image: json['image']);
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'icno': icno,
      'gender': gender,
      'image': image,
      'password': password
    };
  }

  toSome() {
    return {
      'name': name,
      'icno': icno,
      'gender': gender,
      'image': image,
    };
  }
}
