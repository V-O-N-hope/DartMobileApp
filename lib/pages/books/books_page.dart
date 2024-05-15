import 'package:books/models/book.dart';
import 'package:books/pages/books/books_details_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({Key? key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  var db = FirebaseDatabase.instance.ref().child("books");

  List<Book> books = [];
  List<Book> filteredBooks = [];
  Book? selectedBook;

  void any() async {
    DataSnapshot snapshot = await db.get();
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
        localBooks.add(book);
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
                        : new BookDetailsPage(book: selectedBook!, mode: 0),
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
