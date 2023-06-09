import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_compare_slider/image_compare_slider.dart';

class SolarPotential extends StatefulWidget {
  const SolarPotential({
    super.key,
    required this.pushNavbar,
  });

  final Function() pushNavbar;

  @override
  State<SolarPotential> createState() => _SolarPotentialState();
}

class _SolarPotentialState extends State<SolarPotential> {
  bool solarRadActive = false;
  bool solarPotentialActive = false;
  List<bool> selectedTime = [true, false, false, false];

  bool bakkegataActive = false;
  bool bispehaugenActive = false;
  bool roseborgActive = false;
  bool ovreActive = false;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Center(
          child: Column(children: [
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                switch (panelIndex) {
                  case 0:
                    setState(() {
                      solarRadActive = !solarRadActive;
                    });
                    break;
                  case 1:
                    setState(() {
                      solarPotentialActive = !solarPotentialActive;
                    });
                    break;
                  case 2:
                    setState(() {
                      bakkegataActive = !bakkegataActive;
                    });
                    break;
                  case 3:
                    setState(() {
                      bispehaugenActive = !bispehaugenActive;
                    });
                    break;
                  case 4:
                    setState(() {
                      roseborgActive = !roseborgActive;
                    });
                    break;
                  case 5:
                    setState(() {
                      ovreActive = !ovreActive;
                    });
                    break;
                }
              },
              children: [
                ExpansionPanel(
                    headerBuilder: (context, isExpanded) => ListTile(
                          title: Text(
                              AppLocalizations.of(context)!.solarpot_rad_intro),
                        ),
                    body: solarRadiation(),
                    canTapOnHeader: true,
                    isExpanded: solarRadActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text(
                              AppLocalizations.of(context)!.solarpot_pot_intro),
                        ),
                    body: solarPotential(),
                    canTapOnHeader: true,
                    isExpanded: solarPotentialActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text("Bakkegata"),
                        ),
                    body: bakkegata(),
                    canTapOnHeader: true,
                    isExpanded: bakkegataActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text("Bispehaugen"),
                        ),
                    body: bispehaugen(),
                    canTapOnHeader: true,
                    isExpanded: bispehaugenActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text("Rosenborg Gate"),
                        ),
                    body: rosenborg(),
                    canTapOnHeader: true,
                    isExpanded: roseborgActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text("Øvre Møllenberg"),
                        ),
                    body: ovre(),
                    canTapOnHeader: true,
                    isExpanded: ovreActive),
              ],
            ),
            //ZoomableImage(path: 'assets/images/potential.png'),
          ]),
        ),
      );

  Widget solarRadiation() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: [Text(AppLocalizations.of(context)!.solarpot_rad_p1)]),
      );

  Widget solarPotential() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          dragToSeeThing(),
          Text(AppLocalizations.of(context)!.solarpot_pot_p1)
        ]),
      );

  Widget dragToSeeThing() {
    return Column(children: [
      ToggleButtons(
        direction: Axis.horizontal,
        onPressed: (int index) {
          setState(() {
            // The button that is tapped is set to true, and the others to false.
            for (int i = 0; i < selectedTime.length; i++) {
              selectedTime[i] = i == index;
            }
          });
        },
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        constraints: const BoxConstraints(
          minHeight: 40.0,
          minWidth: 80.0,
        ),
        isSelected: selectedTime,
        children: [
          Text(AppLocalizations.of(context)!.map_mar),
          Text(AppLocalizations.of(context)!.map_june),
          Text(AppLocalizations.of(context)!.map_sep),
          Text(AppLocalizations.of(context)!.map_des),
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
    return 'assets/images/map_overview.png';
  }

  String getImageTwo() {
    String base = 'assets/images/map_overview';

    if (selectedTime[0]) {
      return "${base}_march.png";
    } else if (selectedTime[1]) {
      return "${base}_june.png";
    } else if (selectedTime[2]) {
      return "${base}_september.png";
    }

    return "${base}_des.png";
  }

  Widget bakkegata() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!.solarpot_pot_bakke),
          ZoomableImage(
            path: 'assets/images/bakkegata.png',
            pushNavbar: widget.pushNavbar,
          )
        ],
      ),
    );
  }

  Widget bispehaugen() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!.solarpot_pot_bispehaugen),
          ZoomableImage(
            path: 'assets/images/bispehaugen.png',
            pushNavbar: widget.pushNavbar,
          )
        ],
      ),
    );
  }

  Widget rosenborg() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!.solarpot_pot_rosenborg),
          ZoomableImage(
            path: 'assets/images/rosenborg.png',
            pushNavbar: widget.pushNavbar,
          )
        ],
      ),
    );
  }

  Widget ovre() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!.solarpot_pot_ovre),
          ZoomableImage(
            path: 'assets/images/ovre.png',
            pushNavbar: widget.pushNavbar,
          )
        ],
      ),
    );
  }
}
