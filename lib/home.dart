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
  const HomePage({super.key, required this.info});
  final bool info;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  void _changeSelectedPage(int index) {
    if (index != 0) return changeSelectedPage(context, index);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const HomePage(info: true)));
  }

  @override
  Widget build(BuildContext context) {
    Widget page = widget.info ? _pageInfo(context) : _pageHome(context);
    AppBar a = widget.info
        ? infoBar(context)
        : createAppBar(context, AppLocalizations.of(context)!.home);

    return Scaffold(
      appBar: a,
      body: SingleChildScrollView(
          child: ConstrainedBox(constraints: BoxConstraints(), child: page)),
      bottomNavigationBar: EngagementNavBar(index: 0),
    );
  }

  AppBar infoBar(BuildContext context) {
    return createAppBar(
        context,
        AppLocalizations.of(context)!.p_info,
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ));
  }

  Widget _pageInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/ntnu_logo.png',
                width: 250,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(AppLocalizations.of(context)!.about_project_blockp1),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/helios_logo.png',
                width: 250,
              ),
            ),
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
          Row(children: [
            Icon(Icons.email),
            Text("Hans Kristian Granli - hkgranli@stud.ntnu.no")
          ]),
          Row(children: [
            Icon(Icons.email),
            Text("Sobah Abbas Petersen - sap@ntnu.no")
          ]),

          SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.helios_contact),

          Row(children: [
            Icon(Icons.email),
            Text("Gabrielle Lobaccaro - gabriele.lobaccaro@ntnu.no")
          ]),
          Row(children: [
            Icon(Icons.email),
            Text("Tahmineh Akbarinejad - tahmineh.akbarinejad@ntnu.no")
          ]),
        ],
      ),
    );
  }

  Widget _pageHome(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/kirkegata.png',
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
