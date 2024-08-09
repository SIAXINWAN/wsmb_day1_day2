import 'package:flutter/material.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/pages/2bottom/bottomNavigation.dart';
import 'package:wsmb_day1_try2/pages/1drawer/0_drawer.dart';
import 'package:wsmb_day1_try2/pages/3top/topNavigation.dart';
import 'package:wsmb_day1_try2/pages/4ride/ridePage.dart';
import 'package:wsmb_day1_try2/pages/edit/editProfile.dart';
import 'package:wsmb_day1_try2/pages/firstPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.human});
  final Human human;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool status = false;
  final List<String> _methods = ['Good', 'Expert', 'Bad', 'Worst'];
  String? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Usaha Anda'),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        EditProfilePage(human: widget.human)));
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.human.image.toString()),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DrawerPage()));
                },
                child: Text('Drawer'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          BottomNavigationPage(human: widget.human)));
                },
                child: Text('Bottom Navigation'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          TopNavigationPage(human: widget.human)));
                },
                child: Text('Top Navigation'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RidePage()));
                },
                child: Text('Ride'),
              ),
              SizedBox(height: 20),
              Divider(height: 1),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Test Check Box'),
                  Checkbox(
                    value: status,
                    onChanged: (bool? value) {
                      setState(() {
                        status = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Choose',
                  border: OutlineInputBorder(),
                ),
                value: _selectedMethod,
                items: _methods.map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMethod = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => FirstPage()));
          },
          child: Text('First Page')),
    );
  }
}
