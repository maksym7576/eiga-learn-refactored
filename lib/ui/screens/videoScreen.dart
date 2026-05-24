import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/ui/widgets/phrasesCardsWidgest/phrasesListNotFullScreenWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/videoPlayerWidget.dart';
import 'package:eiga/ui/widgets/playerWidgets/videoSettingsNotFullScreenWidget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({super.key});

  @override
  ConsumerState<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(translationProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 7.0),
          child: Column(
            children: [
              Flexible(
                child: Stack(
                  children: [
                    VideoPlayerWidget(),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: IconButton(
                        onPressed: () => context.go('/main'),
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              VideoSettingsNotFullScreenWidget(),
              Expanded(child: PhraseListNotFullScreenWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
