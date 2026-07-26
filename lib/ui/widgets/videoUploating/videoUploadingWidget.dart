import 'package:eiga/backend/data/dto/JimakuDataDTO.dart';
import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoComponentsProvider.dart';
import 'package:eiga/ui/widgets/phrasesDepacked/phraseDepPreviewWidget.dart';
import 'package:eiga/ui/widgets/searchWidgets/JimakuSearch/JimakuSubtitleSource.dart';
import 'package:eiga/ui/widgets/searchWidgets/searchPickerWidget.dart';
import 'package:eiga/ui/widgets/videoUploating/videoFilePickersRow.dart';
import 'package:eiga/ui/widgets/videoUploating/videoFormActionButtons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/anilistServiceProvider.dart';
import '../../../providers/localStoragesProviders.dart';
import '../../../providers/searchProvider.dart';
import 'AnilistPreviewWidget.dart';
import 'VideoTitleField.dart';
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

  Future<void> _pickPath() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['srt']);
    if (result != null) {
      ref.read(srtPathProvider.notifier).state = result.files.first.path;
    }
  }

  void _pickJimakuSrt(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SearchPickerWidget<JimakuDataDTO, FileJimakuDTO>(
        source: JimakuSubtitleSource(),
        onResolved: (path) {
          ref.read(srtPathProvider.notifier).state = path;

          final entry = ref.read(selectedEntryProvider(SearchSourceKeys.jimaku)) as JimakuDataDTO?;
          final anilistId = entry?.anilistId;
          if (anilistId != null) {
            ref.fetchAnilistMetadata(anilistId);
          }
        },
      ),
    );
  }

  void _clearForm() {
    _titleController.clear();
    ref.read(videoPathProvider.notifier).state = null;
    ref.read(srtPathProvider.notifier).state = null;
    ref.read(languageProvider.notifier).clear();
    ref.clearAnilistData();
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

    final anilistData = ref.read(anilistDataProvider);
    final hasAnilistTitle = (anilistData?.displayTitle ?? '').isNotEmpty;

    final videoObj = VideoObject()
      ..videoName = name.isEmpty ? (hasAnilistTitle ? anilistData!.displayTitle : videoPath.toString().trim()) : name
      ..videoPath = videoPath
      ..pathSubtitle = srtPath
      ..originalLanguage = originalLanguage
      ..translatedLanguage = targetLanguage
      ..anilistId = anilistData?.id
      ..animeTitle = anilistData?.displayTitle
      ..coverImagePath = anilistData?.localCoverPath
      ..createdAt = DateTime.now();

    final newVideo = await videoService.addVideoAndGet(videoObj);
    await ref.read(subtitleDepackerServiceProvider).depack(newVideo);

    _clearForm();
  }

  @override
  Widget build(BuildContext context) {
    final lanProv = ref.watch(languageProvider);
    final videoPatch = ref.watch(videoPathProvider);
    final srtPatch = ref.watch(srtPathProvider);

    final hasAnyData = (videoPatch?.isNotEmpty ?? false) ||
        (srtPatch?.isNotEmpty ?? false) ||
        lanProv.original.isNotEmpty ||
        lanProv.target.isNotEmpty;
    final isButtonEnabled = (videoPatch?.isNotEmpty ?? false) &&
        (srtPatch?.isNotEmpty ?? false) &&
        lanProv.original.isNotEmpty &&
        lanProv.target.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        children: [
          VideoTitleField(controller: _titleController),
          const SizedBox(height: 12),
          VideoFilePickersRow(
            videoPath: videoPatch,
            srtPath: srtPatch,
            onPickVideo: _pickVideo,
            onPickSrt: _pickPath,
            onPickJimakuSrt: _pickJimakuSrt,
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(child: LanguageButtonWidget(original: lanProv.original, translation: lanProv.target)),
            ],
          ),
          const SizedBox(height: 7),
          const AnilistPreviewWidget(),
          if (srtPatch != null && lanProv.original.isNotEmpty) const PhrasesDepPreviewWidget(),
          const SizedBox(height: 16),
          VideoFormActionButtons(
            hasAnyData: hasAnyData,
            isSubmitEnabled: isButtonEnabled,
            onCancel: _clearForm,
            onSubmit: _submitVideo,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}