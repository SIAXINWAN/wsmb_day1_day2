import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wsmb_day1_try2/models/rider.dart';
import 'package:wsmb_day1_try2/pages/rider/loginRiderPage.dart';
import 'package:wsmb_day1_try2/widgets/bottomSheet.dart';

class RegisterRider extends StatefulWidget {
  const RegisterRider({super.key});

  @override
  State<RegisterRider> createState() => _RegisterRiderState();
}

class _RegisterRiderState extends State<RegisterRider> {
  final nameController = TextEditingController();
  final icnoController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  File? image;
  String gender = 'male';

  void genderChanged(String? value) {
    setState(() {
      gender = value!;
    });
  }

  void submitForm(BuildContext context) async {
    if (image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please upload your image')));
      return;
    }

    if (formKey.currentState!.validate()) {
      Rider tempRider = Rider(
          name: nameController.text,
          icno: icnoController.text,
          gender: gender == 'male');

      var rider =
          await Rider.register(tempRider, passwordController.text, image!);

      if (rider == null) {
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
        return;
      } else {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Suucess'),
                  content: Text('You are successful register'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginRidePage()));
                        },
                        child: Text('OK'))
                  ],
                ));
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> takePhoto(BuildContext context) async {
    ImageSource? source = await showModalBottomSheet(
        context: context, builder: (context) => bottomSheet(context));

    if (source == null) {
      return;
    }

    ImagePicker picker = ImagePicker();
    var file = await picker.pickImage(source: source);
    if (file == null) {
      return;
    }

    image = File(file.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Register Rider',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      (image == null)
                          ? TextButton(
                              onPressed: () {
                                takePhoto(context);
                              },
                              child: Icon(Icons.camera_alt))
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(image!),
                            ),
                      if (image != null)
                        ElevatedButton(
                            onPressed: () {
                              takePhoto(context);
                            },
                            child: Text('Change Photo')),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          label: Text('Name'),
                          hintText: 'Enter your name',
                          suffixIcon: nameController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      nameController.clear();
                                    });
                                  },
                                  icon: Icon(Icons.clear))
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: icnoController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: Text('IC'),
                          hintText: 'Enter your ic',
                          suffixIcon: icnoController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      icnoController.clear();
                                    });
                                  },
                                  icon: Icon(Icons.clear))
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your icno';
                          } else if (value.length != 12) {
                            return 'Please enter a valid ic';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text('Gender'),
                          Radio(
                              value: 'male',
                              groupValue: gender,
                              onChanged: genderChanged),
                          Text('Male'),
                          Radio(
                              value: 'female',
                              groupValue: gender,
                              onChanged: genderChanged),
                          Text('Female'),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          label: Text('Password'),
                          hintText: 'Enter your password',
                          suffixIcon: passwordController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordController.clear();
                                    });
                                  },
                                  icon: Icon(Icons.clear))
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            submitForm(context);
                          },
                          child: Text('Submit')),
                      SizedBox(
                        height: 40,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              textStyle: TextStyle(
                                  fontSize: 24,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blueAccent,
                                  color: Colors.blueAccent)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginRidePage()));
                          },
                          child: Text('Login'))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
