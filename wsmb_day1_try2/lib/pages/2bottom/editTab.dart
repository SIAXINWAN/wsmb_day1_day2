import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/pages/edit/editProfile.dart';

class EditTab extends StatelessWidget {
  const EditTab({super.key, required this.human});
  final Human human;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (context) => EditProfilePage(human: human));
      },
    );
  }
}
