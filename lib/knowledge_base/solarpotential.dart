import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_compare_slider/image_compare_slider.dart';

class SolarPotential extends StatefulWidget {
  const SolarPotential({
    super.key,
  });

  @override
  State<SolarPotential> createState() => _SolarPotentialState();
}

class _SolarPotentialState extends State<SolarPotential> {
  bool solarRadActive = false;
  bool solarPotentialActive = false;
  List<bool> selectedTime = [true, false, false, false];

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
                }
              },
              children: [
                ExpansionPanel(
                    headerBuilder: (context, isExpanded) => ListTile(
                          title: Text(
                              AppLocalizations.of(context)!.solarpot_rad_intro),
                        ),
                    body: solarRadiation(),
                    isExpanded: solarRadActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text(
                              AppLocalizations.of(context)!.solarpot_pot_intro),
                        ),
                    body: solarPotential(),
                    isExpanded: solarPotentialActive),
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
}
