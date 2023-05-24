import 'package:engagement/feedback.dart';
import 'package:engagement/home.dart';
import 'package:engagement/interactive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:engagement/main.dart';
import 'package:flutter_circle_flags_svg/flutter_circle_flags_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EngagementNavBar extends StatelessWidget {
  const EngagementNavBar({super.key, required this.index});

  final int index;

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
            label: "My Opinion",
          ),
          NavigationDestination(
            icon: Icon(Icons.info),
            label: "More",
          ),
        ],
        selectedIndex: index,
        onDestinationSelected: (int index) =>
            changeSelectedPage(context, index),
      );
}

void changeSelectedPage(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const HomePage(info: false)));
      break;
    case 1:
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InteractivePage(activePage: Pages.home)));
      break;
    case 2:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FeedbackPage()));
      break;
    default:
      return;
  }
  // ensure we dont navigate to the same page we are at
  //if (ModalRoute.of(context)?.settings.name == path) return;
  //Navigator.pushNamed(context, path);

  /*
  Widget page;

  switch (index) {
    case 0:
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePage(
                    info: false,
                  )));
      break;
    case 1:
      page = InteractivePage();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const InteractivePage()));
      break;
    case 2:
      //page = FeedbackPage();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FeedbackPage()));
      break;
    default:
      print("$index wtf");
      return;
  }*/
}

AppBar createAppBar(BuildContext context, String title,
    [IconButton? leadingButton, TabBar? tabs]) {
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

  return AppBar(
    title: Text(title),
    leading: leadingButton,
    automaticallyImplyLeading: false,
    bottom: tabs,
    actions: <Widget>[flag],
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
    return Column(
      children: [
        InteractiveViewer(
          panEnabled: false,
          boundaryMargin: EdgeInsets.fromLTRB(0, 200, 0, 200),
          maxScale: 3,
          minScale: 1,
          child: Image.asset(
            path,
          ),
        ),
        Text(l, style: Theme.of(context).textTheme.labelSmall)
      ],
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
