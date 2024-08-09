import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/services/firestoreService.dart';
import 'package:wsmb_day1_try2/widgets/bottomSheet.dart';

class EditDetailPage extends StatefulWidget {
  const EditDetailPage({super.key, required this.human});
  final Human human;

  @override
  State<EditDetailPage> createState() => _EditDetailPageState();
}

class _EditDetailPageState extends State<EditDetailPage> {
  File? image;

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

  Widget displayImage() {
    if (image != null) {
      return Image.file(
        image!,
        fit: BoxFit.cover,
        height: 100,
        width: double.infinity,
      );
    } else if (widget.human.image != null) {
      return Image.network(
        widget.human.image!,
        fit: BoxFit.cover,
        height: 100,
        width: double.infinity,
      );
    } else {
      return Container(
        height: 100,
        width: double.infinity,
        color: Colors.grey,
        child: Icon(Icons.person),
      );
    }
  }

  final nameController = TextEditingController();
  final icnoController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String gender = 'male';

  void genderChanged(String? value) {
    setState(() {
      gender = value!;
    });
  }

  void submitForm() async {
    if (image != null) {
      widget.human.image = await Human.saveImage(image!);
    }
    if (formKey.currentState!.validate()) {
      Human human = Human(
          icno: icnoController.text,
          name: nameController.text,
          gender: gender == 'male',
          image: widget.human.image);

      var res = await FirestoreService.updateHuman(human, widget.human.id!);

      if (res) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Your profile is updated successfully'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
        Navigator.of(context).pop();
      } else {
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
                        child: Text('Ok'))
                  ],
                ));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.human.name;
    icnoController.text = widget.human.icno;
    gender = widget.human.gender ? 'male' : 'female';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              child: ClipOval(
                                child: displayImage(),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: OutlinedButton(
                            onPressed: () {
                              takePhoto(context);
                            },
                            child: Text('Take Photo')),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  hintText: 'Enter your name',
                                  label: Text('Name')),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ' Please enter your name';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: icnoController,
                              readOnly: true,
                              decoration: InputDecoration(
                                  hintText: 'Enter your icno',
                                  label: Text('IC number')),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ' Please enter your icno';
                                } else if (value.length != 12 ||
                                    int.tryParse(value) == null) {
                                  return 'Please enter a valid ic number';
                                }
                                return null;
                              },
                            ),
                            // TextFormField(
                            //   controller: passwordController,
                            //   obscureText: true,
                            //   decoration: InputDecoration(
                            //       hintText: 'Enter your password',
                            //       label: Text('Password')),
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return ' Please enter your password';
                            //     } else if (value.length < 6) {
                            //       return 'Please enter a strong password';
                            //     }
                            //     return null;
                            //   },
                            // ),
                          ],
                        ),
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
                        height: 16,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3))),
                          onPressed: () {
                            submitForm();
                          },
                          child: Text("Update Data"))
                    ]))));
  }
}
