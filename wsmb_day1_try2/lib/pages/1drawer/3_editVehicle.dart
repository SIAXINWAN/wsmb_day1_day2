import 'package:flutter/material.dart';

class EditvehiclePage extends StatefulWidget {
  const EditvehiclePage({super.key});

  @override
  State<EditvehiclePage> createState() => _EditvehiclePageState();
}

class _EditvehiclePageState extends State<EditvehiclePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: SafeArea(
          child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Edit Vehicle',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            ),
          )
        ],
      )),
    );
  }
}
