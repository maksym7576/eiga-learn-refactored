import 'package:eiga/backend/data/dto/AiModelSettingsDTO.dart';
import 'package:flutter/material.dart';

import '../../../config/modelsUrl/aiModelManager.dart';

class AiModelsSettingsWidget extends StatefulWidget {
  const AiModelsSettingsWidget({super.key});

  @override
  State<AiModelsSettingsWidget> createState() =>
      _AiModelsSettingsWidgetState();
}

class _AiModelsSettingsWidgetState extends State<AiModelsSettingsWidget> {
  final AiModelManager _manager = AiModelManager();

  Future<List<AiModelSettingsDTO>>? _future;
  String? _currentName;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      _future = _manager.getAllModelsData();
    });
    _manager.getCurrentModelName().then((name) {
      if (mounted) setState(() => _currentName = name);
    });
  }

  Future<void> _selectModel(String name) async {
    await _manager.setCurrentModel(name);
    _reload();
  }

  Future<void> _openEditDialog(AiModelSettingsDTO model) async {
    final maxLimitController =
    TextEditingController(text: model.currentMaxLimit.toString());
    final phrasesController =
    TextEditingController(text: model.currentPhrasesPerRequest.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple[50],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            model.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: maxLimitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Ліміт запитів',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phrasesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Фраз за один запит',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                final newLimit = int.tryParse(maxLimitController.text.trim());
                final newPhrases =
                int.tryParse(phrasesController.text.trim());

                if (newLimit != null) {
                  await _manager.setMaxLimit(model.name, newLimit);
                }
                if (newPhrases != null) {
                  await _manager.setPhrasesPerRequest(
                    model.name,
                    newPhrases,
                  );
                }

                if (context.mounted) Navigator.of(context).pop();
                _reload();
              },
              child: const Text('Зберегти'),
            ),
          ],
        );
      },
    );
  }

  Widget _modelTile(AiModelSettingsDTO model) {
    final bool isCurrent = model.name == _currentName;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isCurrent
            ? Colors.deepPurpleAccent.withValues(alpha: 0.08)
            : Colors.white,
        border: Border.all(
          color: isCurrent
              ? Colors.deepPurpleAccent
              : Colors.black.withValues(alpha: 0.08),
          width: isCurrent ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  model.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isCurrent
                        ? Colors.deepPurpleAccent.shade700
                        : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (isCurrent)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'активна',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => _openEditDialog(model),
                icon: const Icon(
                  Icons.settings_outlined,
                  size: 20,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              if (!isCurrent)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _selectModel(model.name),
                  icon: const Icon(
                    Icons.radio_button_unchecked,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: Color(model.usageColor)),
              const SizedBox(width: 6),
              Text(
                '${model.used}/${model.currentMaxLimit}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              Text(
                '${model.currentPhrasesPerRequest} фраз/запит',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: FutureBuilder<List<AiModelSettingsDTO>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: Text('Немає доступних моделей')),
                );
              }
              final models = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: models.length,
                itemBuilder: (context, index) => _modelTile(models[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
