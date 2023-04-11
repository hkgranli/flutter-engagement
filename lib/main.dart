import 'package:engagement/components.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  var info = false;

  void _changeSelectedPage(int index) {
    if (index != 0) return changeSelectedPage(context, index);
    setState(() {
      info = !info;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page = info ? infopage(context) : homepage(context);
    AppBar a = info ? infoBar(context) : createAppBar(context, "Home");

    return Scaffold(
      appBar: a,
      body: SingleChildScrollView(
          child: ConstrainedBox(constraints: BoxConstraints(), child: page)),
      bottomNavigationBar: createNavBar(0, context),
    );
  }

  AppBar infoBar(BuildContext context) {
    return createAppBar(
        context,
        "Project Info",
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _changeSelectedPage(0),
        ));
  }

  Widget infopage(BuildContext context) {
    return Center(child: Text("info"));
  }

  Widget homepage(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/overview_crop.jpg',
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              AppLocalizations.of(context)!.homeTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            homePageButton(appState, Icon(Icons.info), "Project info", 0),
            SizedBox(height: 10),
            homePageButton(appState, Icon(Icons.touch_app), "Interactive", 1),
            SizedBox(height: 10),
            homePageButton(appState, Icon(Icons.book), "Read", 2),
            SizedBox(height: 10),
            homePageButton(appState, Icon(Icons.feedback), "Feedback", 3),
          ],
        ),
      ),
    );
  }

  ButtonTheme homePageButton(
      MyAppState appState, Icon icon, String text, int page) {
    return ButtonTheme(
      minWidth: 300.0,
      height: 100.0,
      child: OutlinedButton(
          onPressed: () {
            _changeSelectedPage(page);
          },
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [icon, Text(text)])),
    );
  }
}
