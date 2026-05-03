

import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoComponentsProvider.dart';
import 'package:eiga/ui/widgets/phrasesDepacked/phraseDepPreviewWidget.dart';
import 'package:eiga/ui/widgets/videoUploating/languagePreviewWidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VideoUploadingWidget extends ConsumerStatefulWidget {
  const VideoUploadingWidget({super.key});

  @override
  ConsumerState<VideoUploadingWidget> createState() => _VideoUploadingWidgetState();
}

class _VideoUploadingWidgetState extends ConsumerState<VideoUploadingWidget> {
  final TextEditingController _titleController = TextEditingController();


  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      final file = result.files.first;

      String? path = file.path;

      ref.read(videoPathProvider.notifier).state = path;
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

      ref.read(srtPathProvider.notifier).state = path;
    }
  }

  Widget _buildFileBox({required String label, required String? path, required IconData icon, required VoidCallback onTap,}) {
    final isPicked = path != null;
    final fileName = isPicked ? path.split('/').last : null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCirc,
          height: 120,
          decoration: BoxDecoration(
            color: isPicked
                ? Colors.deepPurpleAccent.withOpacity(0.08)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isPicked
                  ? Colors.deepPurpleAccent
                  : Colors.deepPurple.withOpacity(0.25),
              width: isPicked ? 2.0 : 1.5,
            ),
            boxShadow: isPicked
            ? [
              BoxShadow (
                color: Colors.deepPurpleAccent.withOpacity(0.12),
                blurRadius: 12,
                spreadRadius: 2,
              ),
              ]
              : [],
          ),
        child: Center (
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => ScaleTransition(
                scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
                child: FadeTransition(opacity: anim, child: child),
            ),
            child: isPicked ? Column(
              key: const ValueKey('picked'),
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.deepPurpleAccent,
                  size: 36,
                ),
                const SizedBox(height: 8),
                Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                  child: Text(
                    fileName ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ) : Column(
              key: const ValueKey('empty'),
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.deepPurpleAccent.withOpacity(0.35),
                  size: 36,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.deepPurpleAccent.withOpacity(0.45),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitVideo() async {
    final videoService = ref.read(videoServiceProvider.notifier);
    final videoPath = ref.read(videoPathProvider);
    final srtPath = ref.read(srtPathProvider);
    final originalLanguage = ref.read(languageProvider).original;
    final targetLanguage = ref.read(languageProvider).target;
    final name = _titleController.text.trim();

    if (videoPath == null || srtPath == null || originalLanguage.isEmpty || targetLanguage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to fill all')),
      );
      return;
    }

    final videoObj = VideoObject()
    ..videoName = name.isEmpty ? videoPath.toString().trim() : name
    ..videoPath = videoPath
    ..pathSubtitle = srtPath
    ..originalLanguage = originalLanguage
    ..translatedLanguage = targetLanguage
    ..createdAt = DateTime.now();

    final newVideo = await videoService.addVideoAndGet(videoObj);
    print('video id ${newVideo.id}');
    await ref.read(subtitleDepackerServiceProvider).depack(newVideo);

    _titleController.clear();
    ref.read(videoPathProvider.notifier).state = null;
    ref.read(srtPathProvider.notifier).state = null;
    ref.read(languageProvider.notifier).clear();
  }

  void _showAllLanguages() async {
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
                    child: LanguagePreviewWidget(),
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
  }

  Widget _buildLanguageButton(String original, String translation) {
    final hasLanguages = original.isNotEmpty && translation.isNotEmpty;
    final hasOriginal = original.isNotEmpty;
    final hasTranslation = translation.isNotEmpty;

    return GestureDetector(
      onTap: _showAllLanguages,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: hasLanguages
                ? Colors.deepPurpleAccent.withOpacity(0.3)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasLanguages
                  ? Colors.deepPurpleAccent.shade100
                  : Colors.deepPurple.withOpacity(0.25),
              width: hasLanguages ? 2 : 1.5,
            ),
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text (
              hasOriginal ? original : 'original',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: hasOriginal
                  ? Colors.deepPurpleAccent
                  : Colors.deepPurple.withOpacity(0.4),
              ),
            ),
            const SizedBox(width: 1),
            Icon(
              Icons.arrow_right_alt,
              size: 20,
              color: hasLanguages
                ? Colors.deepPurpleAccent
                : Colors.deepPurple.withOpacity(0.4),
            ),
            const SizedBox(width: 1),
            Text (
              hasTranslation ? translation : 'translation',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: hasTranslation
                    ? Colors.deepPurpleAccent
                    : Colors.deepPurple.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lanProv = ref.watch(languageProvider);
    final originalLan = lanProv.original;
    final translationLan = lanProv.target;

    String? videoPatch = ref.watch(videoPathProvider);
    String? srtPatch = ref.watch(srtPathProvider);

    final isButtonEnabled = (videoPatch?.isNotEmpty ?? false) && (srtPatch?.isNotEmpty ?? false) && lanProv.original.isNotEmpty && lanProv.target.isNotEmpty;

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
                child: _buildFileBox(
                    label: 'Attach video',
                    path: videoPatch,
                    icon: Icons.video_file_rounded,
                    onTap: _pickVideo
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildFileBox(
                    label: 'Attach subtitle',
                    path: srtPatch,
                    icon: Icons.subtitles_sharp,
                    onTap: _pickSrt
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                  child: _buildLanguageButton(originalLan, translationLan),
              ),
            ],
          ),
          SizedBox(height: 7),
          if (srtPatch != null && originalLan.isNotEmpty)
            Container(
              child: PhrasesDepPreviewWidget(),
            ),
          const SizedBox(height: 16),
          Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
            child:    SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled ? () {
                  _submitVideo();
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}