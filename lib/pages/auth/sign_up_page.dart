import 'package:books/models/user.dart';
import 'package:books/models/user_convertor.dart';
import 'package:books/pages/home_page.dart';
import 'package:books/pages/auth/login_page.dart';
import 'package:books/services/FirebaseAuthService.dart';
import 'package:books/validator/validator.dart';
import 'package:books/widgets/input_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Registration",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
          InputWidget(
            controller: _emailController,
            hintText: "Email",
            isPasswordField: false,
          ),
          const SizedBox(
            height: 20,
          ),
          InputWidget(
            controller: _nameController,
            hintText: "Name",
            isPasswordField: false,
          ),
          const SizedBox(
            height: 20,
          ),
          InputWidget(
            controller: _passwordController,
            hintText: "Password",
            isPasswordField: true,
            validator: (value) => Validator.validatePassword(value),
          ),
          const SizedBox(
            height: 20,
          ),
          InputWidget(
            controller: _rePasswordController,
            hintText: "Re-password",
            isPasswordField: true,
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
              onTap: _signUp,
              child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                      child: Text("Sign up",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17))))),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false);
                },
                child: const Text("Already have an account? Login",
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 17)),
              )
            ],
          ),
        ],
      ),
    )));
  }

  void _signUp() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String rePassword = _rePasswordController.text;

    if (_validateFields(email, password, rePassword, name)) {
      UserCredential? fbCredit =
          await _auth.signUpWithEmailAndPassword(email, password);

      if (fbCredit != null) {
        if (fbCredit.user != null) {
          var fbUser = fbCredit.user;

          MyUser user = MyUser(name, email, "", "", "", "", "", "", 10, "free");

          var db = FirebaseDatabase.instance.ref("users/${fbUser!.uid}");

          await db.set(UserConverter.toJson(user));

          db = FirebaseDatabase.instance.ref("prefs/${fbUser.uid}");
          List<String> myList = [];

          await db.set(myList);
          Navigator.pushAndRemoveUntil(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false);
        }
      }
    }
  }

  bool _validateFields(
      String email, String password, String rePassword, String name) {
    String? result = Validator.validateEmail(email);
    if (result != null) {
      Fluttertoast.showToast(
          msg: result,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    result = Validator.validateName(name);
    if (result != null) {
      Fluttertoast.showToast(
          msg: result,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }

    result = Validator.validatePassword(password);
    if (result != null) {
      Fluttertoast.showToast(
          msg: result,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }

    if (rePassword != password) {
      Fluttertoast.showToast(
          msg: "Passwords are not the same",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    return true;
  }
}
