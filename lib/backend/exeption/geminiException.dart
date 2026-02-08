class GeminiModelExpiredException implements Exception {
  final String message;
  GeminiModelExpiredException(this.message);
}

class GeminiIncorrectTokenException implements Exception {
  final String message;
  GeminiIncorrectTokenException(this.message);
}

class GeminiGeneralException implements Exception {
  final String message;
  GeminiGeneralException(this.message);
}

class GeminiServerException implements Exception {
  final String message;
  GeminiServerException(this.message);
}

