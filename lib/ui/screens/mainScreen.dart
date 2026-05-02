import 'package:eiga/ui/widgets/appBarWidgets/appBarWidget.dart';
import 'package:eiga/ui/widgets/videoListWidget.dart';
import 'package:eiga/ui/widgets/videoUploating/videoUploadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBarWidget(),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          VideoUploadingWidget(),
          VideoListWidget(),
        ]),
      ),
    );
  }
}
