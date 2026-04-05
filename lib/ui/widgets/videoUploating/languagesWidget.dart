import 'package:eiga/config/depacker/depackerLanguageConfig.dart';
import 'package:eiga/ui/widgets/videoUploating/languageWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum LanguageType { original, translation }

class LanguagesWidget extends ConsumerStatefulWidget {
  const LanguagesWidget({super.key});

  @override
  ConsumerState<LanguagesWidget> createState() => _LanguagesWidgetState();
}

class _LanguagesWidgetState extends ConsumerState<LanguagesWidget> {
  LanguageType _activeTypeNow = LanguageType.original;

  Widget _buildToggleButton(String title, LanguageType type) {
    final isActive = _activeTypeNow == type;
    final colorButtonBorder = isActive
        ? Colors.deepPurpleAccent
        : Colors.deepPurpleAccent.withOpacity(0.5);
    final colorButtonInside = isActive ? Colors.grey.shade100 : Colors.white;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _activeTypeNow = type;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: colorButtonInside,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorButtonBorder,
              width: isActive ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languages = DepackerLanguageConfigRegistry.getAllLanguages();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      'Languages',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.deepPurpleAccent,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Select the language',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurpleAccent.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Icon(Icons.close, size: 27, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildToggleButton('Original', LanguageType.original),
              const SizedBox(width: 10),
              _buildToggleButton('Translation', LanguageType.translation),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                ...languages.map((lan) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: LanguageWidget(language: lan, type: _activeTypeNow),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
