import 'package:eiga/backend/data/models/subtitleSettings.dart';
import 'package:eiga/providers/subtitle_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubtitleSelectorWidget extends ConsumerStatefulWidget {
  const SubtitleSelectorWidget({super.key});

  @override
  ConsumerState<SubtitleSelectorWidget> createState() => _SubtitleSelectorWidgetState();
}

class _SubtitleSelectorWidgetState extends ConsumerState<SubtitleSelectorWidget> {
  bool _isFullScreenMode = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subtitleSettingsNotifierProvider);

    return state.when(
      data: (data) => _buildContent(data),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildContent(SubtitleSettingsState data) {
    final currentConfig = _isFullScreenMode ? data.fullScreen : data.portrait;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Subtitle Customization',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.deepPurpleAccent),
          ),
          const SizedBox(height: 16),

          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Portrait'), icon: Icon(Icons.smartphone)),
              ButtonSegment(value: true, label: Text('Fullscreen'), icon: Icon(Icons.fullscreen)),
            ],
            selected: {_isFullScreenMode},
            onSelectionChanged: (val) => setState(() => _isFullScreenMode = val.first),
          ),

          const SizedBox(height: 24),

          if (_isFullScreenMode) _buildFullscreenPreview(data.fullScreen),

          const SizedBox(height: 24),

          _buildInteractionPreview(currentConfig),

          const SizedBox(height: 24),

          // PRESET SELECT
          _buildGroup(
            title: 'Visual Preset',
            subtitle: 'Pre-defined colors and shadows',
            child: Row(
              children: [
                Expanded(
                  child: _PresetTile(
                    name: 'Original',
                    isSelected: currentConfig.presetName == 'Original',
                    onTap: () => ref.read(subtitleSettingsNotifierProvider.notifier).updatePreset(_isFullScreenMode, 'Original'),
                  ),
                ),
                Expanded(
                  child: _PresetTile(
                    name: 'Crunchyroll',
                    isSelected: currentConfig.presetName == 'Crunchyroll',
                    onTap: () => ref.read(subtitleSettingsNotifierProvider.notifier).updatePreset(_isFullScreenMode, 'Crunchyroll'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // MASTER SCALE
          _buildGroup(
            title: 'Master Scaling',
            subtitle: 'Resize all elements proportionally',
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _SliderRow(
                label: 'Global Scale',
                value: currentConfig.globalScale,
                min: 0.5, max: 2.0,
                color: Colors.deepPurpleAccent,
                onChanged: (v) => ref.read(subtitleSettingsNotifierProvider.notifier).updateGlobalScale(_isFullScreenMode, v),
                displayValue: '${(currentConfig.globalScale * 100).toInt()}%',
              ),
            ),
          ),

          const SizedBox(height: 24),

          _buildGroup(
            title: 'Individual Styles',
            subtitle: 'Fine-tune each line (affected by Master Scale)',
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ElementStyleRow(
                    label: 'Original',
                    fontSize: currentConfig.fontSizeOriginal,
                    isBold: currentConfig.isBoldOriginal,
                    isItalic: currentConfig.isItalicOriginal,
                    onSizeChanged: (v) => ref.read(subtitleSettingsNotifierProvider.notifier).updateFontSize(_isFullScreenMode, SubtitleElementType.original, v),
                    onBoldChanged: (v) => ref.read(subtitleSettingsNotifierProvider.notifier).updateStyleToggle(_isFullScreenMode, SubtitleElementType.original, bold: v),
                    onItalicChanged: (v) => ref.read(subtitleSettingsNotifierProvider.notifier).updateStyleToggle(_isFullScreenMode, SubtitleElementType.original, italic: v),
                  ),
                  const Divider(height: 24),
                  _ElementStyleRow(
                    label: 'Additional',
                    fontSize: currentConfig.fontSizeAdditional,
                    isBold: currentConfig.isBoldAdditional,
                    isItalic: currentConfig.isItalicAdditional,
                    onSizeChanged: (v) => ref.read(subtitleSettingsNotifierProvider.notifier).updateFontSize(_isFullScreenMode, SubtitleElementType.additional, v),
                    onBoldChanged: (v) => ref.read(subtitleSettingsNotifierProvider.notifier).updateStyleToggle(_isFullScreenMode, SubtitleElementType.additional, bold: v),
                    onItalicChanged: (v) => ref.read(subtitleSettingsNotifierProvider.notifier).updateStyleToggle(_isFullScreenMode, SubtitleElementType.additional, italic: v),
                  ),
                  const Divider(height: 24),
                  _ElementStyleRow(
                    label: 'Translation',
                    fontSize: currentConfig.fontSizeTranslation,
                    isBold: currentConfig.isBoldTranslation,
                    isItalic: currentConfig.isItalicTranslation,
                    onSizeChanged: (v) => ref.read(subtitleSettingsNotifierProvider.notifier).updateFontSize(_isFullScreenMode, SubtitleElementType.translation, v),
                    onBoldChanged: (v) => ref.read(subtitleSettingsNotifierProvider.notifier).updateStyleToggle(_isFullScreenMode, SubtitleElementType.translation, bold: v),
                    onItalicChanged: (v) => ref.read(subtitleSettingsNotifierProvider.notifier).updateStyleToggle(_isFullScreenMode, SubtitleElementType.translation, italic: v),
                  ),
                ],
              ),
            ),
          ),

          if (_isFullScreenMode) ...[
            const SizedBox(height: 24),
            // VERTICAL POSITION SLIDER
            _buildGroup(
              title: 'Subtitle Position',
              subtitle: 'Adjust vertical offset on screen',
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _SliderRow(
                  label: 'Vertical Offset',
                  value: data.fullScreen.groupOffset,
                  min: 0.0, max: 0.9,
                  color: Colors.deepPurpleAccent,
                  onChanged: (v) => ref.read(subtitleSettingsNotifierProvider.notifier).updateFsGroupOffset(v),
                  displayValue: '${(data.fullScreen.groupOffset * 100).toInt()}%',
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            // BG RGBA SLIDERS
            _buildGroup(
              title: 'Background Styling',
              subtitle: 'Enable and tune overlay colors',
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable Background', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    value: data.fullScreen.backgroundEnabled,
                    activeThumbColor: Colors.deepPurpleAccent,
                    onChanged: (v) => ref.read(subtitleSettingsNotifierProvider.notifier).updateFsBackground(v),
                  ),
                  if (data.fullScreen.backgroundEnabled) _buildRgbaSliders(data.fullScreen.backgroundColor),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildFullscreenPreview(SubtitleConfig config) {
    final SubtitleElementStyle mainStyle = config.originalStyle;
    final SubtitleElementStyle addStyle = config.additionalStyle;
    final SubtitleElementStyle transStyle = config.translationStyle;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Japanese Style Background
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=800&auto=format&fit=crop',
                      fit: BoxFit.cover,
                      errorBuilder: (_, ___, ____) => const Center(child: Icon(Icons.movie, color: Colors.white24, size: 60)),
                    ),
                  ),
                ),

                // Unified Draggable Group
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: config.groupOffset * constraints.maxHeight,
                  child: GestureDetector(
                    onVerticalDragUpdate: (d) {
                      final newOffset = (config.groupOffset - (d.primaryDelta! / constraints.maxHeight)).clamp(0.0, 0.9);
                      ref.read(subtitleSettingsNotifierProvider.notifier).updateFsGroupOffset(newOffset);
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: config.backgroundEnabled ? Color(config.backgroundColor) : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _PreviewText(
                              text: 'にほんごの がくしゅうは たのしいです',
                              fontSize: addStyle.fontSize * 0.6,
                              color: Color(addStyle.color),
                              isBold: addStyle.isBold,
                              isItalic: addStyle.isItalic,
                              isSelected: false,
                              onTap: () {},
                            ),
                            _PreviewText(
                              text: 'Learning Japanese is fun',
                              fontSize: mainStyle.fontSize * 0.6,
                              color: Color(mainStyle.color),
                              isBold: mainStyle.isBold,
                              isItalic: mainStyle.isItalic,
                              isSelected: false,
                              onTap: () {},
                            ),
                            _PreviewText(
                              text: 'Японську мову вчити цікаво',
                              fontSize: transStyle.fontSize * 0.6,
                              color: Color(transStyle.color),
                              isBold: transStyle.isBold,
                              isItalic: transStyle.isItalic,
                              isSelected: false,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const Positioned(
                  top: 8, left: 8,
                  child: Text('DRAG GROUP TO REPOSITION', style: TextStyle(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 2, color: Colors.black)])),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInteractionPreview(SubtitleConfig config) {
    final SubtitleElementStyle mainStyle = config.originalStyle;
    final SubtitleElementStyle addStyle = config.additionalStyle;
    final SubtitleElementStyle transStyle = config.translationStyle;

    return _buildGroup(
      title: 'Active Interaction Preview',
      subtitle: 'Appearance when a user clicks on a word',
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: config.backgroundEnabled ? Color(config.backgroundColor) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            _PreviewText(
              text: 'Selected Additional Text',
              fontSize: addStyle.fontSize * 0.6,
              color: Color(addStyle.selectionColor),
              isBold: addStyle.isBold,
              isItalic: addStyle.isItalic,
              isSelected: true,
              onTap: () {},
            ),
            _PreviewText(
              text: 'Selected Original Phrase',
              fontSize: mainStyle.fontSize * 0.6,
              color: Color(mainStyle.selectionColor),
              isBold: mainStyle.isBold,
              isItalic: mainStyle.isItalic,
              isSelected: true,
              onTap: () {},
            ),
            _PreviewText(
              text: 'Selected Translation',
              fontSize: transStyle.fontSize * 0.6,
              color: Color(transStyle.selectionColor),
              isBold: transStyle.isBold,
              isItalic: transStyle.isItalic,
              isSelected: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRgbaSliders(int currentColor) {
    final color = Color(currentColor);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _SliderRow(label: 'Red', value: (color.r * 255).round().toDouble(), min: 0, max: 255, color: Colors.red, onChanged: (v) => _updateColor(color.withRed(v.toInt()))),
          _SliderRow(label: 'Green', value: (color.g * 255).round().toDouble(), min: 0, max: 255, color: Colors.green, onChanged: (v) => _updateColor(color.withGreen(v.toInt()))),
          _SliderRow(label: 'Blue', value: (color.b * 255).round().toDouble(), min: 0, max: 255, color: Colors.blue, onChanged: (v) => _updateColor(color.withBlue(v.toInt()))),
          _SliderRow(label: 'Alpha', value: (color.a * 255).round().toDouble(), min: 0, max: 255, color: Colors.grey, onChanged: (v) => _updateColor(color.withAlpha(v.toInt()))),
        ],
      ),
    );
  }

  void _updateColor(Color newColor) {
    ref.read(subtitleSettingsNotifierProvider.notifier).updateFsBgColor(newColor.toARGB32());
  }

  Widget _buildGroup({required String title, required String subtitle, required Widget child}) {
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
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.black.withValues(alpha: 0.4))),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.deepPurple.shade50.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.deepPurpleAccent.withValues(alpha: 0.08), width: 1.5)),
            child: ClipRRect(borderRadius: BorderRadius.circular(20), child: child),
          ),
        ],
      ),
    );
  }
}

class _ElementStyleRow extends StatelessWidget {
  final String label;
  final double fontSize;
  final bool isBold;
  final bool isItalic;
  final ValueChanged<double> onSizeChanged;
  final ValueChanged<bool> onBoldChanged;
  final ValueChanged<bool> onItalicChanged;

  const _ElementStyleRow({
    required this.label,
    required this.fontSize,
    required this.isBold,
    required this.isItalic,
    required this.onSizeChanged,
    required this.onBoldChanged,
    required this.onItalicChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black87)),
            Row(
              children: [
                _ToggleButton(icon: Icons.format_bold, isActive: isBold, onTap: () => onBoldChanged(!isBold)),
                const SizedBox(width: 8),
                _ToggleButton(icon: Icons.format_italic, isActive: isItalic, onTap: () => onItalicChanged(!isItalic)),
              ],
            )
          ],
        ),
        const SizedBox(height: 8),
        _SliderRow(
          label: 'Size',
          value: fontSize,
          min: 10, max: 50,
          onChanged: onSizeChanged,
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleButton({required this.icon, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isActive ? Colors.deepPurpleAccent.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isActive ? Colors.deepPurpleAccent : Colors.black12),
        ),
        child: Icon(icon, size: 18, color: isActive ? Colors.deepPurpleAccent : Colors.black45),
      ),
    );
  }
}

class _PreviewText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final bool isBold;
  final bool isItalic;
  final bool isSelected;
  final VoidCallback onTap;

  const _PreviewText({
    required this.text,
    required this.fontSize,
    required this.color,
    required this.isBold,
    required this.isItalic,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
          decoration: isSelected ? TextDecoration.underline : null,
          decorationColor: color,
          shadows: const [Shadow(blurRadius: 4, color: Colors.black)],
        ),
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final Color? color;
  final ValueChanged<double> onChanged;
  final String? displayValue;

  const _SliderRow({required this.label, required this.value, required this.min, required this.max, this.color, required this.onChanged, this.displayValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
        Expanded(child: Slider(value: value.clamp(min, max), min: min, max: max, activeColor: color, onChanged: onChanged)),
        SizedBox(width: 40, child: Text(displayValue ?? value.toStringAsFixed(0), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
      ],
    );
  }
}

class _PresetTile extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetTile({required this.name, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final accent = Colors.deepPurpleAccent;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? accent.withValues(alpha: 0.05) : Colors.transparent,
          border: Border.all(color: isSelected ? accent.withValues(alpha: 0.2) : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, color: isSelected ? accent : Colors.black87)),
            if (isSelected) ...[const SizedBox(width: 6), Icon(Icons.check_circle, color: accent, size: 16)],
          ],
        ),
      ),
    );
  }
}
