import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum EcoModelSelections { none, community, leasing, pppp }

class EconomicModels extends StatefulWidget {
  const EconomicModels({super.key});

  @override
  State<EconomicModels> createState() => _EconomicModelsState();
}

class _EconomicModelsState extends State<EconomicModels> {
  var _selectedModel = EcoModelSelections.none;

  void changeModel(EcoModelSelections? e) {
    setState(() {
      _selectedModel = e!;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text("Joe");
    switch (_selectedModel) {
      case EcoModelSelections.none:
        content = _landing(context);
        break;
      case EcoModelSelections.community:
        content = _communityShared(context);
        break;
      case EcoModelSelections.leasing:
        content = _leasingModel(context);
        break;
      case EcoModelSelections.pppp:
        content = _p4Model(context);
        break;
      default:
        break;
    }

    return Center(
      child: Column(
        children: [
          createConfig(),
          content,
        ],
      ),
    );
  }

  Widget createConfig() {
    List<DropdownMenuItem<EcoModelSelections>> menuItems = [
      DropdownMenuItem(
          value: EcoModelSelections.none,
          child: Text(AppLocalizations.of(context)!.select_own_model)),
      DropdownMenuItem(
          value: EcoModelSelections.leasing,
          child: Text(AppLocalizations.of(context)!.leasing)),
      DropdownMenuItem(
          value: EcoModelSelections.community,
          child: Text(AppLocalizations.of(context)!.community_share)),
      DropdownMenuItem(
          value: EcoModelSelections.pppp,
          child: Text(AppLocalizations.of(context)!.pPPP_short)),
    ];

    return DropdownButton(
        value: _selectedModel, items: menuItems, onChanged: changeModel);
  }

  Widget _p4Model(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            ZoomableImage(path: 'assets/images/4p.png'),
            Text(AppLocalizations.of(context)!.owner_4p)
          ]),
        ),
      );

  Widget _leasingModel(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            ZoomableImage(path: 'assets/images/leasing.png'),
            Text(AppLocalizations.of(context)!.owner_leasing)
          ]),
        ),
      );

  Widget _communityShared(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          ZoomableImage(path: 'assets/images/community.png', label: "Label"),
          SizedBox(
            height: 10,
          ),
          Text(AppLocalizations.of(context)!.owner_community)
        ]),
      ),
    );
  }

  Widget _landing(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: [Text(AppLocalizations.of(context)!.ownership_context)]),
      ),
    );
  }
}
