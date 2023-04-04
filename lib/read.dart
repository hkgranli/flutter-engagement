import 'package:engagement/components.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ReadablePages {
  overview,
  potential,
  energy,
  regulations,
  social,
  environmental,
  economic
}

class ReadPage extends StatefulWidget {
  const ReadPage({super.key});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  var _activePage = 0;

  var Titles = [
    "Readable",
    "Solar Potential",
    "Energy Storage",
    "Regulations",
    "Social Sustainability",
    "Environmental Sustainability",
    "Economic Sustainability"
  ];

  void setPage(int page) {
    setState(() {
      _activePage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: _CreateAppBar(theme),
      body: _BuildPage(),
      bottomNavigationBar: CreateNavBar(theme, 2, context),
    );
  }

  AppBar _CreateAppBar(ThemeData theme) {
    if (_activePage == 0) return CreateAppBar(theme, "Readable");
    return CreateAppBar(
        theme,
        Titles[_activePage],
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setPage(0),
        ));
  }

  Widget _BuildPage() {
    switch (_activePage) {
      case 0:
        return _OverviewPage();
      case 1:
        return _SolarPotential();
      case 2:
        return _EnergyStoragePage();
      case 3:
        return _RegulationsPage();
      case 4:
        return _SocialSusPage();
      case 5:
        return _EnvSusPage();
      case 6:
        return _EcoSusPage();
      default:
        return _OverviewPage();
    }
  }

  Widget _OverviewPage() {
    return SafeArea(
        child: Center(
            child: Column(
      children: [
        ReadButton(1, Icons.sunny, "Solar Potential"),
        ReadButton(2, Icons.storage, "Energy Storage"),
        ReadButton(3, Icons.account_balance, "Regulations"),
        ReadButton(4, Icons.people, "Social Sustainability"),
        ReadButton(5, Icons.eco, "Environmental Sustainability"),
        ReadButton(6, Icons.money, "Economic Sustainability"),
      ],
    )));
  }

  ButtonTheme ReadButton(int i, IconData icon, String text) {
    return ButtonTheme(
      minWidth: 300.0,
      height: 100.0,
      child: OutlinedButton(
          onPressed: () {
            setPage(i);
          },
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [Icon(icon), Text(text)])),
    );
  }

  Widget _EnergyStoragePage() {
    return Text("Abd");
  }

  Widget _RegulationsPage() {
    return Text("Abd");
  }

  Widget _SocialSusPage() {
    return Text("Abd");
  }

  Widget _EnvSusPage() {
    return Text("Abd");
  }

  Widget _EcoSusPage() {
    return Text("Abd");
  }

  Widget _SolarPotential() {
    return Text("Abd");
  }
}
