import 'package:flutter/material.dart';
import 'package:overflow_text_animated/overflow_text_animated.dart';
import 'package:wsmb_day1_try2/models/human.dart';
import 'package:wsmb_day1_try2/pages/homePage.dart';
import 'package:wsmb_day1_try2/services/firestoreService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final icnoController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    icnoController.text = '012345678901';
    passwordController.text = '1223abbc';
    // checkLoginStatus();
  }

  // Future<void> checkLoginStatus() async {
  //   try {
  //     var token = await Human.getToken();
  //     Human human = await FirestoreService.getHuman(token);
  //     if (human != null) {
  //       Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (context) => HomePage(human: human)));
  //     }
  //   } catch (e) {
  //     return;
  //   }
  // }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      var human =
          await Human.login(icnoController.text, passwordController.text);
      if (human == null) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Warning'),
                  content: Text('Invalid Login'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'))
                  ],
                ));
      } else {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Login Successfully'),
                  actions: [
                    TextButton(
                        onPressed: () async{
                          Human? human = await Human.getHumanByToken();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomePage(human: human!)));
                        },
                        child: Text('OK'))
                  ],
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Login'),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.green),
            child: OverflowTextAnimated(
              text:
                  'Welcome Welcome WelcomeWelcome Welcome WelcomeWelcome Welcome WelcomeWelcome Welcome Welcome',
              style: TextStyle(fontSize: 25),
              animation: OverFlowTextAnimations.infiniteLoop,
              loopSpace: 30,
            ),
          ),
          Text('Welcome'),
          SizedBox(
            height: 40,
          ),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: icnoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(label: Text('IC number')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your ic number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(label: Text('Password')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3))),
              onPressed: () {
                login();
              },
              child: Text('Login'))
        ],
      ),
    );
  }
}
