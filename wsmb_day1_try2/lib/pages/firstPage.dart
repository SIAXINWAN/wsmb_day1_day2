import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/pages/rider/registerRider.dart';
import 'package:wsmb_day1_try2/pages/takePhoto.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool isChecked = false;
  bool isOkay = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Choose Your Role'),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              }),
          isChecked
              ? Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TakePhotoPage()));
                      },
                      child: Text('Human')),
                )
              : Container(),
          Text('Or else'),
          Checkbox(
              value: isOkay,
              onChanged: (bool? value) {
                setState(() {
                  isOkay = value!;
                });
              }),
          isOkay
              ? ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterRider()));
                  },
                  child: Text('Rider'))
              : Container()
        ],
      )),
    );
  }
}
