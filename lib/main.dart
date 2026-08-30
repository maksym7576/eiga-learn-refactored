import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:eiga/providers/modelsProviders.dart';
import 'package:eiga/providers/packageProviders.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/themeProvider.dart';
import 'package:eiga/ui/navigators/appRouter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  final prefs = await SharedPreferences.getInstance();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      PhraseObjectSchema,
      VideoObjectSchema,
      BlockObjectSchema,
      WordObjectSchema,
    ],
    directory: dir.path,
  );

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      isarProvider.overrideWithValue(isar),
    ]
  );

  await container.read(phraseServiceProvider).resetAllTranslatingStatuses();

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
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      routerConfig: AppRouter,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
    );
  }
}
