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
import 'package:video_player/video_player.dart';

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
    Widget page = info ? infopage(context) : _homepage(context);
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
          Image.asset(
            'assets/images/ntnu_logo.png',
            width: 250,
          ),
          SizedBox(height: 15),
          Text(AppLocalizations.of(context)!.about_project_blockp1),
          Image.asset(
            'assets/images/helios_logo.png',
            width: 250,
          ),
          SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.about_project_blockp2),
          //SizedBox(height: 10),
          //Text(AppLocalizations.of(context)!.about_project_blockp3),
          SizedBox(height: 10),
          SizedBox(child: VideoApp()),
          SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.about_contact),
          SizedBox(height: 10),
          Center(
            child: UnorderedList([
              "Hans Kristian Granli - hkgranli@stud.ntnu.no",
              "Sobah Abbas Petersen - sap@ntnu.no"
            ]),
          )
        ],
      ),
    );
  }

  Widget _homepage(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/overview_crop.jpg',
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              AppLocalizations.of(context)!.homeTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            _homePageButton(appState, Icon(Icons.info),
                AppLocalizations.of(context)!.p_info, 0),
            SizedBox(height: 10),
            _homePageButton(appState, Icon(Icons.school),
                AppLocalizations.of(context)!.information, 1),
            SizedBox(height: 10),
            _homePageButton(appState, Icon(Icons.feedback),
                AppLocalizations.of(context)!.feedback, 2),
          ],
        ),
      ),
    );
  }

  Widget _homePageButton(
      MyAppState appState, Icon icon, String text, int page) {
    return OutlinedButton.icon(
      onPressed: () {
        _changeSelectedPage(page);
      },
      icon: icon,
      label: Text(text),
    );
  }
}

/// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/helios_video.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
