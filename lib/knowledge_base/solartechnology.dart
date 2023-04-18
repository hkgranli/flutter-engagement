import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart' show ModelViewer;
import 'package:engagement/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_compare_slider/image_compare_slider.dart';

class SolarTechnology extends StatefulWidget {
  const SolarTechnology({
    super.key,
  });

  @override
  State<SolarTechnology> createState() => _SolarTechnologyState();
}

class _SolarTechnologyState extends State<SolarTechnology> {
  bool monoCrystalActive = false;
  bool polyCrystalActive = false;
  bool thinFilmActive = false;
  bool showcaseOld = false;
  bool showcaseNew = false;

  bool trad = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
                "_placeholder. There are three main PV-systems available: Monocrystalline, Polycrystaline and Thin film. "),
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                switch (panelIndex) {
                  case 0:
                    setState(() {
                      monoCrystalActive = !monoCrystalActive;
                    });
                    break;
                  case 1:
                    setState(() {
                      polyCrystalActive = !polyCrystalActive;
                    });
                    break;
                  case 2:
                    setState(() {
                      thinFilmActive = !thinFilmActive;
                    });
                    break;
                  case 3:
                    setState(() {
                      showcaseOld = !showcaseOld;
                    });
                    break;
                  case 4:
                    setState(() {
                      showcaseNew = !showcaseNew;
                    });
                    break;
                }
              },
              children: [
                ExpansionPanel(
                    headerBuilder: (context, isExpanded) => ListTile(
                          title: Text(
                            "Monocrystalline",
                          ),
                        ),
                    body: Text(AppLocalizations.of(context)!
                        .social_sustainability_content),
                    isExpanded: monoCrystalActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text("Polycrystaline"),
                        ),
                    body: Text(
                        AppLocalizations.of(context)!.economic_sustainability),
                    isExpanded: polyCrystalActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text("Thin Film"),
                        ),
                    body: Text(AppLocalizations.of(context)!
                        .environmental_sustainability_content),
                    isExpanded: thinFilmActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text("Example Kirkegata 35"),
                        ),
                    body: kirkegata35(),
                    isExpanded: showcaseOld),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text("Example Berggate 4B"),
                        ),
                    body: berggate(),
                    isExpanded: showcaseNew)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget berggate() {
    return Column(
      children: [
        ZoomableImage(path: 'assets/images/berggate4b-default.png'),
        ZoomableImage(path: 'assets/images/berggate4b-trad-panel.png'),
        ZoomableImage(path: 'assets/images/berggate4b-alt-panel.png')
      ],
    );
  }

  Widget kirkegata35() {
    return Column(children: [
      Text("_placeholder Drag to see - (House without tiles on the left)"),
      OutlinedButton(
          onPressed: () => setState(() {
                trad = !trad;
              }),
          child: Text(!trad ? "Traditional panel" : "Colored panel")),
      ImageCompareSlider(
        itemOne: Image.asset('assets/images/kirkegata35-default.png'),
        itemTwo: Image.asset(trad
            ? 'assets/images/kirkegata35-trad-panel.png'
            : 'assets/images/kirkegata35-alt-panel.png'),
        itemOneBuilder: (child, context) => IntrinsicHeight(child: child),
        itemTwoBuilder: (child, context) => IntrinsicHeight(child: child),
      )
      /*ZoomableImage(path: 'assets/images/kirkegata35-default.png'),
            ZoomableImage(path: 'assets/images/kirkegata35-trad-panel.png'),
            ZoomableImage(path: 'assets/images/kirkegata35-alt-panel.png'),*/
    ]);
  }
}
