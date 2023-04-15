import 'package:engagement/feedback.dart';
import 'package:engagement/home.dart';
import 'package:engagement/interactive.dart';
import 'package:flutter/material.dart';
import 'package:engagement/main.dart';
import 'package:flutter_circle_flags_svg/flutter_circle_flags_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

NavigationBar createNavBar(int index, BuildContext context) {
  var theme = Theme.of(context);
  return NavigationBar(
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
        label: AppLocalizations.of(context)!.feedback,
      ),
    ],
    selectedIndex: index,
    onDestinationSelected: (int index) => changeSelectedPage(context, index),
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
  UnorderedList(this.texts);
  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(UnorderedListItem(text));
      // Add space between items
      widgetList.add(SizedBox(height: 5.0));
    }

    return Column(children: widgetList);
  }
}

class UnorderedListItem extends StatelessWidget {
  UnorderedListItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("• "),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }
}
