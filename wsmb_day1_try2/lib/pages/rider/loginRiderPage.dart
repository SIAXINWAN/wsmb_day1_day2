import 'package:flutter/material.dart';
import 'package:overflow_text_animated/overflow_text_animated.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/models/rider.dart';
import 'package:wsmb_day1_try2/pages/homePage.dart';
import 'package:wsmb_day1_try2/pages/rider/homeRidePage.dart';
import 'package:wsmb_day1_try2/services/firestoreService.dart';

class LoginRidePage extends StatefulWidget {
  const LoginRidePage({super.key});

  @override
  State<LoginRidePage> createState() => _LoginRidePageState();
}

class _LoginRidePageState extends State<LoginRidePage> {
  final icnoController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> submitForm() async {
    if (formKey.currentState!.validate()) {
      var rider =
          await Rider.login(icnoController.text, passwordController.text);
      if (rider == null) {
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
        return;
      } else {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('You login successfully'),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomeRidePage()));
                        },
                        child: Text('OK'))
                  ],
                ));
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    icnoController.text = '012345678901';
    passwordController.text = '1223abbc';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   decoration: BoxDecoration(color: Colors.green),
            //   child: OverflowTextAnimated(
            //     text:
            //         'Welcome Welcome WelcomeWelcome Welcome WelcomeWelcome Welcome WelcomeWelcome Welcome Welcome',
            //     style: TextStyle(fontSize: 25),
            //     animation: OverFlowTextAnimations.infiniteLoop,
            //     loopSpace: 30,
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Rider',
              style: TextStyle(fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: icnoController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              label: Text('IC No'),
                              hintText: 'Enter you ic number',
                              suffixIcon: icnoController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        icnoController.clear();
                                      },
                                      icon: Icon(Icons.clear))
                                  : null),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your ic number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              label: Text('Password'),
                              hintText: 'Enter you password',
                              suffixIcon: passwordController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        passwordController.clear();
                                      },
                                      icon: Icon(Icons.clear))
                                  : null),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              submitForm();
                            },
                            child: Text('Login'))
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
