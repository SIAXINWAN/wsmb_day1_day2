import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wsmb_day1_try2/services/firestoreService.dart';

class Human {
  String? id;
  final String name;
  final String icno;
  final bool gender;
  String? image;
  String? password;

  Human(
      {required this.icno,
      this.id,
      this.image,
      required this.name,
      required this.gender});

  static Future<Human?> register(
      Human human, String password, File image) async {
    if (await FirestoreService.isDuplicated(human)) {
      return null;
    }

    var byte = utf8.encode(password);
    var hashedPassword = sha256.convert(byte).toString();

    human.password = hashedPassword;

    String fileName = 'human/${DateTime.now().millisecondsSinceEpoch}.jpg';
    UploadTask uploadTask =
        FirebaseStorage.instance.ref(fileName).putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    human.image = downloadURL;

    var newHuman = await FirestoreService.addHuman(human);
    if (newHuman == null) {
      return null;
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', human.id.toString());
    return newHuman;
  }

  static Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    if (token == null) {
      return '';
    }
    return token;
  }

  static Future<Human?>getHumanByToken()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token  = pref.getString('token');
    if(token == null){
      return null;
    }
    var rider  =await FirestoreService.getHuman(token);
    return rider;
  }

  static Future<Human?> login(String ic, String password) async {
    var byte = utf8.encode(password);
    var hashedPassword = sha256.convert(byte).toString();

    var human = await FirestoreService.loginHuman(ic, hashedPassword);
    if (human == null) {
      return null;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', human.id.toString());
    return human;
  }

  static Future<bool> signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var logout = await pref.remove('token');
    return logout;
  }

  static Future<String> saveImage(File image) async {
    String fileName = 'human/${DateTime.now().microsecondsSinceEpoch}.jpg';
    UploadTask uploadTask =
        FirebaseStorage.instance.ref(fileName).putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  factory Human.fromJson(Map<String, dynamic> json, [String? id]) {
    return Human(
        id: id ?? json['id'] ?? '',
        icno: json['icno'] ?? '',
        name: json['name'] ?? '',
        gender: json['gender'] as bool,
        image: json['image']);
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'icno': icno,
      'image': image,
      'password': password
    };
}
    toSome(){
      return{
        'name':name,
        'gender':gender,
        'icno':icno,
        'image':image
          };
    }
  
}
