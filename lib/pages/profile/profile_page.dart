import 'package:books/models/user.dart';
import 'package:books/models/user_convertor.dart';
import 'package:books/pages/auth/login_page.dart';
import 'package:books/services/FirebaseAuthService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _maritalStatusController = TextEditingController();

  MyUser _user = MyUser.empty();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _dateOfBirthController.text = _user.dateOfBirth;
    _genderController.text = _user.gender;
    _occupationController.text = _user.occupation;
    _cityController.text = _user.city;
    _countryController.text = _user.country;
    _phoneNumberController.text = _user.phoneNumber;
    _ageController.text = _user.age.toString();
    _maritalStatusController.text = _user.maritalStatus;
  }

  void _editUserOnPressed() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveUserOnPressed() async {
    var fbUser = _auth.getCurrentUser();
    if (fbUser != null) {
      _user = MyUser(
        _user.name,
        _user.email,
        _dateOfBirthController.text,
        _genderController.text,
        _occupationController.text,
        _cityController.text,
        _countryController.text,
        _phoneNumberController.text,
        int.tryParse(_ageController.text) ?? 10,
        _maritalStatusController.text,
      );

      var db = FirebaseDatabase.instance.ref("users/${fbUser.uid}");
      await db.set(UserConverter.toJson(_user));
      setState(() {
        _isEditing = false;
      });
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  void _loadUserInfo() async {
    var fbUser = _auth.getCurrentUser();
    if (fbUser != null) {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child("users/${fbUser.uid}").get();
      if (snapshot.exists) {
        setState(() {
          _user = UserConverter.fromSnapshot(snapshot);
        });
      } else {
        String email = fbUser.email ?? "no";
        MyUser user =
            MyUser("temp name", email, "", "", "", "", "", "", 10, "free");
        var db = FirebaseDatabase.instance.ref("users/${fbUser.uid}");

        await db.set(UserConverter.toJson(user));

        _loadUserInfo();
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  void _signOutOnPressed() {
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
  }

  void _deleteUserOnPressed() async {
    _auth.deleteUser();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    _loadUserInfo();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            color: Colors.black,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  "User Profile",
                  style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
                ),
                if (_isEditing)
                  IconButton(
                    icon: const Icon(
                      Icons.save,
                      color: Colors.purple,
                    ),
                    onPressed: _saveUserOnPressed,
                  )
                else
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.purple,
                    ),
                    onPressed: _editUserOnPressed,
                  ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.logout_outlined,
                    color: Colors.purple,
                  ),
                  onPressed: _signOutOnPressed,
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.purple,
                  ),
                  onPressed: _deleteUserOnPressed,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white12,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Name"),
                  Text(
                    _user.name,
                    style: const TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Email"),
                  Text(
                    _user.email,
                    style: const TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Date of birth"),
                  if (_isEditing)
                    TextField(
                      controller: _dateOfBirthController,
                      style: const TextStyle(fontSize: 17),
                    )
                  else
                    Text(
                      _user.dateOfBirth,
                      style: const TextStyle(fontSize: 17),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Gender"),
                  if (_isEditing)
                    TextField(
                      controller: _genderController,
                      style: const TextStyle(fontSize: 17),
                    )
                  else
                    Text(
                      _user.gender,
                      style: const TextStyle(fontSize: 17),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Occupation"),
                  if (_isEditing)
                    TextField(
                      controller: _occupationController,
                      style: const TextStyle(fontSize: 17),
                    )
                  else
                    Text(
                      _user.occupation,
                      style: const TextStyle(fontSize: 17),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("City"),
                  if (_isEditing)
                    TextField(
                      controller: _cityController,
                      style: const TextStyle(fontSize: 17),
                    )
                  else
                    Text(
                      _user.city,
                      style: const TextStyle(fontSize: 17),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Country"),
                  if (_isEditing)
                    TextField(
                      controller: _countryController,
                      style: const TextStyle(fontSize: 17),
                    )
                  else
                    Text(
                      _user.country,
                      style: const TextStyle(fontSize: 17),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Phone Number"),
                  if (_isEditing)
                    TextField(
                      controller: _phoneNumberController,
                      style: const TextStyle(fontSize: 17),
                    )
                  else
                    Text(
                      _user.phoneNumber,
                      style: const TextStyle(fontSize: 17),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Age"),
                  if (_isEditing)
                    TextField(
                      controller: _ageController,
                      style: const TextStyle(fontSize: 17),
                    )
                  else
                    Text(
                      _user.age.toString(),
                      style: const TextStyle(fontSize: 17),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Martial status"),
                  if (_isEditing)
                    TextField(
                      controller: _maritalStatusController,
                      style: const TextStyle(fontSize: 17),
                    )
                  else
                    Text(
                      _user.maritalStatus,
                      style: const TextStyle(fontSize: 17),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
