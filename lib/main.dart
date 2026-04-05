import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:eiga/providers/modelsProviders.dart';
import 'package:eiga/providers/packageProviders.dart';
import 'package:eiga/ui/navigators/appRouter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      PhraseObjectSchema,
      VideoObjectSchema,
    ],
    directory: dir.path,
  );

  runApp(
      ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            isarProvider.overrideWithValue(isar),
          ],
          child: MyApp()
      ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: AppRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
    );
  }
}
