

import 'package:eiga/ui/widgets/videoUploating/languagesWidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoUploadingWidget extends StatefulWidget {
  const VideoUploadingWidget({super.key});

  @override
  State<VideoUploadingWidget> createState() => _VideoUploadingWidget();
}

class _VideoUploadingWidget extends State<VideoUploadingWidget> {
  final TextEditingController _titleController = TextEditingController();

  String? videoPatch;
  String? srtPatch;


  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      final file = result.files.first;

      String? path = file.path;

      setState(() {
        videoPatch = path;
      });
    }
  }

  Future<void> _pickSrt() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['srt'],
    );

    if (result != null) {
      final file = result.files.first;
      String? path = file.path;

      setState(() {
        srtPatch = path;
      });
    }
  }

  void _showAllLanguages() async {
    try {
      await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "ModelsLabel",
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, anim1, anim2) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery
                        .of(context)
                        .size
                        .height * 0.6,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LanguagesWidget(),
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return ScaleTransition(
            scale: Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).animate(
                CurvedAnimation(parent: anim1, curve: Curves.easeOutBack)),
            child: FadeTransition(opacity: anim1, child: child),
          );
        },
      );
    } finally {
      setState(() {
        // _isModelDialogOpen = false;
      });
    }
    // await _initModels();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.deepPurple),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.deepPurple.withOpacity(0.4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  onPressed: _pickVideo,
                  child: const Text('Attach video'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CupertinoButton(
                  onPressed: _pickSrt,
                  child: Text('Attach subtitle'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: CupertinoButton(
                      child: const  Text('Language'),
                      onPressed: () => _showAllLanguages(),
                  ),
              ),
            ],
          )
        ],
      ),
    );
  }
}