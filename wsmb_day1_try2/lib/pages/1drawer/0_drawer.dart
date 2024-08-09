import 'package:flutter/material.dart';
import 'package:overflow_text_animated/overflow_text_animated.dart';
import 'package:wsmb_day1_try2/pages/1drawer/1_addVehicle.dart';
import 'package:wsmb_day1_try2/pages/1drawer/2_showVehicle.dart';
import 'package:wsmb_day1_try2/pages/1drawer/3_editVehicle.dart';
import 'package:wsmb_day1_try2/pages/1drawer/4_anotherPage.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  Widget? content;
  String title = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Appbar')),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Menu')),
            ListTile(
              title: Text('Add Vehicle'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  content = AddVehiclePage();
                  title = "Add Vehicle";
                });
              },
            ),
            ListTile(
              title: Text('See Vehicle'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  content = ShowVehiclePage();
                  title = "Show Vehicle";
                });
              },
            ),
            ListTile(
              title: Text('Edit Vehicle'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  content = EditvehiclePage();
                  title = "Add Vehicle";
                });
              },
            ),
            ListTile(
              title: Text('Another Vehicle'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  content = AnotherPage();
                  title = "Add Vehicle";
                });
              },
            ),
          ],
        ),
      ),
      body: (content == null)
          ? Center(
              child: Text(
              'Welcome\nChoose the drawer',
              textAlign: TextAlign.center,
            ))
          : content,
      bottomNavigationBar: ElevatedButton(
          style:
              ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Return')),
    );
  }
}
