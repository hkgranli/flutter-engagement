import 'package:engagement/components.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:engagement/feedback.dart';
import 'package:engagement/interactive.dart';
import 'package:engagement/read.dart';

void main() {
  runApp(AppInit());
}

class AppInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
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
    if (index != 0) changeSelectedPage(context, index);
    setState(() {
      if (info) info = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget page = info ? infopage(context) : homepage(context);

    return Scaffold(
      appBar: CreateAppBar(theme, "Home"),
      body: SafeArea(child: page),
      bottomNavigationBar: CreateNavBar(theme, 0, context),
    );
  }

  Widget infopage(BuildContext context) {
    return SafeArea(child: Text("info"));
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
              "Photovoltaic Systems at Møllenberg",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            HomePageButton(appState, Icon(Icons.info), "Project info", 0),
            HomePageButton(appState, Icon(Icons.touch_app), "Interactive", 1),
            HomePageButton(appState, Icon(Icons.book), "Read", 2),
            HomePageButton(appState, Icon(Icons.feedback), "Feedback", 3),
          ],
        ),
      ),
    );
  }

  ButtonTheme HomePageButton(
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
