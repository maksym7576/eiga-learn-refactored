import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoComponentsProvider.dart';
import 'package:eiga/ui/widgets/phrasesDepacked/phraseDepPreviewWidget.dart';
import 'package:eiga/ui/widgets/videoUploating/swipeableFileBoxWidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'languageButtonWidget.dart';


class VideoUploadingWidget extends ConsumerStatefulWidget {
  const VideoUploadingWidget({super.key});

  @override
  ConsumerState<VideoUploadingWidget> createState() => _VideoUploadingWidgetState();
}

class _VideoUploadingWidgetState extends ConsumerState<VideoUploadingWidget> {
  final TextEditingController _titleController = TextEditingController();

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      ref.read(videoPathProvider.notifier).state = result.files.first.path;
    }
  }

  Future<void> _pickSrt() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['srt']);
    if (result != null) {
      ref.read(srtPathProvider.notifier).state = result.files.first.path;
    }
  }

  Future<void> _submitVideo() async {
    final videoService = ref.read(videoServiceProvider.notifier);
    final videoPath = ref.read(videoPathProvider);
    final srtPath = ref.read(srtPathProvider);
    final originalLanguage = ref.read(languageProvider).original;
    final targetLanguage = ref.read(languageProvider).target;
    final name = _titleController.text.trim();

    if (videoPath == null || srtPath == null || originalLanguage.isEmpty || targetLanguage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You need to fill all')));
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
    await ref.read(subtitleDepackerServiceProvider).depack(newVideo);

    _titleController.clear();
    ref.read(videoPathProvider.notifier).state = null;
    ref.read(srtPathProvider.notifier).state = null;
    ref.read(languageProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final lanProv = ref.watch(languageProvider);
    final videoPatch = ref.watch(videoPathProvider);
    final srtPatch = ref.watch(srtPathProvider);

    final isButtonEnabled = (videoPatch?.isNotEmpty ?? false) &&
        (srtPatch?.isNotEmpty ?? false) &&
        lanProv.original.isNotEmpty &&
        lanProv.target.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: const TextStyle(color: Colors.deepPurple),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.4))),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SwipeableFileBox(
                  variants: [
                    FileBoxVariant(label: 'Attach video', path: videoPatch, icon: Icons.video_file_rounded, onTap: _pickVideo),
                    FileBoxVariant(label: 'Attach video', path: videoPatch, icon: Icons.video_file_rounded, onTap: _pickVideo),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SwipeableFileBox(
                  variants: [
                    FileBoxVariant(label: 'Attach subtitle', path: srtPatch, icon: Icons.subtitles_sharp, onTap: _pickSrt),
                    FileBoxVariant(label: 'Attach subtitle', path: srtPatch, icon: Icons.subtitles_sharp, onTap: _pickSrt),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(child: LanguageButtonWidget(original: lanProv.original, translation: lanProv.target)),
            ],
          ),
          const SizedBox(height: 7),
          if (srtPatch != null && lanProv.original.isNotEmpty) const PhrasesDepPreviewWidget(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled ? _submitVideo : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Submit', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}