import 'package:flutter/material.dart';
import 'package:engagement/main.dart';
import 'package:flutter_circle_flags_svg/flutter_circle_flags_svg.dart';

NavigationBar createNavBar(int index, BuildContext context) {
  var theme = Theme.of(context);
  return NavigationBar(
    destinations: const <NavigationDestination>[
      NavigationDestination(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.touch_app),
        label: 'Interactive',
      ),
      NavigationDestination(
        icon: Icon(Icons.book_online),
        label: 'Readable',
      ),
      NavigationDestination(
        icon: Icon(Icons.feedback),
        label: 'Feedback',
      ),
    ],
    selectedIndex: index,
    onDestinationSelected: (int index) => changeSelectedPage(context, index),
  );
}

void changeSelectedPage(BuildContext context, int index) {
  String path;
  switch (index) {
    case 0:
      path = "/";
      break;
    case 1:
      path = "/interactive";
      break;
    case 2:
      path = "/read";
      break;
    case 3:
      path = "/feedback";
      break;
    default:
      print("$index wtf");
      return;
  }
  // ensure we dont navigate to the same page we are at
  if (ModalRoute.of(context)?.settings.name == path) return;
  Navigator.pushNamed(context, path);
}

AppBar createAppBar(BuildContext context, String title,
    [IconButton? leadingButton, TabBar? tabs]) {
  Widget flag;

  //print(Localizations.localeOf(context).toLanguageTag());

  if (Localizations.localeOf(context).toString() == 'no') {
    flag = IconButton(
      icon: CircleFlag(
        'gb',
        size: 30,
      ),
      onPressed: () {
        AppInit.of(context)?.setLocale(Locale.fromSubtags(languageCode: 'en'));
      },
    );
  } else {
    flag = IconButton(
      icon: CircleFlag(
        'no',
        size: 30,
      ),
      onPressed: () {
        AppInit.of(context)?.setLocale(Locale.fromSubtags(languageCode: 'no'));
      },
    );
  }

  var theme = Theme.of(context);
  return AppBar(
    title: Text(title),
    leading: leadingButton,
    automaticallyImplyLeading: false,
    bottom: tabs,
    actions: <Widget>[flag],
    key: UniqueKey(),
  );
}
