import 'package:eiga/backend/data/dto/AIModelDataDTO.dart';
import 'package:eiga/config/modelsUrl/aiModelManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModelWidget extends StatefulWidget {
  final AiModelDataDTO modelDTO;
  final bool isActive;

  const ModelWidget ({
    Key? key,
    required this.modelDTO,
    required this.isActive,
}) : super(key: key);

  @override
  _modelWidget createState() => _modelWidget();
}

class _modelWidget extends State<ModelWidget> {

  @override
  void initState() {
    super.initState();
  }


  Future<void> changeModel(String modelName) async {
    final aiModelManager = AiModelManager();
    await aiModelManager.setCurrentModel(modelName);
  }

  @override
  Widget build(BuildContext context) {
    AiModelDataDTO model = widget.modelDTO;
    String modelName = model.name;
    int used = model.used;
    int maxLimit = model.maxLimit;
    Color usageColor = model.usageColor;
    return GestureDetector(
      onTap: () async {
        await changeModel(modelName);
        if (!context.mounted) return;
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: widget.isActive ? Colors.green.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: widget.isActive ? Colors.green[400]! : Colors.grey[300]!,
            width: widget.isActive ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: usageColor.withOpacity(0.3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: usageColor.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
                child: Text(
                  modelName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
            ),
            const SizedBox(width: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: usageColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$used/$maxLimit',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}