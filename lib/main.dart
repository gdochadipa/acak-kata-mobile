import 'package:acakkata/pages/auth/signin_page.dart';
import 'package:acakkata/pages/auth/signup_page.dart';
import 'package:acakkata/pages/home_page/main.dart';
import 'package:acakkata/pages/splash_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashPage(),
          '/sign-in': (context) => SignInPage(),
          '/sign-up': (context) => SignUpPage(),
          '/home': (context) => MainPage(),
        },
        // onGenerateRoute: (setting) {

        // },
      ),
    );
  }
}
