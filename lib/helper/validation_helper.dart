class ValidationHelper {
  static dynamic validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Enter a valid email address, using format';
    } else {
      return null;
    }
  }

  static dynamic validatePassowrd(String? value) {
    String pattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{3,}$";

    RegExp regex = RegExp(pattern);

    if (value!.length < 3) {
      return 'Min 3 characters';
    }

    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Min 3 chars, min one letter and one number';
    } else {
      return null;
    }
  }

  static dynamic validateUsername(String? value) {
    String pattern =
        r"^(?=.{3,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$";

    RegExp regex = RegExp(pattern);

    if (value!.length < 3) {
      return 'Min 3 characters';
    }

    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Enter a valid username';
    } else {
      return null;
    }
  }
}
