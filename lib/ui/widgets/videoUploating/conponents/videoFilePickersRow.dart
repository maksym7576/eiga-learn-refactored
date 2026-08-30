import 'package:eiga/ui/widgets/videoUploating/conponents/swipeableFileBoxWidget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../config/secureStorage.dart';
import '../../../../providers/localStoragesProviders.dart';
import '../../../../providers/redirectProviders.dart';

class VideoFilePickersRow extends ConsumerWidget {
  const VideoFilePickersRow({
    super.key,
    required this.videoPath,
    required this.srtPath,
    required this.onPickVideo,
    required this.onPickSrt,
    required this.onPickJimakuSrt,
  });

  final String? videoPath;
  final String? srtPath;
  final VoidCallback onPickVideo;
  final VoidCallback onPickSrt;
  final void Function(BuildContext context, WidgetRef ref) onPickJimakuSrt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jimakuTokenAsync = ref.watch(tokenProvider(ApiTokenType.jimaku));
    final hasJimakuToken = jimakuTokenAsync.valueOrNull?.isNotEmpty ?? false;

    return Row(
      children: [
        Expanded(
          child: SwipeableFileBox(
            variants: [
              FileBoxVariant(
                label: 'Attach video',
                path: videoPath,
                icon: Icons.video_file_rounded,
                onTap: onPickVideo,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SwipeableFileBox(
            variants: [
              FileBoxVariant(
                label: 'Attach subtitle',
                path: srtPath,
                icon: Icons.subtitles_sharp,
                onTap: onPickSrt,
              ),
              FileBoxVariant(
                label: hasJimakuToken ? 'Jimaku subtitle' : 'Jimaku token not exists',
                path: hasJimakuToken ? srtPath : null,
                icon: Icons.closed_caption,
                onTap: hasJimakuToken
                    ? () => onPickJimakuSrt(context, ref)
                    : () {
                  ref.read(openJimakuDialogProvider.notifier).state = true;
                  context.go('/settings');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}