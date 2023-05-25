import 'package:engagement/components.dart';
import 'package:engagement/feedback.dart';
import 'package:engagement/home.dart';
import 'package:engagement/interactive.dart';
import 'package:engagement/l10n/l10n.dart';
import 'package:engagement/more.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(AppInit());
}

class AppInit extends StatefulWidget {
  @override
  State<AppInit> createState() => _AppInitState();

  // required for language
  // ignore: library_private_types_in_public_api
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
        title: 'Helios Engagement',
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
        home: Parent(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class Parent extends StatefulWidget {
  @override
  State<Parent> createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  int activePage = 0;
  Pages interactivePageState = Pages.home;

  List<Widget> activePages = [];

  void changePage(int i) {
    setState(() {
      activePage = i;
    });
  }

  void changeNavPage(int i) {
    if (activePage == i && i == 1) {
      return navigateInteractive(Pages.home);
    }
    changePage(i);
  }

  Map<int, GlobalKey> navigatorKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
  };

  void navigateInteractive(Pages page) {
    setState(() {
      activePage = 1;
      interactivePageState = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    print("Rebuild main");
    return Scaffold(
      body: WillPopScope(
        onWillPop: showExitPopup,
        child: IndexedStack(
          index: activePage,
          children: <Widget>[
            Navigator(
                key: navigatorKeys[0],
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute(
                    settings: settings,
                    builder: (BuildContext context) => HomePage(
                      grid: gridTest(),
                    ),
                  );
                }),
            Navigator(
                key: navigatorKeys[1],
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute(
                      settings: settings,
                      builder: (BuildContext context) => InteractivePage(
                            activePage: interactivePageState,
                            changePage: (p0) => navigateInteractive(p0),
                            key: GlobalKey(),
                          ));
                }),
            Navigator(
                key: navigatorKeys[2],
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute(
                    settings: settings,
                    builder: (BuildContext context) => FeedbackPage(),
                  );
                }),
            Navigator(
                key: navigatorKeys[3],
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute(
                      settings: settings,
                      builder: (BuildContext context) => MoreInfo());
                }),
          ],
        ),
      ),
      bottomNavigationBar: EngagementNavBar(
        index: activePage,
        changeParentPage: changeNavPage,
        key: GlobalKey(),
      ),
    );
  }

  Widget gridTest() => StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: [
          /*StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: ImageTile(
              index: 0,
              asset: 'assets/images/helios_logo_cool.png',
              fit: BoxFit.fitHeight,
              onPress: () => changePage(2),
            ),
          ),*/
          StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 0.75,
              child: Textile(
                text: Center(
                  child: Text("Build your knowledge of solar technology",
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
              )),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: ImageTile(
                index: 0,
                asset: 'assets/images/3d_aes.png',
                onPress: () => navigateInteractive(Pages.pvView)),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: ImageTile(
                index: 1,
                asset: 'assets/images/regulations.png',
                onPress: () => navigateInteractive(Pages.regulations)),
          ),
          StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1.5,
              child: Textile(text: shortPoints())),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: ImageTile(
                index: 2,
                asset: 'assets/images/solar_tile.png',
                onPress: () => navigateInteractive(Pages.solarTechnology)),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1.5,
            child: ImageTile(
                index: 3,
                asset: 'assets/images/3d_model_entire.png',
                onPress: () => navigateInteractive(Pages.pvView)),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: ImageTile(
                index: 3,
                asset: 'assets/images/map_overview_june.png',
                onPress: () => navigateInteractive(Pages.potential)),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: ImageTile(
                index: 3,
                asset: 'assets/images/kirkegata.png',
                onPress: () => navigateInteractive(Pages.potential)),
          ),
        ],
      );

  Widget shortPoints() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(
                    children: [WidgetSpan(child: Icon(Icons.read_more))])),
            RichText(
                text: TextSpan(
                    children: [WidgetSpan(child: Icon(Icons.gradient_sharp))])),
            RichText(
                text: TextSpan(
                    children: [WidgetSpan(child: Icon(Icons.join_left))])),
            RichText(
                text: TextSpan(
                    children: [WidgetSpan(child: Icon(Icons.tap_and_play))])),
            RichText(
                text: TextSpan(
                    children: [WidgetSpan(child: Icon(Icons.tap_and_play))])),
          ],
        ),
      );
}

class ImageTile extends StatelessWidget {
  const ImageTile({
    Key? key,
    required this.index,
    this.extent,
    this.bottomSpace,
    required this.onPress,
    required this.asset,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Function() onPress;
  final String asset;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final child = InkWell(
      onTap: () {
        print("press");
        onPress();
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FittedBox(
            fit: fit,
            clipBehavior: Clip.hardEdge,
            child: Image.asset(
              asset,
            ),
          ),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          //color: Colors.green,
        )
      ],
    );
  }
}

class Textile extends StatelessWidget {
  const Textile({
    Key? key,
    required this.text,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final Widget text;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Card(
      color: backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
      //height: extent,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: text,
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [Expanded(child: child)],
    );
  }
}
