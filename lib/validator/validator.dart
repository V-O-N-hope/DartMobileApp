class Validator {
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Empty password";
    }
    if (password.length < 8) {
      return "Password length cannot be less than 8 characters";
    }
    if (password.length > 60) {
      return "Password length cannot be more than 60 characters";
    }
    return null;
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Email invalid!";
    }
    if (email.length > 80) {
      return "Email invalid!";
    }
    return null;
  }

  static String? validateName(String name) {
    if (name.isEmpty) {
      return "Name invalid";
    }
    if (name.length > 60) {
      return "Name invalid";
    }
    return null;
  }
}