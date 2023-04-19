import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegulationsPage extends StatefulWidget {
  const RegulationsPage({super.key});

  @override
  State<RegulationsPage> createState() => _RegulationsPageState();
}

class _RegulationsPageState extends State<RegulationsPage> {
  bool areasActive = false;
  bool zoningActive = false;
  bool guidelinesActive = false;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Text(AppLocalizations.of(context)!.reg_content_p1),
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                switch (panelIndex) {
                  case 0:
                    setState(() {
                      areasActive = !areasActive;
                    });
                    break;
                  case 1:
                    setState(() {
                      zoningActive = !zoningActive;
                    });
                    break;
                  case 2:
                    setState(() {
                      guidelinesActive = !guidelinesActive;
                    });
                    break;
                }
              },
              children: [
                ExpansionPanel(
                    headerBuilder: (context, isExpanded) => ListTile(
                          title: Text("_placeholder Protection areas"),
                        ),
                    body: areaBody(),
                    isExpanded: areasActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text("_placeholder Zoning Plan"),
                        ),
                    body: zoningPlanBody(),
                    isExpanded: zoningActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text(
                            "_placeholder Guidelines",
                          ),
                        ),
                    body: guidelinesBody(),
                    isExpanded: guidelinesActive)
              ],
            ),
          ]),
        ),
      );

  Widget areaBody() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.reg_content_p2),
            UnorderedList(texts: [
              UnorderedListItem(
                  text: AppLocalizations.of(context)!.reg_content_l1_i1,
                  color: Colors.red),
              UnorderedListItem(
                  text: AppLocalizations.of(context)!.reg_content_l1_i2,
                  color: Colors.purple),
              UnorderedListItem(
                  text: AppLocalizations.of(context)!.reg_content_l1_i3,
                  color: Colors.blue),
            ]),
            ZoomableImage(
              path: 'assets/images/regulations.png',
              label: "_placeholder Pinch to zoom",
            )
          ],
        ),
      );

  Widget zoningPlanBody() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.reg_zoningplan),
            UnorderedList(texts: [
              UnorderedListItem(
                text: AppLocalizations.of(context)!.reg_zone_1,
              ),
              UnorderedListItem(
                text: AppLocalizations.of(context)!.reg_zone_2,
              ),
              UnorderedListItem(
                text: AppLocalizations.of(context)!.reg_zone_3,
              ),
              UnorderedListItem(
                text: AppLocalizations.of(context)!.reg_zone_4,
              )
            ]),
          ],
        ),
      );

  Widget guidelinesBody() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [Text(AppLocalizations.of(context)!.reg_guidelines)],
        ),
      );
}