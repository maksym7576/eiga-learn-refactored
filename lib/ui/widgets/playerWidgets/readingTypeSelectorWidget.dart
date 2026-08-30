import 'package:eiga/config/depacker/readingTypeLanguageConfig.dart';
import 'package:eiga/providers/readingTypeProvider.dart';
import 'package:eiga/ui/styles/PlayerSettingsTheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReadingTypeSelectorWidget extends ConsumerWidget {
  const ReadingTypeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readingTypeNotifierProvider);

    return state.when(
      data: (data) => _buildContent(context, ref, data),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ReadingTypeProvider data) {
    final options = data.config.options;
    final theme = PlayerSettingsTheme.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Text(
            'Subtitle Display',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: theme.primaryAccent,
            ),
          ),
          const SizedBox(height: 24),
          _buildGroup(
            context: context,
            theme: theme,
            title: 'Primary Subtitle',
            subtitle: 'This will be the main text shown.',
            child: Column(
              children: options.map((opt) {
                return _ReadingOptionTile(
                  label: opt,
                  isSelected: data.mainOption == opt,
                  onTap: () => ref.read(readingTypeNotifierProvider.notifier).updateMainOption(opt),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          _buildGroup(
            context: context,
            theme: theme,
            title: 'Secondary Subtitle',
            subtitle: 'Optional text shown above the primary.',
            child: Column(
              children: [
                _ReadingOptionTile(
                  label: 'None',
                  isSelected: data.additionalOptions == null,
                  onTap: () => ref.read(readingTypeNotifierProvider.notifier).updateAdditionalOption(null),
                ),
                ...options.map((opt) {
                  return _ReadingOptionTile(
                    label: opt,
                    isSelected: data.additionalOptions == opt,
                    onTap: () => ref.read(readingTypeNotifierProvider.notifier).updateAdditionalOption(opt),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildGroup({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Widget child,
    required PlayerSettingsTheme theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: theme.normalText,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: theme.mutedText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.sectionBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.tileBorder,
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReadingOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = PlayerSettingsTheme.of(context);
    final accent = theme.primaryAccent;
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? theme.tileActiveBackground : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: theme.tileBorder,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? accent : theme.normalText,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: accent, size: 22)
            else
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.tileBorder,
                    width: 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
