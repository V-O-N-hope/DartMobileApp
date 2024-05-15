import 'package:books/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class UserConverter {
  static MyUser fromSnapshot(DataSnapshot snapshot) {
    Map<String?, dynamic> data = {};

    for (var child in snapshot.children) {
      data[child.key] = child.value;
    }

    String name = data.containsKey('name') ? data['name'] as String : '';
    String email = data.containsKey('email') ? data['email'] as String : '';
    String dateOfBirth =
        data.containsKey('dateOfBirth') ? data['dateOfBirth'] as String : '';
    String gender = data.containsKey('gender') ? data['gender'] as String : '';
    String occupation =
        data.containsKey('occupation') ? data['occupation'] as String : '';
    String city = data.containsKey('city') ? data['city'] as String : '';
    String country =
        data.containsKey('country') ? data['country'] as String : '';
    String phoneNumber =
        data.containsKey('phoneNumber') ? data['phoneNumber'] as String : '';
    int age = data.containsKey('age') ? data['age'] as int : 0;
    String maritalStatus = data.containsKey('maritalStatus')
        ? data['maritalStatus'] as String
        : '';

    return MyUser(
      name,
      email,
      dateOfBirth,
      gender,
      occupation,
      city,
      country,
      phoneNumber,
      age,
      maritalStatus,
    );
  }

  static Map<String, dynamic> toJson(MyUser user) {
    return {
      "name": user.name,
      "email": user.email,
      "dateOfBirth": user.dateOfBirth,
      "gender": user.gender,
      "occupation": user.occupation,
      "city": user.city,
      "country": user.country,
      "phoneNumber": user.phoneNumber,
      "age": user.age,
      "maritalStatus": user.maritalStatus,
    };
  }
}
