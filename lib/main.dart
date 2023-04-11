import 'package:engagement/components.dart';
import 'package:engagement/home.dart';
import 'package:engagement/l10n/l10n.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:engagement/feedback.dart';
import 'package:engagement/interactive.dart';
import 'package:engagement/read.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(AppInit());
}

class AppInit extends StatefulWidget {
  @override
  State<AppInit> createState() => _AppInitState();

  // required for language
  static _AppInitState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppInitState>();
}

class _AppInitState extends State<AppInit> {
  Locale _locale = Locale('no', 'NO');

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        locale: _locale,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate
        ],
        supportedLocales: L10n.all,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 234, 0)),
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 255, 234, 0),
              brightness: Brightness.dark),
        ),
        themeMode: ThemeMode.system,
        initialRoute: "/",
        routes: {
          "/": (contex) => const HomePage(),
          "/interactive": (contex) => const InteractivePage(),
          "/read": (contex) => const ReadPage(),
          "/feedback": (contex) => const FeedbackPage(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}
