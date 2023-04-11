import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  var _titles = [
    "Readable",
    "Solar Potential",
    "Energy Storage",
    "Regulations",
    "Social Sustainability",
    "Environmental Sustainability",
    "Economic Sustainability",
    "External Resources"
  ];

  String getPageTitle() {
    switch (_activePage) {
      case ReadablePages.potential:
        return _titles[1];
      case ReadablePages.storage:
        return _titles[2];
      case ReadablePages.regulations:
        return _titles[3];
      case ReadablePages.social:
        return _titles[4];
      case ReadablePages.environmental:
        return _titles[5];
      case ReadablePages.economic:
        return _titles[6];
      case ReadablePages.external:
        return _titles[7];
      case ReadablePages.overview:
        return _titles[8];
      default:
        return _titles[0];
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
      return createAppBar(context, "Readable");
    }
    return createAppBar(
        context,
        getPageTitle(),
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
        readButton(ReadablePages.potential, Icons.sunny, "Solar Potential"),
        SizedBox(height: 10),
        readButton(ReadablePages.storage, Icons.storage, "Energy Storage"),
        SizedBox(height: 10),
        readButton(
            ReadablePages.regulations, Icons.account_balance, "Regulations"),
        SizedBox(height: 10),
        readButton(ReadablePages.social, Icons.people, "Social Sustainability"),
        SizedBox(height: 10),
        readButton(ReadablePages.environmental, Icons.eco,
            "Environmental Sustainability"),
        SizedBox(height: 10),
        readButton(
            ReadablePages.economic, Icons.money, "Economic Sustainability"),
        SizedBox(height: 10),
        readButton(ReadablePages.external, Icons.money, "External Resources"),
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
