import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/pages/2bottom/editTab.dart';
import 'package:wsmb_day1_try2/pages/2bottom/humanTab.dart';
import 'package:wsmb_day1_try2/pages/edit/editProfile.dart';
import 'package:wsmb_day1_try2/pages/seePhoto.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key, required this.human});
  final Human human;

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  late List<Widget> tabs;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [HumanTab(human: widget.human), EditTab(human: widget.human)];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bottom Navigation'),
        ),
        body: IndexedStack(
          children: tabs,
          index: currentIndex,
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'See Human'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.edit), label: 'Edit Profile'),
            ]),
      ),
    );
  }
}
