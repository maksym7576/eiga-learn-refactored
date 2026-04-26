import 'package:eiga/config/secureStorage.dart';
import 'package:eiga/ui/widgets/settingsScreen/controlButtonsWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum SettingType { apiKey, maxLimit }

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/main'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.deepPurpleAccent,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: ControlButtonWidget(),
    );
  }
}
