


import 'package:eiga/ui/navigators/appNavigator.dart';
import 'package:eiga/ui/screens/mainScreen.dart';
import 'package:eiga/ui/screens/settingsScreen.dart';
import 'package:eiga/ui/screens/videoScreen.dart';
import 'package:go_router/go_router.dart';

final GoRouter AppRouter = GoRouter(
    initialLocation: '/main',
    routes: [
      ShellRoute(
          builder: (context, state, child) => AppNavigator(
            child: child,
            showBottomBar: false,
          ),
          routes: [
            GoRoute(path: '/main', builder: (context, state) => const MainScreen()),
            GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
            GoRoute(path: '/player', builder: (context, state) => const VideoScreen()),
          ])
    ]
);