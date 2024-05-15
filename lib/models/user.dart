class MyUser{
  String name = "";
  String email = "";
  String dateOfBirth = "";
  String gender = "";
  String occupation = "";
  String city = "";
  String country = "";
  String phoneNumber = "";
  int age = 10;
  String maritalStatus = "";

  MyUser(
    this.name,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.occupation,
    this.city,
    this.country,
    this.phoneNumber,
    this.age,
    this.maritalStatus,
  );

  MyUser.empty();
}