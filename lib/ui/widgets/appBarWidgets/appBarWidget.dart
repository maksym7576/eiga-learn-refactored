import 'package:eiga/backend/data/dto/AIModelDataDTO.dart';
import 'package:eiga/config/modelsUrl/aiModelManager.dart';
import 'package:eiga/ui/widgets/appBarWidgets/modelsPreviewWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../dialogs/AppBottomSheet.dart';
import '../dialogs/AppDialog.dart';

class AppBarWidget extends StatefulWidget {
  @override
  _AppBarWidget createState() => _AppBarWidget();
}

class _AppBarWidget extends State<AppBarWidget> {
  AiModelDataDTO _selectedItem = new AiModelDataDTO(
    name: 'No model',
    url: 'No',
    maxLimit: 0,
    used: 0,
    phrasesPerRequest: 10,
    isStreamingEnabled: false,
  );
  List<AiModelDataDTO> _models = [];
  bool _isModelDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _initModels();
  }

  Future<void> _initModels() async {
    final aiModelManager = AiModelManager();
    List<AiModelDataDTO> models = await aiModelManager.getAllModelsData();

    setState(() {
      _selectedItem = models.first;
      _models = models.skip(1).toList();
    });
  }

  void _showAllModelsDialog() async {
    setState(() => _isModelDialogOpen = true);
    try {
      await AppBottomSheet.show(
        context: context,
        barrierLabel: "ModelsLabel",
        child: ModelPreviewWidget(
        ),
      );
    } finally {
      setState(() => _isModelDialogOpen = false);
    }
    await _initModels();
  }

  void _showMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(double.infinity, 56, 0, 0),
      items: [PopupMenuItem(value: 'settings', child: Text('Settings'))],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = _selectedItem!.usageColor;
    return AppBar(
      backgroundColor: Colors.grey[50],
      elevation: 0,
      title: Row(
        children: [
          SizedBox(width: 10),
          Text(
            'eiga',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.deepPurpleAccent,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: GestureDetector(
              onTap: _showAllModelsDialog,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: _isModelDialogOpen
                        ? Colors.deepPurpleAccent.withOpacity(0.3)
                        : Colors.grey[300]!,
                    width: _isModelDialogOpen ? 2.5 : 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: _isModelDialogOpen
                          ? Colors.deepPurpleAccent.withOpacity(0.25)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: _isModelDialogOpen ? 8 : 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 5),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.2),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _selectedItem!.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(color: color.withOpacity(0.05)),
                      child: Text(
                        '${_selectedItem!.used}/${_selectedItem!.maxLimit}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.menu, color: Colors.black87),
          onPressed: () {
            context.go('/settings');
          },
        ),
      ],
    );
  }
}
