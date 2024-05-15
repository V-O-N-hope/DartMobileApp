import 'package:books/pages/auth/login_page.dart';
import 'package:books/pages/books/books_page.dart';
import 'package:books/pages/profile/favourites_page.dart';
import 'package:books/pages/profile/profile_page.dart';
import 'package:books/services/FirebaseAuthService.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  int _currentIndex = 0;

  final List<Widget> _body = const [
    BooksPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: _authService.getCurrentUser() == null
          ? const LoginPage()
          : Scaffold(
            body: Container(
              child: _body[_currentIndex],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.blue,
              currentIndex: _currentIndex,
              onTap: (int newIndex) {
                setState(() {
                  _currentIndex = newIndex;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  label: "Available Books",
                  icon: Icon(Icons.book),
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  label: "Preferred Books",
                  icon: Icon(Icons.bookmark_add_outlined),
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  label: "User Profile",
                  icon: Icon(Icons.person_2_outlined),
                )
              ],
            ),
          )
      );
  }
}
