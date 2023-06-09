import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PageEnergyStorage extends StatefulWidget {
  const PageEnergyStorage({
    super.key,
    required this.pushNavbar,
  });

  final Function() pushNavbar;

  @override
  State<PageEnergyStorage> createState() => _PageEnergyStorageState();
}

class _PageEnergyStorageState extends State<PageEnergyStorage> {
  bool batteryActive = false;
  bool heatActive = false;
  bool mechanicActive = false;

  @override
  Widget build(BuildContext context) {
    List<List<String>> textData = [
      [
        AppLocalizations.of(context)!.storage_table_battery_type,
        AppLocalizations.of(context)!.storage_table_battery_risk,
        AppLocalizations.of(context)!.storage_table_battery_lifespan,
        AppLocalizations.of(context)!.storage_table_battery_efficiency
      ],
      [
        AppLocalizations.of(context)!.storage_table_pes_type,
        AppLocalizations.of(context)!.storage_table_pes_risk,
        AppLocalizations.of(context)!.storage_table_pes_lifespan,
        AppLocalizations.of(context)!.storage_table_pes_efficiency
      ],
      [
        AppLocalizations.of(context)!.storage_table_tes_type,
        AppLocalizations.of(context)!.storage_table_tes_risk,
        AppLocalizations.of(context)!.storage_table_tes_lifespan,
        AppLocalizations.of(context)!.storage_table_tes_efficiency
      ],
    ];

    List<List<Widget>> data = [];

    for (var line in textData) {
      List<Widget> temp = [];
      for (var t in line) {
        temp.add(Text(t, style: Theme.of(context).textTheme.labelSmall));
      }
      data.add(temp);
    }

    // Text(item, style: Theme.of(context).textTheme.labelSmall)

    return SingleChildScrollView(
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
                    isExpanded: batteryActive,
                    canTapOnHeader: true),
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
                    isExpanded: heatActive,
                    canTapOnHeader: true),
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
                    isExpanded: mechanicActive,
                    canTapOnHeader: true)
              ],
            ),
            Divider(),
            Text(
              AppLocalizations.of(context)!.summary,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            EngagementTable(titles: [
              AppLocalizations.of(context)!.storage_table_header_type,
              AppLocalizations.of(context)!.storage_table_header_risk,
              AppLocalizations.of(context)!.storage_table_header_lifespan,
              AppLocalizations.of(context)!.storage_table_header_efficiency
            ], data: data)
          ]),
        ),
      ),
    );
  }

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
          Text(AppLocalizations.of(context)!.energy_storage_content_thermal_p1),
          ZoomableImage(
            path: 'assets/images/tes.png',
            pushNavbar: widget.pushNavbar,
          ),
        ],
      );

  Widget hydroBody() => Column(
        children: [
          Text(AppLocalizations.of(context)!
              .energy_storage_content_mechanical_p1),
          ZoomableImage(
            path: 'assets/images/pump-store.jpg',
            pushNavbar: widget.pushNavbar,
          ),
          SizedBox(
            height: 10,
          ),
          Text(AppLocalizations.of(context)!
              .energy_storage_content_mechanical_p2)
        ],
      );
}
