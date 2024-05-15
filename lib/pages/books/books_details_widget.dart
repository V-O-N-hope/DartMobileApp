import 'package:books/models/book.dart';
import 'package:books/services/FirebaseAuthService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class BookDetailsPage extends StatefulWidget {
  final Book book;
  final int mode;
  const BookDetailsPage({Key? key, required this.book, required this.mode});

  @override
  State<BookDetailsPage> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetailsPage> {
  List<String> imgUrls = [];
  int currentIndex = 0; // Индекс текущего изображения
  bool load = true;

  @override
  void initState() {
    super.initState();
    load = true;
    imgUrls = [];
  }

  @override
  void dispose() {
    super.dispose();
    imgUrls = [];
  }

  void loadImgUrls() async {
    final ref = FirebaseStorage.instance.ref('images/${widget.book.name}/');
    final result = await ref.listAll();

    imgUrls.clear();

    for (var item in result.items) {
      String fileName = item.name.split('/').last;
      if (fileName.endsWith('.jpg') ||
          fileName.endsWith('.jpeg') ||
          fileName.endsWith('.png')) {
        final url = await item.getDownloadURL();
        imgUrls.add(url);
      }
    }

    setState(() {
      load = false;
    });
  }

  void addToPref() async {
    var uid = FirebaseAuthService().getCurrentUser()!.uid;
    String bookName = widget.book.name; // Имя текущей книги

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

    if (widget.mode == 1) {
      stringList.remove(bookName);
      // удаляем имя книги в список предпочтений

      DatabaseReference prefsRef =
          FirebaseDatabase.instance.ref().child("prefs/$uid");

      // Обновляем данные в базе данных
      await prefsRef.set(stringList);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('removed from to preferences'),
        ),
      );
    } else if (!stringList.contains(bookName)) {
      // Книги с таким именем нет в списке, добавляем
      DatabaseReference prefsRef =
          FirebaseDatabase.instance.ref().child("prefs/$uid");

      // Добавляем имя книги в список предпочтений
      stringList.add(bookName);

      // Обновляем данные в базе данных
      await prefsRef.set(stringList);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to preferences'),
        ),
      );
    } else {
      // Книга уже есть в списке, показываем сообщение об этом
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This book is already in your preferences'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (load) {
      loadImgUrls();
    }
    return load
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text('Book Details'),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Title: ${widget.book.name}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Author: ${widget.book.author}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0,
                    children: widget.book.tags
                        .map((tag) =>
                            Chip(label: Text(tag.toString().split('.')[1])))
                        .toList(),
                  ),
                ),
                imgUrls.isEmpty
                    ? Text('No entries')
                    : Expanded(
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Image.network(imgUrls[currentIndex]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () {
                                    setState(() {
                                      currentIndex -= 1;
                                      if (currentIndex < 0) {
                                        currentIndex = imgUrls.length - 1;
                                      }
                                      print(currentIndex);
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                  onPressed: () {
                                    setState(() {
                                      currentIndex += 1;
                                      if (currentIndex > imgUrls.length - 1) {
                                        currentIndex = 0;
                                      }
                                      print(currentIndex);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                ElevatedButton(
                  onPressed: addToPref,
                  child: Text(
                      widget.mode == 0 ? 'Add to pref' : "Remove from pref"),
                ),
              ],
            ),
          );
  }
}
