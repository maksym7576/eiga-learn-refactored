


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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/main'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Player',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.deepPurpleAccent,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Column(
        children: [
          VideoPlayerWidget(),
          VideoSettingsNotFullScreenWidget(),
          Expanded(
              child: PhraseListNotFullScreenWidget(),
          ),
        ],
      ),
    );
  }
}