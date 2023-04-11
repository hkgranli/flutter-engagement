import 'package:engagement/components.dart';
import 'package:engagement/home.dart';
import 'package:engagement/l10n/l10n.dart';
import 'package:engagement/main.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:engagement/feedback.dart';
import 'package:engagement/interactive.dart';
import 'package:engagement/read.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    AppBar a = info
        ? infoBar(context)
        : createAppBar(context, AppLocalizations.of(context)!.home);

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
        AppLocalizations.of(context)!.p_info,
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _changeSelectedPage(0),
        ));
  }

  Widget infopage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!.about_project_blockp1),
          SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.about_project_blockp2),
          SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.about_project_blockp3)
        ],
      ),
    );
    /*return RichText(
        text: TextSpan(style: Theme.of(context).textTheme, children: [
      TextSpan(text: AppLocalizations.of(context)!.about_project_blockp1),
      TextSpan(text: AppLocalizations.of(context)!.about_project_blockp2),
      TextSpan(text: AppLocalizations.of(context)!.about_project_blockp3)
    ]));*/
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
            homePageButton(appState, Icon(Icons.info),
                AppLocalizations.of(context)!.p_info, 0),
            SizedBox(height: 10),
            homePageButton(appState, Icon(Icons.book),
                AppLocalizations.of(context)!.interactive, 1),
            SizedBox(height: 10),
            SizedBox(height: 10),
            homePageButton(appState, Icon(Icons.feedback),
                AppLocalizations.of(context)!.feedback, 3),
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
