import 'package:eiga/backend/data/dto/AIModelDataDTO.dart';
import 'package:eiga/config/modelsUrl/AIModelsURLData.dart';
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

  Future<List<AiModelDataDTO>>? _future;
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

  Future<void> _openEditDialog(AiModelDataDTO model) async {
    final maxLimitController =
    TextEditingController(text: model.maxLimit.toString());
    final phrasesController =
    TextEditingController(text: model.phrasesPerRequest.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            model.name,
            style: const TextStyle(fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: maxLimitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Ліміт запитів',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phrasesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Фраз за один запит',
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

  Widget _modelTile(AiModelDataDTO model) {
    final bool isCurrent = model.name == _currentName;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isCurrent
            ? Colors.deepPurpleAccent.withOpacity(0.08)
            : Colors.grey.withOpacity(0.06),
        border: Border.all(
          color: isCurrent
              ? Colors.deepPurpleAccent
              : Colors.grey.withOpacity(0.2),
          width: isCurrent ? 1.5 : 1,
        ),
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
                    fontSize: 14,
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
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'активна',
                    style: TextStyle(color: Colors.white, fontSize: 10.5),
                  ),
                ),
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 18,
                  onPressed: () => _openEditDialog(model),
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ),
              if (!isCurrent)
                SizedBox(
                  width: 32,
                  height: 32,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 18,
                    onPressed: () => _selectModel(model.name),
                    icon: const Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 9, color: model.usageColor),
                  const SizedBox(width: 5),
                  Text(
                    '${model.used}/${model.maxLimit}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Text(
                '${model.phrasesPerRequest} фраз/запит',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
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
        const Text(
          'AI моделі',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Flexible(
          child: FutureBuilder<List<AiModelDataDTO>>(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final models = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
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