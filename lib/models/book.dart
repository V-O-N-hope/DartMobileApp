// ignore_for_file: constant_identifier_names

import 'dart:convert';

enum Tag {
  FICTION,
  THRILLER,
  ROMANCE,
  FANTASY,
  SCIENCE_FICTION,
  CLASSICS,
  DYSTOPIA,
  RACISM,
  ADVENTURE,
  COMING_OF_AGE,
  MAGIC,
  PSYCHOLOGICAL,
  SURVIVAL,
  SPIRITUAL,
  MAGICAL_REALISM,
  HISTORICAL_FICTION,
  GOTHIC,
  WAR,
  CONTEMPORARY,
  YOUNG_ADULT,
  HORROR,
  FEMINISM,
  MYSTERY
}

class Book {
  final String name;
  final String author;
  final List<Tag> tags;

  Book({required this.name, required this.author, required this.tags});

  String toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'author': author,
      'tags': tags.map((tag) => tag.toString().split('.').last).toList(),
    };
    return jsonEncode(data);
  }

  factory Book.fromJson(String jsonString) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    final List<Tag> tags = (data['tags'] as List<dynamic>)
        .map((tag) => Tag.values.firstWhere(
              (value) => value.toString().split('.').last == tag,
            ))
        .toList();

    return Book(
      name: data['name'],
      author: data['author'],
      tags: tags,
    );
  }
}

