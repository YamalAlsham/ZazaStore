class CreateUserModelError {
  dynamic message;

  CreateUserModelError.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}