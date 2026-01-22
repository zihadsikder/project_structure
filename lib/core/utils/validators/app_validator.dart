class AppValidator {
  AppValidator._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }

    final emailRegExp = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Invalid email address.';
    }

    return null;
  }
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required.';
    }
    final trimmedValue = value.trim();
    if (trimmedValue.length < 2) {
      return 'Name must be at least 2 characters.';
    }
    // Allow letters, spaces, hyphens, and apostrophes (for names like O'Connor, Mary-Jane)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(trimmedValue)) {
      return 'Name should only contain letters.';
    }
    return null;
  }
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required.';
    }

    final trimmed = value.trim();

    if (trimmed.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    if (!trimmed.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    if (!trimmed.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    if (!trimmed.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }

    final phoneRegExp = RegExp(r'^\d{10}$');
    if (!phoneRegExp.hasMatch(value.trim())) {
      return 'Invalid phone number (must be 10 digits).';
    }

    return null;
  }
}
