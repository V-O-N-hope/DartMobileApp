import 'package:books/models/book.dart';
import 'package:books/pages/books/books_details_widget.dart';
import 'package:books/services/FirebaseAuthService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  var db = FirebaseDatabase.instance.ref().child("books");
  final FirebaseAuthService _authService = FirebaseAuthService();

  List<Book> books = [];
  List<Book> filteredBooks = [];
  Book? selectedBook;

  void any() async {
    var uid = FirebaseAuthService().getCurrentUser()!.uid;

    DataSnapshot prefsSnapshot =
        await FirebaseDatabase.instance.ref().child("prefs/$uid").get();

    List<String> stringList = [];

    // Проверяем, есть ли данные в prefsSnapshot
    if (prefsSnapshot.exists) {
      // Преобразуем данные в список строк
      List<dynamic> data = prefsSnapshot.value as List<dynamic>;

      // Проверяем, не пуст ли результат
      if (data != null) {
        // Конвертируем данные в список строк
        stringList = List<String>.from(data);
      }
    }

    DataSnapshot snapshot =
        await FirebaseDatabase.instance.ref().child("books").get();
    List<Book> localBooks = [];

    for (var child in snapshot.children) {
      Map<dynamic, dynamic> values = child.value as Map<dynamic, dynamic>;

      if (values.containsKey('name') &&
          values.containsKey('author') &&
          values.containsKey('tags')) {
        String name = values['name'];
        String author = values['author'];
        List<Tag> tags = (values['tags'] as List<dynamic>)
            .map((tag) => Tag.values.firstWhere(
                  (value) => value.toString().split('.').last == tag,
                ))
            .toList();

        Book book = Book(name: name, author: author, tags: tags);

        for (var element in stringList) {
          if (book.name == element){
            localBooks.add(book);
            break;    
          }
        }
        
      }
    }

    setState(() {
      books = localBooks;
      filteredBooks = localBooks; // Инициализация filteredBooks
    });
  }

  ListView listView() {
    List<Book> displayedBooks = searchController.text.isEmpty
        ? books
        : books
            .where((book) => book.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: displayedBooks.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(displayedBooks[index].name),
          onTap: () {
            setState(() {
              selectedBook = displayedBooks[index];
            });
          },
        );
      },
    );
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    any();

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: filteredBooks.isEmpty
                        ? Text('No positions fetched')
                        : listView(),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: selectedBook == null
                        ? Text('None of books were selected')
                        : new BookDetailsPage(book: selectedBook!, mode: 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
