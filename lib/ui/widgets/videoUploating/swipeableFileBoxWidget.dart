import 'package:flutter/material.dart';

class FileBoxVariant {
  final String label;
  final String? path;
  final IconData icon;
  final VoidCallback onTap;

  FileBoxVariant({
    required this.label,
    required this.path,
    required this.icon,
    required this.onTap,
  });
}

class SwipeableFileBox extends StatefulWidget {
  final List<FileBoxVariant> variants;
  const SwipeableFileBox({super.key, required this.variants});

  @override
  State<SwipeableFileBox> createState() => _SwipeableFileBoxState();
}

class _SwipeableFileBoxState extends State<SwipeableFileBox> {
  final _controller = PageController();
  int _page = 0;

  Widget _buildFileBox({required String label, required String? path, required IconData icon, required VoidCallback onTap}) {
    final isPicked = path != null;
    final fileName = isPicked ? path.split('/').last : null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCirc,
        height: 120,
        decoration: BoxDecoration(
          color: isPicked ? Colors.deepPurpleAccent.withOpacity(0.08) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isPicked ? Colors.deepPurpleAccent : Colors.deepPurple.withOpacity(0.25),
            width: isPicked ? 2.0 : 1.5,
          ),
          boxShadow: isPicked
              ? [BoxShadow(color: Colors.deepPurpleAccent.withOpacity(0.12), blurRadius: 12, spreadRadius: 2)]
              : [],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: isPicked
                ? Column(
              key: const ValueKey('picked'),
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.deepPurpleAccent, size: 36),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    fileName ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, color: Colors.deepPurpleAccent, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )
                : Column(
              key: const ValueKey('empty'),
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.deepPurpleAccent.withOpacity(0.35), size: 36),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(fontSize: 13, color: Colors.deepPurpleAccent.withOpacity(0.45), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.variants.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) {
              final v = widget.variants[i];
              return _buildFileBox(label: v.label, path: v.path, icon: v.icon, onTap: v.onTap);
            },
          ),
          if (widget.variants.length > 1)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.variants.length, (i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    width: active ? 14 : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: active
                          ? Colors.deepPurpleAccent
                          : Colors.deepPurpleAccent.withOpacity(0.25),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}