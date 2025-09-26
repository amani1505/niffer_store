class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  static String? phoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }
    
    final phoneRegex = RegExp(r'^\+?[\d\s-()]+$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    
    final price = double.tryParse(value.trim());
    if (price == null || price < 0) {
      return 'Please enter a valid price';
    }
    
    return null;
  }

  static String? quantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }
    
    final quantity = int.tryParse(value.trim());
    if (quantity == null || quantity < 0) {
      return 'Please enter a valid quantity';
    }
    
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }
    
    final urlRegex = RegExp(r'^https?://');
    if (!urlRegex.hasMatch(value.trim())) {
      return 'Please enter a valid URL starting with http:// or https://';
    }
    
    return null;
  }
}
