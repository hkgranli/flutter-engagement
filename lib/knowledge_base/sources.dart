import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SourcesPage extends StatefulWidget {
  const SourcesPage({
    super.key,
  });

  @override
  State<SourcesPage> createState() => _SourcesPageState();
}

class _SourcesPageState extends State<SourcesPage> {
  bool imageSourcesActive = false;
  bool contentSourcesActive = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              switch (panelIndex) {
                case 0:
                  setState(() {
                    imageSourcesActive = !imageSourcesActive;
                  });
                  break;
                case 1:
                  setState(() {
                    contentSourcesActive = !contentSourcesActive;
                  });
                  break;
              }
            },
            children: [
              ExpansionPanel(
                  headerBuilder: (context, isExpanded) => ListTile(
                        title: Text(
                            AppLocalizations.of(context)!.sources_img_intro),
                      ),
                  body: imageSources(),
                  isExpanded: imageSourcesActive),
              ExpansionPanel(
                  headerBuilder: (_, __) => ListTile(
                        title: Text(AppLocalizations.of(context)!
                            .sources_content_intro),
                      ),
                  body: contentSources(),
                  isExpanded: contentSourcesActive),
            ],
          ),
        ],
      ),
    );
  }

  Widget imageSources() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ...sourceList(AppLocalizations.of(context)!.solar_potential, [
            Text("${AppLocalizations.of(context)!.source_map}: OpenStreetmap"),
            Text(
                "${AppLocalizations.of(context)!.source_map_dsh}: Marius Evanger Voss - Solar Conditions and PV-Viability on Møllenberg (Helios)"),
          ]),
          ...sourceList(AppLocalizations.of(context)!.energy_storage, [
            Text(
                "${AppLocalizations.of(context)!.source_thermal}: Alan Petrillo - <https://www.comsol.com/story/heating-buildings-with-solar-energy-stored-in-sand-105101>"),
            Text(
                "${AppLocalizations.of(context)!.source_hydro}: Wikipedia - <https://en.wikipedia.org/wiki/Pumped-storage_hydroelectricity>"),
          ]),
          ...sourceList(AppLocalizations.of(context)!.regulations, [
            Text(
                "${AppLocalizations.of(context)!.reg_protection_intro}: Trondheim Kommune - <https://www.trondheim.kommune.no/tema/bygg-kart-og-eiendom/byantikvar/byantikvaren/>"),
            Text(
                "${AppLocalizations.of(context)!.reg_zoning_intro}: Trondheim Kommune - <https://www.trondheim.kommune.no/tema/bygg-kart-og-eiendom/byantikvar/byantikvaren/>"),
            Text(
                "${AppLocalizations.of(context)!.reg_guidelines_intro}: Trondheim Kommune - <https://www.trondheim.kommune.no/tema/bygg-kart-og-eiendom/byantikvar/byantikvaren/>"),
          ]),
          ...sourceList(AppLocalizations.of(context)!.solar_technology, [
            Text(
                "${AppLocalizations.of(context)!.monocrystalline}: iKratos - ikratos.de"),
            Text(
                "${AppLocalizations.of(context)!.polycrystalline}: Trondheim Kommune - <https://www.trondheim.kommune.no/tema/bygg-kart-og-eiendom/byantikvar/byantikvaren/>"),
            Text("${AppLocalizations.of(context)!.thin_film}: Goexplorer.org"),
            Text(
                "${AppLocalizations.of(context)!.solar_technology_tiles_header}: tbd"),
            Text(
                "${AppLocalizations.of(context)!.solar_technology_transparent_header}: freethink.com"),
            Text(
                "${AppLocalizations.of(context)!.solar_technology_colored_header}: mrwatt.eu"),
            Text(
                "${AppLocalizations.of(context)!.solar_technology_transparent_header}: freethink.com"),
            Text(
                "${AppLocalizations.of(context)!.solartech_moll_ex}: Adrian Skar et. al. - Evaluating the Prospects of Solar Utilization on Møllenberg (Helios)"),
            Text(
                "${AppLocalizations.of(context)!.solartech_ex_world}: comsol.com"),
          ]),
        ],
      ),
    );
  }

  List<Widget> sourceList(String title, List<Widget> a) {
    List<Widget> l = [
      Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Divider()
    ];

    for (Widget w in a) {
      l.add(w);
      l.add(Divider());
    }

    return l;
  }

  Widget contentSources() {
    var authors = [
      'Matti Dobersch',
      'Mar Izquierdo Santamaria',
      'Johan Sterten',
      'Skar, A., Santamaria , M., Throsnes, S. Lettow, P., Sterten, J., Dobersch, M., Mona, M., Jurado, G., Kvavik, E., Voss, M.',
      'Marius Evanger Voss',
      'Sindre Thorsnes',
      'Gabriela Rocha Jurado',
      'Mikkel Andreas Gravbrøt Mona',
      'Pablo Lettow'
    ];

    var papers = [
      'Can the potential energy profit from solar cells installed at Møllenberg cover its average energy consumption?',
      'Solar Energy Storage',
      'How can solar panels be aesthetically pleasing in heritage areas?',
      'Evaluation the Prospect of solar utilization on Møllenberg',
      'Solar Conditions and PV-Viability on Møllenberg',
      'Transformation and Adaptive Re-Use of Existing Buildings',
      'Management of energy between different users at district buildings in Møllenberg, Trondheim where solar panels might not supply the necessary energy',
      'In what degree could solar energy solutions increase neighborhood value and social revitalization?',
      'Economic comparison of solar energy in Møllenberg: Can photovoltaic systems be profitable over their lifetime?',
    ];

    List<Widget> w = [];

    for (int i = 0; i < authors.length; i++) {
      w.add(RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
                text: authors[i],
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' - '),
            TextSpan(
                text: papers[i],
                style: TextStyle(fontWeight: FontWeight.normal)),
          ],
        ),
      ));
      w.add(Divider());
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: w,
      ),
    );
  }
}
