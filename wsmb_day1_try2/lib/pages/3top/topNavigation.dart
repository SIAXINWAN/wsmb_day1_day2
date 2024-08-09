import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/pages/3top/tabEdit.dart';
import 'package:wsmb_day1_try2/pages/3top/tabSee.dart';
import 'package:wsmb_day1_try2/pages/edit/editProfile.dart';
import 'package:wsmb_day1_try2/pages/seePhoto.dart';

class TopNavigationPage extends StatefulWidget {
  const TopNavigationPage({Key? key, required this.human}) : super(key: key);
  final Human human;

  @override
  State<TopNavigationPage> createState() => _TopNavigationPageState();
}

class _TopNavigationPageState extends State<TopNavigationPage> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      TabSeePage(human: widget.human),
      TabEdit(human: widget.human),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Top Navigation'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: TabBar(
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              tabs: [
                Tab(icon: Icon(Icons.person), text: 'See Human'),
                Tab(icon: Icon(Icons.edit), text: 'Edit Profile'),
              ],
            ),
          ),
        ),
        body: _pages[_currentIndex],
      ),
    );
  }
}
