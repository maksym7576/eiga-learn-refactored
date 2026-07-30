
enum AiErrorType { auth, rateLimit, server, parse, unknown }

class AiUserFacingError {
  final String title;
  final String message;
  final String instruction;

  const AiUserFacingError({
    required this.title,
    required this.message,
    required this.instruction,
  });
}


extension AiErrorTypeUiMapper on AiErrorType {
  AiUserFacingError toUserFacing() {
    switch (this) {
      case AiErrorType.auth:
        return const AiUserFacingError(
          title: 'Проблема з токеном',
          message: 'API-ключ невірний, протермінований або запит сформований неправильно.',
          instruction: 'Відкрий налаштування і встав дійсний ключ з Google AI Studio.',
        );
      case AiErrorType.rateLimit:
        return const AiUserFacingError(
          title: 'Перевищено ліміт запитів',
          message: 'Забагато запитів або вичерпана квота для обраної моделі.',
          instruction: 'Зачекай кілька хвилин або зміни модель у налаштуваннях.',
        );
      case AiErrorType.server:
        return const AiUserFacingError(
          title: 'Сервер Gemini недоступний',
          message: 'Тимчасова проблема на боці Google.',
          instruction: 'Спробуй повторити запит через хвилину-дві.',
        );
        default:
        return const AiUserFacingError(
          title: 'Невідома помилка',
          message: 'Сталося щось непередбачене під час запиту.',
          instruction: 'Спробуй ще раз. Якщо повторюється — перезапусти застосунок.',
        );
    }
  }
}

/// Коли частина фраз не оброблена, а не весь запит впав.
class PartialFailureInfo {
  final List<String> failedPhraseIds;
  const PartialFailureInfo(this.failedPhraseIds);

  AiUserFacingError toUserFacing() => AiUserFacingError(
    title: 'Не всі фрази оброблено',
    message: 'Не вдалося обробити ${failedPhraseIds.length} фраз(и) з відповіді.',
    instruction: 'Можеш повторити запит пізніше лише для цих фраз.',
  );
}