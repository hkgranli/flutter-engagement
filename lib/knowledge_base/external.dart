import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalPage extends StatefulWidget {
  const ExternalPage({
    super.key,
  });

  @override
  State<ExternalPage> createState() => _ExternalPageState();
}

class _ExternalPageState extends State<ExternalPage> {
  bool englishDropdown = false;
  bool norwegianDropdown = false;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Center(
          child: Column(children: [
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                switch (panelIndex) {
                  case 0:
                    setState(() {
                      norwegianDropdown = !norwegianDropdown;
                    });
                    break;
                  case 1:
                    setState(() {
                      englishDropdown = !englishDropdown;
                    });
                    break;
                }
              },
              children: [
                ExpansionPanel(
                    headerBuilder: (context, isExpanded) => ListTile(
                          title: Text(
                              AppLocalizations.of(context)!.external_no_title),
                        ),
                    body: norwegianBody(),
                    canTapOnHeader: true,
                    isExpanded: norwegianDropdown),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text(
                              AppLocalizations.of(context)!.external_en_title),
                        ),
                    body: englishBody(),
                    canTapOnHeader: true,
                    isExpanded: englishDropdown),
              ],
            ),
          ]),
        ),
      );

  Widget englishBody() {
    List<Resource> resources = [
      Resource(
          url:
              Uri.parse("https://www.bundestag.de/en/visittheBundestag/energy"),
          author: "German Bundestag",
          description:
              "Power, heat, cold: the energy concept of the German Bundestag"),
      Resource(
          url: Uri.parse(
              "https://www.greenspec.co.uk/building-design/designing-for-passive-solar/"),
          author: "Greenspec",
          description: "Passive Solar design"),
      Resource(
          url: Uri.parse(
              "https://www.senmatic.com/sensors/knowledge/thermal-energy-storage"),
          author: "Senmatic",
          description:
              "Bridging the gap between energy supply and demand - Thermal Energy Storage")
    ];

    List<Widget> r = [];

    for (var resource in resources) {
      r = [...r, ...addResourceBlock(resource)];
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: r),
    );
  }

  List<Widget> addResourceBlock(Resource resource) {
    return [
      Text(
        resource.author,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        resource.description,
        textAlign: TextAlign.center,
      ),
      ElevatedButton(
          child: Text(AppLocalizations.of(context)!.read_more),
          onPressed: () =>
              launchUrl(resource.url, mode: LaunchMode.externalApplication))
    ];
  }

  Widget norwegianBody() {
    List<Resource> resources = [
      Resource(
          url: Uri.parse(
              "https://blogg.sintef.no/sintefenergy-nb/solcellepanel-pa-taket-er-det-lonnsomt"),
          author: "Stian Backe - Sintef",
          description: "Solcellepanel på taket – er det lønnsomt?"),
      Resource(
          url: Uri.parse("https://www.otovo.no/"),
          author: "Otovo",
          description: "Leverandør av solcellepanel i Norge"),
    ];

    List<Widget> r = [];

    for (var resource in resources) {
      r = [...r, ...addResourceBlock(resource)];
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: r),
    );
  }
}

class Resource {
  final Uri url;
  final String author;
  final String description;

  const Resource(
      {required this.url, required this.author, required this.description});
}
