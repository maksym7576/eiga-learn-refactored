import 'package:eiga/providers/localStoragesProviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  }

  void _openSettingDialog(
    BuildContext context, {
    required String title,
    required WidgetBuilder builder,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'SettingsDialog',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Padding(
            padding: const EdgeInsetsGeometry.symmetric(horizontal: 24),
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
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


  Widget _apiKeyView(BuildContext context) {
    final tokenAsync = ref.watch(tokenProvider);
    final notifier = ref.read(tokenProvider.notifier);

    return tokenAsync.when(
      data: (String token) {
        final bool hasToken = token.isNotEmpty;
        final controller = TextEditingController(text: token);

        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Api key',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [Colors.deepPurpleAccent.shade100, Colors.deepPurple.shade100],
                ),
                border: Border.all(color: Colors.deepPurpleAccent.shade200, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurpleAccent.shade100,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.deepPurpleAccent.shade200,
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
                            color: Colors.deepPurpleAccent.shade700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hasToken ? token : 'add api key',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.deepPurpleAccent.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'input new key',
                border: OutlineInputBorder(),
                fillColor: Colors.deepPurpleAccent.shade100,
              ),
            ),
            SizedBox(height: 12),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          hasToken ? 'Update' : 'Add Key',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                    ),
                ),
                if (hasToken) ... [
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await notifier.deleteToken();
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error')),
    );
  }

  Widget _settingsButton(
    BuildContext context, {
    required String title,
    required WidgetBuilder dialogBuilder,
  }) {
    return Material(
      child: ElevatedButton(
        onPressed: () =>
            _openSettingDialog(context, title: title, builder: dialogBuilder),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      children: [
        Row(
          children: [
            Expanded(
              child: _settingsButton(
                context,
                title: 'Api key',
                dialogBuilder: _apiKeyView,
              ),
            ),
            const SizedBox(width: 5),
            // Expanded(
            //   // child: _settingsButton(Colors.deepPurpleAccent, 'Max Limit'),
            // ),
          ],
        ),
      ],
    );
  }
}
