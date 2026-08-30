import 'package:eiga/config/depacker/depackerLanguageConfig.dart';
import 'package:eiga/ui/styles/AdditionalWindowTheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'languageWidget.dart';

enum LanguageType { original, translation }

class LanguagePreviewWidget extends ConsumerStatefulWidget {
  const LanguagePreviewWidget({super.key});

  @override
  ConsumerState<LanguagePreviewWidget> createState() => _LanguagesWidgetState();
}

class _LanguagesWidgetState extends ConsumerState<LanguagePreviewWidget> {
  LanguageType _activeTypeNow = LanguageType.original;

  Widget _buildToggleButton(String title, LanguageType type, AdditionalWindowTheme theme) {
    final isActive = _activeTypeNow == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _activeTypeNow = type;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? theme.activeTabBackground : theme.inactiveTabBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isActive ? theme.activeTabText : theme.inactiveTabText,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languages = DepackerLanguageConfigRegistry.getAllLanguages();
    final theme = AdditionalWindowTheme.of(context);

    return Container(
      color: theme.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Languages',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: theme.titleColor,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(Icons.close, size: 27, color: theme.closeIconColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.tabSwitcherBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildToggleButton('Original', LanguageType.original, theme),
                  const SizedBox(width: 7),
                  _buildToggleButton('Translation', LanguageType.translation, theme),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose the language for the video content.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: theme.subtitleColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: languages.length,
              itemBuilder: (context, index) {
                return LanguageWidget(
                  language: languages[index],
                  type: _activeTypeNow,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
