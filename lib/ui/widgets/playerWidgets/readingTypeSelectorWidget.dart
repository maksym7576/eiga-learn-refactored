import 'package:eiga/config/depacker/readingTypeLanguageConfig.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ReadingType { mainOption, additionalOption }

class ReadingTypeSelectorWidget extends ConsumerStatefulWidget {
  const ReadingTypeSelectorWidget({super.key});

  @override
  ConsumerState<ReadingTypeSelectorWidget> createState() =>
      _ReadingTypeSelectorWidgetState();
}

class _ReadingTypeSelectorWidgetState
    extends ConsumerState<ReadingTypeSelectorWidget> {
  ReadingType _activeType = ReadingType.mainOption;

  Widget _buildToggleButton(String title, ReadingType type) {
    final isActive = _activeType == type;
    final colorButtonBorder =
    isActive ? Colors.deepPurpleAccent : Colors.deepPurpleAccent.withOpacity(0.5);
    final colorButtonInside = isActive ? Colors.grey.shade100 : Colors.white;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _activeType = type;
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
            style: const TextStyle(
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
    final state = ref.watch(readingTypeNotifierProvider);

    return state.when(
      data: (data) {
        final List<String> options = data.config.options;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 6),
                        const Text(
                          'Reading Settings',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.deepPurpleAccent,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Customize your reading',
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
                      padding: const EdgeInsets.only(right: 16, top: 8),
                      child: Icon(Icons.close, size: 27, color: Colors.black87),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Toggle Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _buildToggleButton('Main Option', ReadingType.mainOption),
                    const SizedBox(width: 10),
                    _buildToggleButton(
                        'Additional', ReadingType.additionalOption),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    if (_activeType == ReadingType.mainOption) ...[
                      ..._buildMainOptions(options, data, ref),
                    ] else ...[
                      ..._buildAdditionalOptions(options, data, ref),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red[400],
                size: 48,
              ),
              const SizedBox(height: 12),
              const Text(
                'Failed to load settings',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      loading: () => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.deepPurpleAccent,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMainOptions(
      List<String> options, dynamic data, WidgetRef ref) {
    return options.map((option) {
      final isSelected = option == data.mainOption;
      return _OptionTile(
        title: option,
        isSelected: isSelected,
        onChanged: (value) {
          if (value ?? false) {
            ref.read(readingTypeNotifierProvider.notifier).updateMainOption(option);

            if (option == data.additionalOptions) {
              ref.read(readingTypeNotifierProvider.notifier).updateAdditionalOption(null);
            }
          }
        },
      );
    }).toList();
  }

  List<Widget> _buildAdditionalOptions(
      List<String> options, dynamic data, WidgetRef ref) {
    return [
      _OptionTile(
        title: 'None',
        isSelected: data.additionalOptions == null,
        onChanged: (_) {
          ref.read(readingTypeNotifierProvider.notifier).updateAdditionalOption(null);
        },
      ),
      ...options.map((option) {
        final isSelected = option == data.additionalOptions;
        final isDisabled = option == data.mainOption;

        return _OptionTile(
          title: option,
          isSelected: isSelected,
          isDisabled: isDisabled,
          onChanged: isDisabled
              ? null
              : (_) {
            ref.read(readingTypeNotifierProvider.notifier)
                .updateAdditionalOption(option);
          },
        );
      }).toList(),
    ];
  }
}

class _OptionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool isDisabled;
  final ValueChanged<bool?>? onChanged;

  const _OptionTile({
    required this.title,
    required this.isSelected,
    this.isDisabled = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : () => onChanged?.call(true),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: isSelected ? true : false,
                onChanged: isDisabled ? null : onChanged,
                activeColor: Colors.deepPurpleAccent,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isDisabled ? Colors.grey[400] : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}