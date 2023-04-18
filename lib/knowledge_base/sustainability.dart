import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart' show ModelViewer;
import 'package:engagement/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_compare_slider/image_compare_slider.dart';

class PageSustainability extends StatefulWidget {
  const PageSustainability({
    super.key,
  });

  @override
  State<PageSustainability> createState() => _PageSustainabilityState();
}

class _PageSustainabilityState extends State<PageSustainability> {
  bool socialActive = false;
  bool ecoActive = false;
  bool envActive = false;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(children: [
              Text(
                  "${AppLocalizations.of(context)!.sus_content_p1} ${AppLocalizations.of(context)!.social_sustainability}, ${AppLocalizations.of(context)!.sus_eco}, ${AppLocalizations.of(context)!.sus_env}"),
              /*UnorderedList([
                AppLocalizations.of(context)!.social_sustainability,
                AppLocalizations.of(context)!.sus_eco,
                AppLocalizations.of(context)!.sus_env,
              ]),

              ExpansionPanelList(
          expansionCallback: (panelIndex, isExpanded) =>
              toggleDropdownSideSelector(),
          children: [
            ExpansionPanel(
                headerBuilder: (context, isExpanded) => ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.roof_sides,
                      ),
                    ),
                body: Column(children: _sideSelector(context)),
                isExpanded: _dropdownSideSelectorActive),
          ],
        ),
              
              
              */
              Divider(),
              ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) {
                  switch (panelIndex) {
                    case 0:
                      setState(() {
                        socialActive = !socialActive;
                      });
                      break;
                    case 1:
                      setState(() {
                        ecoActive = !ecoActive;
                      });
                      break;
                    case 2:
                      setState(() {
                        envActive = !envActive;
                      });
                      break;
                  }
                },
                children: [
                  ExpansionPanel(
                      headerBuilder: (context, isExpanded) => ListTile(
                            title: Text(
                              AppLocalizations.of(context)!
                                  .social_sustainability,
                            ),
                          ),
                      body: Text(AppLocalizations.of(context)!
                          .social_sustainability_content),
                      isExpanded: socialActive),
                  ExpansionPanel(
                      headerBuilder: (_, __) => ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.sus_eco,
                            ),
                          ),
                      body: Text(AppLocalizations.of(context)!
                          .economic_sustainability),
                      isExpanded: ecoActive),
                  ExpansionPanel(
                      headerBuilder: (_, __) => ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.sus_env,
                            ),
                          ),
                      body: Text(AppLocalizations.of(context)!
                          .environmental_sustainability_content),
                      isExpanded: envActive)
                ],
              ),
            ]),
          ),
        ),
      );
}
