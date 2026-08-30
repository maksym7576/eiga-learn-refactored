import 'package:eiga/config/secureStorage.dart';
import 'package:eiga/providers/localStoragesProviders.dart';
import 'package:eiga/ui/widgets/settingsScreen/appConfigsSelectorWidget.dart';
import 'package:eiga/ui/widgets/settingsScreen/aiModelsSettingsWidget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/themeProvider.dart';
import '../../../providers/servicesProviders.dart';
import '../../../providers/redirectProviders.dart';
import '../../styles/SettingsTheme.dart';

class ControlButtonWidget extends ConsumerStatefulWidget {
  const ControlButtonWidget({super.key});

  @override
  ConsumerState<ControlButtonWidget> createState() =>
      _ControlButtonWidgetState();
}

class _ControlButtonWidgetState extends ConsumerState<ControlButtonWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(openJimakuDialogProvider)) {
        ref.read(openJimakuDialogProvider.notifier).state = false;

        _openSettingDialog(
          context,
          title: 'Jimaku key',
          builder: (context) => _apiKeyView(context, ApiTokenType.jimaku),
        );
      }
    });
  }

  void _openSettingDialog(
    BuildContext context, {
    required String title,
    required WidgetBuilder builder,
  }) {
    final theme = SettingsTheme.of(context);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'SettingsDialog',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                decoration: BoxDecoration(
                  color: theme.dialogBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.dialogBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: builder(context),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.85,
            end: 1.0,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutBack)),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  Widget _apiKeyView(BuildContext context, ApiTokenType type) {
    final theme = SettingsTheme.of(context);

    return Consumer(
      builder: (context, ref, child) {
        final tokenAsync = ref.watch(tokenProvider(type));
        final notifier = ref.read(tokenProvider(type).notifier);
        return tokenAsync.when(
          data: (String token) {
            final bool hasToken = token.isNotEmpty;
            final controller = TextEditingController(text: token);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${type.name.toUpperCase()} API Key',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.normalText),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.cardBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.apiKeyCardBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.apiKeyInfoIconBackground,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.info_outline,
                            color: theme.apiKeyInfoIcon,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasToken ? 'Token' : 'There is not token',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: theme.apiKeyCardTitle,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              hasToken ? token : 'add api key',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.apiKeyCardSubtitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  style: TextStyle(color: theme.normalText),
                  decoration: InputDecoration(
                    hintText: 'input new key',
                    hintStyle: TextStyle(color: theme.mutedText),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.dialogBorder)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final newKey = controller.text.trim();
                          if (newKey.isNotEmpty) {
                            await notifier.setToken(newKey);
                            if (context.mounted) Navigator.of(context).pop();
                          }
                        },
                        style: theme.primaryButtonStyle(),
                        child: Text(hasToken ? 'Update' : 'Add Key'),
                      ),
                    ),
                    if (hasToken) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await notifier.deleteToken();
                            if (context.mounted) Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text('Delete'),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error', style: TextStyle(color: theme.normalText))),
        );
      },
    );
  }

  Widget _settingsButton(
    BuildContext context, {
    required String title,
    required WidgetBuilder dialogBuilder,
  }) {
    final theme = SettingsTheme.of(context);

    return ElevatedButton(
      onPressed: () =>
          _openSettingDialog(context, title: title, builder: dialogBuilder),
      style: theme.primaryButtonStyle(),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = SettingsTheme.of(context);

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Row(
          children: [
            Expanded(
              child: _settingsButton(
                context,
                title: 'Gemini key',
                dialogBuilder: (context) => _apiKeyView(context, ApiTokenType.gemeni),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _settingsButton(
                context,
                title: 'Jimaku key',
                dialogBuilder: (context) => _apiKeyView(context, ApiTokenType.jimaku),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Appearance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.normalText),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.sectionBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dialogBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Theme Mode', style: TextStyle(fontWeight: FontWeight.w600, color: theme.normalText)),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto)),
                  ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode)),
                  ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode)),
                ],
                selected: {themeMode},
                onSelectionChanged: (newSelection) {
                  ref.read(themeModeProvider.notifier).setMode(newSelection.first);
                },
                showSelectedIcon: false,
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'App Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.normalText),
          ),
        ),
        _settingsButton(
          context,
          title: 'App Configuration',
          dialogBuilder: (context) => const AppConfigsSelectorWidget(),
        ),
        const SizedBox(height: 8),
        _settingsButton(
          context,
          title: 'AI Models',
          dialogBuilder: (context) => const AiModelsSettingsWidget(),
        ),
        const SizedBox(height: 8),
        _settingsButton(
          context,
          title: 'Clear Database',
          dialogBuilder: (context) => _clearDatabaseDialog(context),
        ),
      ],
    );
  }

  Widget _clearDatabaseDialog(BuildContext context) {
    final theme = SettingsTheme.of(context);

    return Consumer(
      builder: (context, ref, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Clear All Data?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.normalText),
            ),
            const SizedBox(height: 12),
            Text(
              'This action will permanently delete all videos, phrases, and progress. API keys will not be affected.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: theme.mutedText),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: theme.secondaryButtonStyle().copyWith(
                      side: WidgetStateProperty.all(const BorderSide(color: Colors.indigo)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(databaseMaintenanceServiceProvider)
                          .clearAllData();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Database cleared successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
