import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart' show ModelViewer;
import 'package:engagement/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_compare_slider/image_compare_slider.dart';

class PageEnergyStorage extends StatefulWidget {
  const PageEnergyStorage({
    super.key,
  });

  @override
  State<PageEnergyStorage> createState() => _PageEnergyStorageState();
}

class _PageEnergyStorageState extends State<PageEnergyStorage> {
  bool batteryActive = false;
  bool heatActive = false;
  bool mechanicActive = false;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(children: [
              Text(AppLocalizations.of(context)!.energy_storage_content_intro),
              Divider(),
              ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) {
                  switch (panelIndex) {
                    case 0:
                      setState(() {
                        batteryActive = !batteryActive;
                      });
                      break;
                    case 1:
                      setState(() {
                        heatActive = !heatActive;
                      });
                      break;
                    case 2:
                      setState(() {
                        mechanicActive = !mechanicActive;
                      });
                      break;
                  }
                },
                children: [
                  ExpansionPanel(
                      headerBuilder: (context, isExpanded) => ListTile(
                            title: Text(
                              AppLocalizations.of(context)!
                                  .energy_storage_content_intro_battery,
                            ),
                          ),
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: batteryBody(),
                      ),
                      isExpanded: batteryActive),
                  ExpansionPanel(
                      headerBuilder: (_, __) => ListTile(
                            title: Text(
                              AppLocalizations.of(context)!
                                  .energy_storage_content_intro_thermal,
                            ),
                          ),
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: thermalBody(),
                      ),
                      isExpanded: heatActive),
                  ExpansionPanel(
                      headerBuilder: (_, __) => ListTile(
                            title: Text(
                              AppLocalizations.of(context)!
                                  .energy_storage_content_intro_mechanical,
                            ),
                          ),
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: hydroBody(),
                      ),
                      isExpanded: mechanicActive)
                ],
              ),
              Divider(),
              Text(
                "_placeholder Summary",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              EngagementTable(titles: [
                'Type',
                'Risk',
                'Lifespan',
                'Efficiency'
              ], data: [
                ['Li-ion Battery', 'High', '2-3 years', '95%'],
                ['Pumped Storage', 'Very Low', '50 years', '80%'],
                ['Thermal and Heat storage', 'Low', '15-20 years', '50-90%'],
              ])
            ]),
          ),
        ),
      );
  Widget batteryBody() => Column(children: [
        Text(AppLocalizations.of(context)!.energy_storage_content_battery_p1),
        SizedBox(
          height: 10,
        ),
        Text(AppLocalizations.of(context)!.energy_storage_content_battery_p2),
        SizedBox(
          height: 10,
        ),
        Text(AppLocalizations.of(context)!.energy_storage_content_battery_p3),
      ]);

  Widget thermalBody() => Column(
        children: [
          Text(AppLocalizations.of(context)!.energy_storage_content_thermal_p1)
        ],
      );

  Widget hydroBody() => Column(
        children: [
          Text(AppLocalizations.of(context)!
              .energy_storage_content_mechanical_p1),
          SizedBox(
            height: 10,
          ),
          Text(AppLocalizations.of(context)!
              .energy_storage_content_mechanical_p2)
        ],
      );
}
