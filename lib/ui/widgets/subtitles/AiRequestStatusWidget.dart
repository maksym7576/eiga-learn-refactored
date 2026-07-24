import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// Вкажи правильний шлях до свого провайдера
import 'package:eiga/providers/AIRequestStatusProvider.dart';

class AiRequestStatusWidget extends ConsumerWidget {
  const AiRequestStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiState = ref.watch(aiRequestStatusProvider);

    if (aiState.status == AiRequestStatus.idle) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Немає активних запитів'),
      );
    }

    String statusText;
    switch (aiState.status) {
      case AiRequestStatus.preparing:
        statusText = 'Підготовка...';
        break;
      case AiRequestStatus.sending:
        statusText = 'Відправка...';
        break;
      case AiRequestStatus.waitingResponse:
        statusText = 'Очікування відповіді...';
        break;
      case AiRequestStatus.streamingResponse:
        statusText = 'Отримання перекладу...';
        break;
      case AiRequestStatus.success:
        statusText = 'Переклад завершено';
        break;
      case AiRequestStatus.error:
        statusText = 'Помилка: ${aiState.errorMessage}';
        break;
      default:
        statusText = '';
    }

    final isError = aiState.hasError;
    final isSuccess = aiState.isSuccess;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isError
            ? Colors.redAccent.withOpacity(0.1)
            : isSuccess
            ? Colors.green.withOpacity(0.1)
            : Colors.deepPurpleAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError
              ? Colors.redAccent
              : isSuccess
              ? Colors.green
              : Colors.deepPurpleAccent,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (aiState.isRunning) ...[
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 16,
                    color: isError
                        ? Colors.redAccent
                        : isSuccess
                        ? Colors.green
                        : Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (aiState.itemsTotal != null && aiState.itemsTotal! > 0) ...[
            const SizedBox(height: 12),
            Text(
              'Прогрес: ${aiState.itemsProcessed} / ${aiState.itemsTotal}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: aiState.progress,
              color: Colors.deepPurpleAccent,
              backgroundColor: Colors.deepPurpleAccent.withOpacity(0.2),
            ),
          ],
        ],
      ),
    );
  }
}

// Функція для виклику віджета як BottomSheet
void showAiStatusBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => const SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: AiRequestStatusWidget(),
      ),
    ),
  );
}

// Функція для виклику віджета як Dialog
void showAiStatusDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: AiRequestStatusWidget(),
      ),
    ),
  );
}