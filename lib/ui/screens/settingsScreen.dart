import 'package:eiga/ui/widgets/settingsScreen/controlButtonsWidget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../styles/AppAppBarTheme.dart';

enum SettingType { apiKey, maxLimit }

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarTheme = AppAppBarTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: appBarTheme.iconColor),
        ),
        title: Text(
          'Settings',
          style: appBarTheme.logoStyle,
        ),
      ),
      body: ControlButtonWidget(),
    );
  }
}
