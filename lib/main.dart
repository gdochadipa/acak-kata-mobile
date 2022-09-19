import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/pages/about/about_page.dart';
import 'package:acakkata/pages/auth/profile_edit_page.dart';
import 'package:acakkata/pages/auth/signin_page.dart';
import 'package:acakkata/pages/auth/signup_page.dart';
import 'package:acakkata/pages/home_page/new_home_page.dart';
import 'package:acakkata/pages/splash_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/change_language_provider.dart';
import 'package:acakkata/providers/connectivity_provider.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/providers/language_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/providers/socket_provider.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        ),
        ChangeNotifierProvider(create: (context) => RoomProvider()),
        ChangeNotifierProvider(create: (context) => LanguageDBProvider()),
        ChangeNotifierProvider(create: (context) => ChangeLanguageProvider()),
        ChangeNotifierProvider(create: (context) => SocketProvider()),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider())
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
        },
        // onGenerateRoute: (setting) {

        // },
      ),
    );
  }
}
