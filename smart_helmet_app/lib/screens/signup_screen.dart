import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_helmet_app/reusable_widgets/reusable_widget.dart';
import 'package:smart_helmet_app/screens/signin_screen.dart';
import 'package:smart_helmet_app/services/color_utils.dart';
import 'package:smart_helmet_app/screens/map_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_helmet_app/services/helper_class.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final databaseReference = FirebaseDatabase.instance.ref().child("users");
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _deviceIDTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              hexStringToColor("86EA87"),
              hexStringToColor("83CF77"),
              hexStringToColor("ACDFA4"),
              hexStringToColor("FFFFFF"),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 170, 20, 0),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                            "Name", Icons.person, false, _nameTextController),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                            "Email", Icons.email, false, _emailTextController),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField("Username", Icons.verified_user,
                            false, _usernameTextController),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField("Password", Icons.lock, true,
                            _passwordTextController),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField("Device ID", Icons.qr_code, false,
                            _deviceIDTextController),
                        signInSignUpButton(context, false, () {
                          addUser();
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text)
                              .then((value) {
                            print("Created New Account");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MapScreen()));
                          }).onError((error, stackTrace) {
                            print("Error ${error.toString()}");
                          });
                        }),
                        signInOption()
                      ],
                    )))));
  }

  void addUser() {
    String username = _usernameTextController.text;
    String email = _emailTextController.text;
    String device = _deviceIDTextController.text;

    HelperClass helperClass =
        HelperClass(email: email, username: username, device: device);
    databaseReference.child(username).set(helperClass.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have signed up successfully'),
      ),
    );
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already a User? ", style: TextStyle(color: Colors.black87)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignInScreen()));
          },
          child: const Text(
            "Sign In",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
