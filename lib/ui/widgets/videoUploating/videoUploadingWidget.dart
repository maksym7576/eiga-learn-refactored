import 'package:eiga/backend/data/dto/JimakuDataDTO.dart';
import 'package:eiga/backend/data/dto/JimakuFileOrGroupDTO.dart';
import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoComponentsProvider.dart';
import 'package:eiga/ui/widgets/phrasesDepacked/phraseDepPreviewWidget.dart';
import 'package:eiga/ui/widgets/searchWidgets/JimakuSearch/JimakuSubtitleSource.dart';
import 'package:eiga/ui/widgets/searchWidgets/searchPickerWidget.dart';
import 'package:eiga/ui/widgets/videoUploating/components/videoFilePickersRow.dart';
import 'package:eiga/ui/widgets/videoUploating/components/videoFormActionButtons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../backend/services/depack_subtitles_services/SeasonEpisodeInfo.dart';
import '../../../providers/DTOProviders.dart';
import '../../../providers/searchProvider.dart';
import '../dialogs/AppBottomSheet.dart';
import '../searchWidgets/AniListSearch/AniListPreviewWidget.dart';
import 'components/AttachSubtitleBottomSheet.dart';
import 'components/JimakuSearchBottomSheet.dart';
import 'components/UploadingTheme.dart';
import 'components/VideoTitleField.dart';
import 'components/languageButtonWidget.dart';

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

  void _showAttachSubtitleSheet() {
    final theme = UploadingTheme.of(context);
    AppBottomSheet.show(
      context: context,
      heightFactor: 0.85,
      backgroundColor: theme.backgroundColor,
      child: AttachSubtitleBottomSheet(
        titleController: _titleController,
      ),
    );
  }

  void _pickJimakuSrt(BuildContext context, WidgetRef ref) {
    final theme = UploadingTheme.of(context);
    AppBottomSheet.show(
      context: context,
      heightFactor: 0.85,
      backgroundColor: theme.backgroundColor,
      child: JimakuSearchBottomSheet(
        onResolved: (path) {
          ref.read(srtPathProvider.notifier).state = path;

          final entry = ref.read(selectedEntryProvider(SearchSourceKeys.jimaku)) as JimakuDataDTO?;
          final item = ref.read(selectedResultProvider(SearchSourceKeys.jimaku)) as JimakuFileOrGroupDTO?;
          final file = item?.file;

          ref.read(jimakuEntryFinalProvider.notifier).state = entry;
          ref.read(jimakuFileFinalProvider.notifier).state = file;

          final anilistId = entry?.anilistId;
          if (anilistId != null) {
            ref.read(aniListProvider.notifier).refresh(anilistId);
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
    ref.read(aniListProvider.notifier).clear();
    ref.read(jimakuEntryFinalProvider.notifier).state = null;
    ref.read(jimakuFileFinalProvider.notifier).state = null;
  }

  Future<void> _submitVideo() async {
    final jimakuEntry = ref.read(jimakuEntryFinalProvider);
    final jimakuFile = ref.read(jimakuFileFinalProvider);
    final videoService = ref.read(videoServiceProvider.notifier);
    final videoPath = ref.read(videoPathProvider);
    final srtPath = ref.read(srtPathProvider);
    final originalLanguage = ref.read(languageProvider).original;
    final targetLanguage = ref.read(languageProvider).target;
    final name = _titleController.text.trim();

    if (videoPath == null ||
        srtPath == null ||
        originalLanguage.isEmpty ||
        targetLanguage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to fill all')),
      );
      return;
    }

    final anilistData = ref.read(aniListProvider).value;

    final resolvedName = name.isNotEmpty
        ? name
        : anilistData?.romajiTitle?.isNotEmpty == true
        ? anilistData!.romajiTitle!
        : jimakuEntry?.displayTitle.isNotEmpty == true
        ? jimakuEntry!.displayTitle
        : videoPath.toString().trim();

    final seasonEpisode = (jimakuFile != null && jimakuEntry?.isMovie != true)
        ? parseSeasonEpisode(jimakuFile.name)
        : const SeasonEpisodeInfo();

    final videoObj = VideoObject()
      ..videoName = resolvedName
      ..videoPath = videoPath
      ..pathSubtitle = srtPath
      ..originalLanguage = originalLanguage
      ..translatedLanguage = targetLanguage
      ..createdAt = DateTime.now()
      ..season = seasonEpisode.season
      ..episode = seasonEpisode.episode

      ..pepelineIndetificator = 'context_translation_v1'

    // Jimaku
      ..nameJumaku = jimakuEntry?.name
      ..englishName = jimakuEntry?.englishName
      ..japaneseName = jimakuEntry?.japaneseName
      ..nameFileJumaku = jimakuFile?.name
      ..anilistId = jimakuEntry?.anilistId
      ..tmdbId = jimakuEntry?.tmdbId
      ..isAnime = jimakuEntry?.isAnime
      ..isMovie = jimakuEntry?.isMovie
      ..isAdult = jimakuEntry?.isAdult
      ..isUnverified = jimakuEntry?.isUnverified

    // AniList
      ..coverImagePath = anilistData?.coverImagePath
      ..description = anilistData?.description
      ..bannerImage = anilistData?.bannerImage
      ..genres = anilistData?.genres
      ..colorThemeValue = anilistData?.colorThemeValue;


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
          VideoFilePickersRow(
            videoPath: videoPatch,
            srtPath: srtPatch,
            onPickVideo: _pickVideo,
            onAttachSubtitle: _showAttachSubtitleSheet,
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
          if (srtPatch != null && lanProv.original.isNotEmpty)
            PhrasesDepPreviewWidget(
              onSearch: () => _pickJimakuSrt(context, ref),
            ),
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