import 'package:engagement/feedback.dart';
import 'package:engagement/interactive.dart';
import 'package:engagement/read.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:engagement/main.dart';

BottomNavigationBar CreateNavBar(
    ThemeData theme, int index, BuildContext context) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.touch_app),
        label: 'Interactive',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.book_online),
        label: 'Readable',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.feedback),
        label: 'Feedback',
      ),
    ],
    currentIndex: index,
    selectedItemColor: theme.colorScheme.primary,
    unselectedItemColor: theme.colorScheme.secondary,
    showUnselectedLabels: true,
    onTap: (int index) => changeSelectedPage(context, index),
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

AppBar CreateAppBar(ThemeData theme, String title,
    [IconButton? leadingButton, TabBar? tabs, List<Widget>? actions]) {
  return AppBar(
    title: Text(title),
    backgroundColor: theme.secondaryHeaderColor,
    titleTextStyle: theme.appBarTheme.titleTextStyle,
    leading: leadingButton,
    automaticallyImplyLeading: false,
    bottom: tabs,
    actions: actions,
  );
}
