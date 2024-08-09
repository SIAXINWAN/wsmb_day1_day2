import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wsmb_day1_try2/models/vehicle.dart';
import 'package:wsmb_day1_try2/widgets/bottomSheet.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final modelController = TextEditingController();
  final capacityController = TextEditingController();
  final featureController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  File? image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    featureController.text = 'None';
    modelController.text = 'Myvi';
    capacityController.text = '4';
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

  void submitForm() async {
    if (formKey.currentState!.validate()) {
      var res = await Vehicle.register(modelController.text,
          int.parse(capacityController.text), featureController.text, image);
      if (res) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Your vehicle is added successfully'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'))
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
                        child: Text('OK'))
                  ],
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicle Information"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: modelController,
                    decoration: InputDecoration(
                        label: Text('Car Model'), hintText: 'Enter car model'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your car model';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: capacityController,
                    decoration: InputDecoration(
                        label: Text('Capacity'), hintText: 'Enter capacity'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your capacity';
                      } else if (int.tryParse(value) == null) {
                        return 'Please enter a valid car capacity';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: featureController,
                    decoration: InputDecoration(
                        label: Text('Special Features'),
                        hintText: 'Enter car special feature'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your car special features';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  (image != null)
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(image!),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            takePhoto(context);
                          },
                          child: Text('Take Photo')),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        submitForm();
                      },
                      child: Text('Submit'))
                ],
              )),
        ),
      ),
    );
  }
}
