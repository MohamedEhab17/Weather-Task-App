String? validateRequired(String? value, {String fieldName = "This field"}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }
  return null;
}
