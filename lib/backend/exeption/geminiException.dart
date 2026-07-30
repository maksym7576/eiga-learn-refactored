import 'AiUserFacingError.dart';

abstract class GeminiException implements Exception {
  final String message;
  GeminiException(this.message);

  AiErrorType get type;

  @override
  String toString() => message;
}

class GeminiModelExpiredException extends GeminiException {
  GeminiModelExpiredException(String message) : super(message);
  @override
  AiErrorType get type => AiErrorType.rateLimit;
}

class GeminiIncorrectTokenException extends GeminiException {
  GeminiIncorrectTokenException(String message) : super(message);
  @override
  AiErrorType get type => AiErrorType.auth;
}

class GeminiGeneralException extends GeminiException {
  GeminiGeneralException(String message) : super(message);
  @override
  AiErrorType get type => AiErrorType.unknown;
}

class GeminiServerException extends GeminiException {
  GeminiServerException(String message) : super(message);
  @override
  AiErrorType get type => AiErrorType.server;
}