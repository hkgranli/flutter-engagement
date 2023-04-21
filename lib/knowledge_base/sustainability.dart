import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                      body: socialSustainabilityBody(),
                      isExpanded: socialActive),
                  ExpansionPanel(
                      headerBuilder: (_, __) => ListTile(
                            title: Text(AppLocalizations.of(context)!.sus_eco),
                          ),
                      body: economicSustainabilityBody(),
                      isExpanded: ecoActive),
                  ExpansionPanel(
                      headerBuilder: (_, __) => ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.sus_env,
                            ),
                          ),
                      body: environmentalSustainabilityBody(),
                      isExpanded: envActive),
                ],
              ),
              summary()
            ]),
          ),
        ),
      );

  Widget summary() => Text("summar");

  Widget socialSustainabilityBody() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.social_sustainability_content,
            )
          ],
        ),
      );
  Widget economicSustainabilityBody() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.economic_sustainability,
            )
          ],
        ),
      );
  Widget environmentalSustainabilityBody() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!
                  .environmental_sustainability_content,
            )
          ],
        ),
      );
}
