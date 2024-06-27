class AppException implements Exception {
  final String message;
  final Exception? innerException;

  AppException({required this.message, this.innerException});

  factory AppException.unknown() => AppException(message: "Unknown Error");

  @override
  String toString() {
    return 'AppException{message: $message, innerException: $innerException}';
  }
}
