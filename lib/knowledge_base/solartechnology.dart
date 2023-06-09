import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_compare_slider/image_compare_slider.dart';

class SolarTechnology extends StatefulWidget {
  const SolarTechnology({
    super.key,
    required this.pushNavbar,
  });

  final Function() pushNavbar;

  @override
  State<SolarTechnology> createState() => _SolarTechnologyState();
}

class _SolarTechnologyState extends State<SolarTechnology> {
  bool cellTypesActive = false;
  bool solarRoofTilesActive = false;
  bool transparentPvActive = false;
  bool coloredPvActive = false;
  bool showcaseOld = false;
  bool showcaseOther = false;

  List<bool> houseSelect = [true, false];
  List<bool> panelSelect = [true, false];

  List<bool> cellSelect = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.solar_technology_intro),
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                print(panelIndex);
                switch (panelIndex) {
                  case 0:
                    setState(() {
                      cellTypesActive = !cellTypesActive;
                    });
                    break;
                  case 1:
                    setState(() {
                      solarRoofTilesActive = !solarRoofTilesActive;
                    });
                    break;
                  case 2:
                    setState(() {
                      transparentPvActive = !transparentPvActive;
                    });
                    break;
                  case 3:
                    setState(() {
                      coloredPvActive = !coloredPvActive;
                    });
                    break;
                  case 4:
                    setState(() {
                      showcaseOld = !showcaseOld;
                    });
                    break;
                  case 5:
                    setState(() {
                      showcaseOther = !showcaseOther;
                    });
                    break;
                }
              },
              children: [
                ExpansionPanel(
                    headerBuilder: (context, isExpanded) => ListTile(
                          title: Text(AppLocalizations.of(context)!
                              .solar_technology_cell_types_header),
                        ),
                    body: cellTypesBody(),
                    canTapOnHeader: true,
                    isExpanded: cellTypesActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text(AppLocalizations.of(context)!
                              .solar_technology_tiles_header),
                        ),
                    body: solarRoofTilesBody(),
                    canTapOnHeader: true,
                    isExpanded: solarRoofTilesActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text(AppLocalizations.of(context)!
                              .solar_technology_transparent_header),
                        ),
                    body: transparentPvBody(),
                    canTapOnHeader: true,
                    isExpanded: transparentPvActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text(AppLocalizations.of(context)!
                              .solar_technology_colored_header),
                        ),
                    body: coloredPvBody(),
                    canTapOnHeader: true,
                    isExpanded: coloredPvActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text(
                              AppLocalizations.of(context)!.solartech_moll_ex),
                        ),
                    body: exampleShow(),
                    canTapOnHeader: true,
                    isExpanded: showcaseOld),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text(
                              AppLocalizations.of(context)!.solartech_ex_world),
                        ),
                    body: exampleOther(),
                    canTapOnHeader: true,
                    isExpanded: showcaseOther),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cellTypesBody() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!
                .solar_technology_cell_types_intro),
            SizedBox(
              height: 10,
            ),
            ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < cellSelect.length; i++) {
                    cellSelect[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: cellSelect,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Monocrystalline"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Polycrystalline"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Thin film"),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            cellSelect[0] ? mono() : Container(),
            cellSelect[1] ? poly() : Container(),
            cellSelect[2] ? thin() : Container(),
          ],
        ),
      );

  Widget mono() => Column(
        children: [
          Text(AppLocalizations.of(context)!.solar_technology_cell_types_p1),
          SizedBox(
            height: 10,
          ),
          ZoomableImage(
            path: 'assets/images/tech_mono.png',
            pushNavbar: widget.pushNavbar,
          )
        ],
      );

  Widget poly() => Column(
        children: [
          Text(AppLocalizations.of(context)!.solar_technology_cell_types_p2),
          SizedBox(
            height: 10,
          ),
          ZoomableImage(
              path: 'assets/images/tech_poly.png',
              pushNavbar: widget.pushNavbar)
        ],
      );

  Widget thin() => Column(
        children: [
          Text(AppLocalizations.of(context)!.solar_technology_cell_types_p3),
          SizedBox(
            height: 10,
          ),
          ZoomableImage(
              path: 'assets/images/tech_thin.jpg',
              pushNavbar: widget.pushNavbar)
        ],
      );

  Widget solarRoofTilesBody() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.solar_technology_tiles_p1),
            ZoomableImage(
                path: 'assets/images/solar_tile.png',
                pushNavbar: widget.pushNavbar)
          ],
        ),
      );

  Widget transparentPvBody() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.solar_technology_transparent_p1),
            ZoomableImage(
                path: 'assets/images/transparent.png',
                pushNavbar: widget.pushNavbar)
          ],
        ),
      );

  Widget coloredPvBody() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.solar_technology_colored_p1),
            Text(AppLocalizations.of(context)!.solar_technology_colored_p2),
            ZoomableImage(
                path: 'assets/images/color_pv.png',
                pushNavbar: widget.pushNavbar),
            Text(AppLocalizations.of(context)!.solar_technology_colored_p3),
          ],
        ),
      );

  Widget exampleOther() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ZoomableImage(
                path: 'assets/images/rt.jpg', pushNavbar: widget.pushNavbar),
            SizedBox(
              height: 10,
            ),
            Text(AppLocalizations.of(context)!.ex_rt)
          ],
        ),
      );

  Widget exampleShow() {
    return Column(children: [
      ToggleButtons(
        direction: Axis.horizontal,
        onPressed: (int index) {
          setState(() {
            // The button that is tapped is set to true, and the others to false.
            for (int i = 0; i < houseSelect.length; i++) {
              houseSelect[i] = i == index;
            }
          });
        },
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        constraints: const BoxConstraints(
          minHeight: 40.0,
          minWidth: 80.0,
        ),
        isSelected: houseSelect,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Kirkegata 35"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Nordre Berggate 4B"),
          )
        ],
      ),
      SizedBox(
        height: 10,
      ),
      ToggleButtons(
        direction: Axis.horizontal,
        onPressed: (int index) {
          setState(() {
            // The button that is tapped is set to true, and the others to false.
            for (int i = 0; i < panelSelect.length; i++) {
              panelSelect[i] = i == index;
            }
          });
        },
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        constraints: const BoxConstraints(
          minHeight: 40.0,
          minWidth: 80.0,
        ),
        isSelected: panelSelect,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Monocrystalline panel"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Colored Panel"),
          )
        ],
      ),
      SizedBox(
        height: 10,
      ),
      ImageCompareSlider(
        itemOne: Image.asset(getImageOne()),
        itemTwo: Image.asset(getImageTwo()),
        itemOneBuilder: (child, context) => IntrinsicHeight(child: child),
        itemTwoBuilder: (child, context) => IntrinsicHeight(child: child),
      )
      /*ZoomableImage(path: 'assets/images/kirkegata35-default.png'),
            ZoomableImage(path: 'assets/images/kirkegata35-trad-panel.png'),
            ZoomableImage(path: 'assets/images/kirkegata35-alt-panel.png'),*/
    ]);
  }

  String getImageOne() {
    return houseSelect[0]
        ? 'assets/images/kirkegata35-default.png'
        : 'assets/images/berggate4b-default.png';
  }

  String getImageTwo() {
    String base = houseSelect[0]
        ? 'assets/images/kirkegata35'
        : 'assets/images/berggate4b';

    return panelSelect[0] ? '$base-trad-panel.png' : '$base-alt-panel.png';
  }
}
