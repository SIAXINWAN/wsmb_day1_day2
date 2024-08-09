import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/pages/firstPage.dart';
import 'package:wsmb_day1_try2/pages/takePhoto.dart';
import 'package:wsmb_day1_try2/widgets/editCard.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.human});
  final Human human;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Future<void> logout() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Log Out'),
              content: Text("Do you wan tot log out?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok')),
                TextButton(
                    onPressed: () async {
                      await Human.signOut();
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FirstPage()));
                    },
                    child: Text('Ok')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Out'),
      ),
      body: Column(
        children: [
          EditCard(human: widget.human),
          Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3))),
                  onPressed: () {
                    logout();
                  },
                  child: Text('Log Out')))
        ],
      ),
    );
  }
}
