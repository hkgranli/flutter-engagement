import 'package:engagement/feedback.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:engagement/main.dart';
import 'package:flutter_circle_flags_svg/flutter_circle_flags_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';

class EngagementNavBar extends StatefulWidget {
  const EngagementNavBar(
      {super.key, required this.index, required this.changeParentPage});

  final int index;
  final Function(int) changeParentPage;

  @override
  State<EngagementNavBar> createState() => _EngagementNavBarState();
}

class _EngagementNavBarState extends State<EngagementNavBar> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  void setIndex(int i) {
    setState(() {
      index = i;
    });
  }

  @override
  Widget build(BuildContext context) => NavigationBar(
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home),
              label: AppLocalizations.of(context)!.home,
            ),
            NavigationDestination(
              icon: Icon(Icons.school),
              label: AppLocalizations.of(context)!.information,
            ),
            NavigationDestination(
              icon: Icon(Icons.feedback),
              label: AppLocalizations.of(context)!.my_opinion,
            ),
            NavigationDestination(
              icon: Icon(Icons.info),
              label: AppLocalizations.of(context)!.more,
            ),
          ],
          selectedIndex: index,
          onDestinationSelected: (int index) {
            setIndex(index);
            widget.changeParentPage(index);
            //changeSelectedPage(context, index);
          });
}

SliverAppBar createSliverBar(BuildContext context, bool pinned, bool snap,
    bool floating, Widget text, Widget background) {
  String langCode;

  if (Localizations.localeOf(context).toString() == 'no') {
    langCode = 'gb';
  } else {
    langCode = 'no';
  }

  Widget flag = IconButton(
    icon: CircleFlag(
      langCode,
      size: 25,
    ),
    onPressed: () {
      AppInit.of(context)
          ?.setLocale(Locale.fromSubtags(languageCode: langCode));
    },
  );

  return SliverAppBar.large(
    pinned: pinned,
    snap: snap,
    floating: floating,
    expandedHeight: 160.0,
    collapsedHeight: 90,
    flexibleSpace: FlexibleSpaceBar(
      title: text,
      background: background,
      centerTitle: true,
    ),
    actions: [flag],
  );
}

AppBar createAppBar(BuildContext context, String title,
    [IconButton? leadingButton,
    TabBar? tabs,
    Color? color,
    double? elevation = 1]) {
  String langCode;

  if (Localizations.localeOf(context).toString() == 'no') {
    langCode = 'gb';
  } else {
    langCode = 'no';
  }

  Widget flag = IconButton(
    icon: CircleFlag(
      langCode,
      size: 25,
    ),
    onPressed: () {
      AppInit.of(context)
          ?.setLocale(Locale.fromSubtags(languageCode: langCode));
    },
  );

  if (color != null) {
    return AppBar(
      title: Text(title),
      leading: leadingButton,
      automaticallyImplyLeading: false,
      bottom: tabs,
      actions: <Widget>[flag],
      elevation: elevation,
      backgroundColor: color,
      key: UniqueKey(),
    );
  }

  return AppBar(
    title: Text(title),
    leading: leadingButton,
    automaticallyImplyLeading: false,
    bottom: tabs,
    actions: <Widget>[flag],
    elevation: elevation ?? 1,
    key: UniqueKey(),
  );
}

//  https://stackoverflow.com/questions/51690067/how-can-i-write-a-paragraph-with-bullet-points-using-flutter

class UnorderedList extends StatelessWidget {
  UnorderedList({required this.texts, this.inline = false});
  final List<UnorderedListItem> texts;
  final bool inline;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(text);
      // Add space between items
      widgetList.add(SizedBox(height: 5.0));
    }
    return inline
        ? Wrap(
            children: widgetList,
          )
        : Column(children: widgetList);
  }
}

class UnorderedListItemInline extends StatelessWidget
    implements UnorderedListItem {
  UnorderedListItemInline({required this.text, this.color});
  @override
  final String text;
  @override
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var pre = color != null
        ? Icon(Icons.fiber_manual_record, color: color)
        : Icon(Icons.fiber_manual_record);
    return Wrap(
      children: <Widget>[
        pre,
        Text(text),
      ],
    );
  }
}

class UnorderedListItem extends StatelessWidget {
  UnorderedListItem({required this.text, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var pre = color != null
        ? Icon(Icons.fiber_manual_record, color: color)
        : Icon(Icons.fiber_manual_record);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        pre,
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }
}

class ZoomableImage extends StatelessWidget {
  ZoomableImage({super.key, required this.path, this.label});

  final String path;
  final String? label;

  @override
  Widget build(BuildContext context) {
    String l = label != null
        ? label as String
        : AppLocalizations.of(context)!.image_pinch_zoom;
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) {
        return DetailScreen(
          asset: path,
        );
      })),
      child: Column(
        children: [
          Hero(
            tag: path,
            child: InteractiveViewer(
              panEnabled: false,
              boundaryMargin: EdgeInsets.fromLTRB(0, 200, 0, 200),
              maxScale: 3,
              minScale: 1,
              child: Image.asset(
                path,
              ),
            ),
          ),
          Text(l, style: Theme.of(context).textTheme.labelSmall)
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: asset,
            child: InteractiveViewer(
              maxScale: 3,
              minScale: 1,
              child: SizedBox(
                height: double.infinity,
                child: Image.asset(
                  asset,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EngagementTable extends StatelessWidget {
  const EngagementTable(
      {super.key,
      required this.titles,
      required this.data,
      this.titleStyled = true});

  final List<String> titles;
  final List<List<Widget>> data;
  final bool titleStyled;

  @override
  Widget build(BuildContext context) {
    List<DataColumn> dc = [];

    for (var t in titles) {
      dc.add(DataColumn(
          label: Expanded(
        child: Text(t,
            style: titleStyled
                ? TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: Theme.of(context).textTheme.labelSmall!.fontSize)
                : TextStyle()),
      )));
    }

    List<DataRow> dr = [];

    for (var row in data) {
      List<DataCell> d = [];

      for (var item in row) {
        d.add(DataCell(
            //Text(item, style: Theme.of(context).textTheme.labelSmall)
            item));
      }

      dr.add(DataRow(cells: d));
    }

    return SingleChildScrollView(child: DataTable(columns: dc, rows: dr));
  }
}

double barChartTotal(List<BarChartGroupData> list) {
  double total = 0;

  for (var f in list) {
    total += f.barRods[0].toY;
  }

  return total;
}

List<Widget> stringListToTextList(List<String> strings) {
  List<Widget> textList = [];

  for (var s in strings) {
    textList.add(Text(s));
  }
  return textList;
}

List<List<Widget>> twoDimStringToText(List<List<String>> strings) {
  List<List<Widget>> textList = [];

  for (var s in strings) {
    textList.add(stringListToTextList(s));
  }

  return textList;
}

/// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  State<VideoApp> createState() => _VideoAppState();
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
