import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/effects.dart';
import 'core/theme.dart';
import 'data/store.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'l10n/app_localizations.dart';

final store = AppStore();
final navKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(['Unbounded', 'Space Grotesk'], await rootBundle.loadString('assets/fonts/OFL.txt'));
  });
  await Future.wait([store.load(), Effects.init()]);
  runApp(const ClutchApp());
  // Re-post the lock-screen pass and widget after a restart or reboot.
  WidgetsBinding.instance.addPostFrameCallback((_) => Effects.sync(store));
}

class ClutchApp extends StatelessWidget {
  const ClutchApp({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) => MaterialApp(
          title: 'Clutch',
          navigatorKey: navKey,
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          themeMode: switch (store.themeMode) {
            'light' => ThemeMode.light,
            'dark' => ThemeMode.dark,
            _ => ThemeMode.system,
          },
          locale: store.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: store.onboarded ? const HomeScreen() : const OnboardingScreen(),
        ),
      );
}
