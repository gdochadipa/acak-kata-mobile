import 'package:acakkata/app_lifecycle/app_lifecycle.dart';
import 'package:acakkata/controller/audio_controller.dart';
import 'package:acakkata/controller/setting_controller.dart';
import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/pages/about/about_page.dart';
import 'package:acakkata/pages/auth/profile_edit_page.dart';
import 'package:acakkata/pages/auth/signin_page.dart';
import 'package:acakkata/pages/auth/signup_page.dart';
import 'package:acakkata/pages/home_page/new_home_page.dart';
import 'package:acakkata/pages/settings/setting_page.dart';
import 'package:acakkata/pages/splash_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/change_language_provider.dart';
import 'package:acakkata/providers/connectivity_provider.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/providers/language_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/providers/socket_provider.dart';
import 'package:acakkata/setting/persistence/local_storage_setting_persistence.dart';
import 'package:acakkata/setting/persistence/setting_persistence.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void callbackDispatcher() {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  // Workmanager().registerOneOffTask("1", "simpleTask");

//run app
  runApp(MyApp(
    settingsPersistence: LocalStorageSettingPersistence(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.settingsPersistence}) : super(key: key);

  final SettingsPersistence settingsPersistence;

  @override
  Widget build(BuildContext context) {
    return AppLifeCycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(
            create: (context) => LanguageProvider(),
          ),
          ChangeNotifierProvider(create: (context) => RoomProvider()),
          ChangeNotifierProvider(create: (context) => LanguageDBProvider()),
          ChangeNotifierProvider(create: (context) => ChangeLanguageProvider()),
          ChangeNotifierProvider(create: (context) => SocketProvider()),
          ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
          Provider<SettingsController>(
              lazy: false,
              create: (context) =>
                  SettingsController(persistence: settingsPersistence)
                    ..loadStateFromPersistence()),
          ProxyProvider2<SettingsController, ValueNotifier<AppLifecycleState>,
              AudioController>(
            // Ensures that the AudioController is created on startup,
            // and not "only when it's needed", as is default behavior.
            // This way, music starts immediately.
            lazy: false,
            create: (context) => AudioController()..intialize(),
            update: (context, settings, lifecycleNotifier, audio) {
              if (audio == null) throw ArgumentError.notNull();
              audio.attachSettings(settings);
              audio.attachLifeCycleNotifier(lifecycleNotifier);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
          )
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => SplashPage(),
            '/sign-in': (context) => SignInPage(),
            '/sign-up': (context) => SignUpPage(),
            '/update-profile': (context) => ProfileEditPage(),
            '/about': (context) => AbountPage(),
            // '/home': (context) => MainPage(),
            '/home': (context) => const NewHomePage(),
            '/setting': (context) => SettingPage()
          },
          // onGenerateRoute: (setting) {

          // },
        ),
      ),
    );
  }
}
