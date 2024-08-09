import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/pages/homePage.dart';
import 'package:wsmb_day1_try2/pages/loginPage.dart';

import 'package:wsmb_day1_try2/widgets/photoCard.dart';

class SeePhotoPage extends StatefulWidget {
  const SeePhotoPage({super.key, required this.human});
  final Human human;

  @override
  State<SeePhotoPage> createState() => _SeePhotoPageState();
}

class _SeePhotoPageState extends State<SeePhotoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightGreenAccent,
        title: Text('Nikmatilah Hasil Anda'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text('Hasilnya'),
                SizedBox(
                  height: 20,
                ),
                PhotoCard(human: widget.human),
                SizedBox(
                  height: 40,
                ),
                OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text('Welcome'))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Take Photo')),
    );
  }
}
