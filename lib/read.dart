import 'package:engagement/components.dart';
import 'package:engagement/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ReadablePages {
  overview,
  potential,
  storage,
  regulations,
  social,
  environmental,
  economic,
  external
}

class ReadPage extends StatefulWidget {
  const ReadPage({super.key});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  ReadablePages _activePage = ReadablePages.overview;

  String getPageTitle(BuildContext context) {
    switch (_activePage) {
      case ReadablePages.potential:
        return AppLocalizations.of(context)!.solar_potential;
      case ReadablePages.storage:
        return AppLocalizations.of(context)!.energy_storage;
      case ReadablePages.regulations:
        return AppLocalizations.of(context)!.regulations;
      case ReadablePages.social:
        return AppLocalizations.of(context)!.sus_social;
      case ReadablePages.environmental:
        return AppLocalizations.of(context)!.sus_env;
      case ReadablePages.economic:
        return AppLocalizations.of(context)!.sus_eco;
      case ReadablePages.external:
        return AppLocalizations.of(context)!.external_resources;
      default:
        return AppLocalizations.of(context)!.read;
    }
  }

  void setPage(ReadablePages r) {
    setState(() {
      _activePage = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _CreateAppBar(context),
      body: Center(child: _BuildPage()),
      bottomNavigationBar: createNavBar(2, context),
    );
  }

  AppBar _CreateAppBar(BuildContext context) {
    if (_activePage == ReadablePages.overview) {
      return createAppBar(context, AppLocalizations.of(context)!.read);
    }
    return createAppBar(
        context,
        getPageTitle(context),
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setPage(ReadablePages.overview),
        ));
  }

  Widget _BuildPage() {
    switch (_activePage) {
      case ReadablePages.overview:
        return _overviewPage();
      case ReadablePages.potential:
        return _solarPotential();
      case ReadablePages.storage:
        return _energyStoragePage();
      case ReadablePages.regulations:
        return _regulationsPage();
      case ReadablePages.social:
        return _socialSusPage();
      case ReadablePages.environmental:
        return _envSusPage();
      case ReadablePages.economic:
        return _ecoSusPage();
      case ReadablePages.external:
        return _externalPage();
      default:
        return _overviewPage();
    }
  }

  Widget _overviewPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        readButton(Pages.potential, Icons.sunny,
            AppLocalizations.of(context)!.solar_potential),
        SizedBox(height: 10),
        readButton(Pages.storage, Icons.storage,
            AppLocalizations.of(context)!.energy_storage),
        SizedBox(height: 10),
        readButton(Pages.regulations, Icons.account_balance,
            AppLocalizations.of(context)!.regulations),
        SizedBox(height: 10),
        readButton(Pages.social, Icons.people,
            AppLocalizations.of(context)!.sus_social),
        SizedBox(height: 10),
        readButton(Pages.environmental, Icons.eco,
            AppLocalizations.of(context)!.sus_env),
        SizedBox(height: 10),
        readButton(Pages.economic, Icons.money,
            AppLocalizations.of(context)!.sus_eco),
        SizedBox(height: 10),
        readButton(Pages.external, Icons.money,
            AppLocalizations.of(context)!.external_resources),
      ],
    );
  }

  ButtonTheme readButton(ReadablePages r, IconData icon, String text) {
    return ButtonTheme(
      minWidth: 300.0,
      height: 100.0,
      child: OutlinedButton(
          onPressed: () {
            setPage(r);
          },
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [Icon(icon), Text(text)])),
    );
  }

  Widget _energyStoragePage() {
    return Text("EnergyStorage is good");
  }

  Widget _regulationsPage() {
    return Text("Regulations are sometimes good but sometimes bad");
  }

  Widget _socialSusPage() {
    return Text("Socially this is sustainabile");
  }

  Widget _envSusPage() {
    return Text("The environmental sustainability is dubious");
  }

  Widget _ecoSusPage() {
    return Text("The economic sustainability is economic");
  }

  Widget _solarPotential() {
    return Text("The solar is potentially");
  }

  Widget _externalPage() {
    return Text("External");
  }
}
