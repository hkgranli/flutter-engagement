import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart' show ModelViewer;
import 'package:engagement/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InteractivePage extends StatefulWidget {
  const InteractivePage({super.key});

  @override
  State<InteractivePage> createState() => _InteractivePageState();
}

enum Pages {
  home,
  pvView,
  ecoView,
  potential,
  storage,
  regulations,
  social,
  environmental,
  economic,
  external
}

enum SolarType { none, panel, tile }

enum Panel { none, PanL, Dodge }

enum Tile { none, Molly, Emp }

class _InteractivePageState extends State<InteractivePage>
    with TickerProviderStateMixin {
  bool _showcase = true;
  var activePage = Pages.home;

  bool _dropdownSideSelectorActive = false;

  var _solarSides = [1, 1, 1, 1];
  // north south east west
  // 0 = false; 1 = true

  SolarType _solarType = SolarType.panel;
  Panel _activePanel = Panel.PanL;
  Tile _activeTile = Tile.none;

  void toggleDropdown() {
    setState(() {
      _dropdownSideSelectorActive = !_dropdownSideSelectorActive;
    });
  }

  void setSolarType(SolarType? s) {
    setState(() {
      _solarType = s!;
    });
  }

  void setSelectedPanel(dynamic p) {
    if (p is Panel) {
      setState(() {
        _activePanel = p;
      });
    }
  }

  void setSelectedTile(dynamic t) {
    if (t is Tile) {
      setState(() {
        _activeTile = t;
      });
    }
  }

  void toggleSide(int index, int i) {
    setState(() {
      _solarSides[index] = i;
    });
  }

  String getPageTitle(BuildContext context) {
    switch (activePage) {
      case Pages.pvView:
        return AppLocalizations.of(context)!.interactive;
      case Pages.ecoView:
        return AppLocalizations.of(context)!.interactive;
      case Pages.potential:
        return AppLocalizations.of(context)!.solar_potential;
      case Pages.storage:
        return AppLocalizations.of(context)!.energy_storage;
      case Pages.regulations:
        return AppLocalizations.of(context)!.regulations;
      case Pages.social:
        return AppLocalizations.of(context)!.sus_social;
      case Pages.environmental:
        return AppLocalizations.of(context)!.sus_env;
      case Pages.economic:
        return AppLocalizations.of(context)!.sus_eco;
      case Pages.external:
        return AppLocalizations.of(context)!.external_resources;
      default:
        return AppLocalizations.of(context)!.read;
    }
  }

  void setPage(Pages p, [bool? show]) {
    setState(() {
      activePage = p;
      _showcase = show!;
    });
  }

  void toggleShowcase(int index) {
    setState(() {
      _showcase = index == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    AppBar appBar;

    switch (activePage) {
      case Pages.home:
        page = _buildHome();
        appBar =
            createAppBar(context, AppLocalizations.of(context)!.interactive);
        break;
      case Pages.pvView:
        page = _buildPvView();
        appBar = _buildPvBar(context);
        break;
      case Pages.potential:
        page = _solarPotential();
        appBar = createAppBar(context, AppLocalizations.of(context)!.read);
        break;
      case Pages.storage:
        page = _energyStoragePage();
        appBar = createAppBar(context, AppLocalizations.of(context)!.read);
        break;
      case Pages.regulations:
        page = _regulationsPage();
        appBar = createAppBar(context, AppLocalizations.of(context)!.read);
        break;
      case Pages.social:
        page = _socialSusPage();
        appBar = createAppBar(context, AppLocalizations.of(context)!.read);
        break;
      case Pages.environmental:
        page = _envSusPage();
        appBar = createAppBar(context, AppLocalizations.of(context)!.read);
        break;
      case Pages.economic:
        page = _ecoSusPage();
        appBar = createAppBar(context, AppLocalizations.of(context)!.read);
        break;
      case Pages.external:
        page = _externalPage();
        appBar = createAppBar(context, AppLocalizations.of(context)!.read);
        break;
      case Pages.ecoView:
        page = _buildEco();
        appBar = createAppBar(
            context,
            AppLocalizations.of(context)!.interactive,
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => setPage(Pages.ecoView),
            ));
        break;
      default:
        page = Text("wtf");
        appBar =
            createAppBar(context, AppLocalizations.of(context)!.interactive);
        break;
    }

    return Scaffold(
      appBar: appBar,
      body: SafeArea(child: page),
      bottomNavigationBar: createNavBar(1, context),
    );
  }

  Widget _buildHome() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Column(
        children: [
          Text(AppLocalizations.of(context)!.interactive_info),
          OutlinedButton(
              onPressed: () => setPage(Pages.pvView, true),
              child: Text(AppLocalizations.of(context)!.visualization)),
          SizedBox(height: 10),
          OutlinedButton(
              onPressed: () => setPage(Pages.pvView, false),
              child: Text(AppLocalizations.of(context)!.eff_est)),
          SizedBox(height: 10),
          OutlinedButton(
              onPressed: () => setPage(Pages.ecoView),
              child: Text(AppLocalizations.of(context)!.eco_model)),
          SizedBox(height: 10),
          OutlinedButton(
              onPressed: () => setPage(Pages.potential),
              child: Text(AppLocalizations.of(context)!.solar_potential)),
          SizedBox(height: 10),
          OutlinedButton(
              onPressed: () => setPage(Pages.storage),
              child: Text(AppLocalizations.of(context)!.energy_storage)),
          SizedBox(height: 10),
          OutlinedButton(
              onPressed: () => setPage(Pages.regulations),
              child: Text(AppLocalizations.of(context)!.regulations)),
          SizedBox(height: 10),
          OutlinedButton(
              onPressed: () => setPage(Pages.social),
              child: Text(AppLocalizations.of(context)!.sus_social)),
          SizedBox(height: 10),
          OutlinedButton(
              onPressed: () => setPage(Pages.environmental),
              child: Text(AppLocalizations.of(context)!.sus_env)),
          SizedBox(height: 10),
          OutlinedButton(
              onPressed: () => setPage(Pages.economic),
              child: Text(AppLocalizations.of(context)!.sus_eco)),
          SizedBox(height: 10),
          OutlinedButton(
              onPressed: () => setPage(Pages.external),
              child: Text(AppLocalizations.of(context)!.external_resources)),
        ],
      )),
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

  AppBar _buildPvBar(BuildContext context) {
    final TabController tabController =
        TabController(length: 2, initialIndex: _showcase ? 0 : 1, vsync: this);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        print(tabController.index);
        toggleShowcase(tabController.index);
      }
    });

    return createAppBar(
        context,
        AppLocalizations.of(context)!.interactive,
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setPage(Pages.home),
        ),
        TabBar(
          tabs: [
            Tab(
                icon: Icon(Icons.roofing),
                text: AppLocalizations.of(context)!.visualization),
            Tab(
                icon: Icon(Icons.calculate),
                text: AppLocalizations.of(context)!.eff_est),
          ],
          controller: tabController,
        ));
  }

  Widget _buildPvView() {
    Widget page;

    if (_showcase) {
      page = _modelViewer();
    } else {
      page = _energyEst(context);
    }

    return Center(
      child: Column(
        children: [
          _buildConfig(),
          page,
        ],
      ),
    );
  }

  Widget _buildConfig() {
    List<DropdownMenuItem<SolarType>> menuItems = [
      DropdownMenuItem(
          value: SolarType.none,
          child: Text(AppLocalizations.of(context)!.select_type)),
      DropdownMenuItem(
          value: SolarType.panel,
          child: Text(AppLocalizations.of(context)!.s_panel)),
      DropdownMenuItem(
          value: SolarType.tile,
          child: Text(AppLocalizations.of(context)!.s_tile)),
    ];

    DropdownButton b = DropdownButton(items: null, onChanged: null);

    if (_solarType == SolarType.panel) {
      List<DropdownMenuItem<Panel>> panelItems = [
        DropdownMenuItem(
            value: Panel.none,
            child: Text(AppLocalizations.of(context)!.select_product)),
        DropdownMenuItem(value: Panel.Dodge, child: Text("Dodge")),
        DropdownMenuItem(value: Panel.PanL, child: Text("PanL")),
      ];

      b = DropdownButton(
          value: _activePanel, items: panelItems, onChanged: setSelectedPanel);
    } else if (_solarType == SolarType.tile) {
      List<DropdownMenuItem<Tile>> tileItems = [
        DropdownMenuItem(
            value: Tile.none,
            child: Text(AppLocalizations.of(context)!.select_product)),
        DropdownMenuItem(value: Tile.Emp, child: Text("Emp")),
        DropdownMenuItem(value: Tile.Molly, child: Text("Molly")),
      ];

      b = DropdownButton(
          value: _activeTile, items: tileItems, onChanged: setSelectedTile);
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("${AppLocalizations.of(context)!.select_type}: "),
            DropdownButton(
                value: _solarType, items: menuItems, onChanged: setSolarType),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("${AppLocalizations.of(context)!.select_product}: "),
            b,
          ],
        ),
        ExpansionPanelList(
          expansionCallback: (panelIndex, isExpanded) => toggleDropdown(),
          children: [
            ExpansionPanel(
                headerBuilder: (context, isExpanded) => ListTile(
                      title: Text(
                        "${AppLocalizations.of(context)!.roof_sides}",
                      ),
                    ),
                body: Column(children: _sideSelector(context)),
                isExpanded: _dropdownSideSelectorActive),
          ],
        ),
      ],
    );
  }

  List<Widget> _sideSelector(BuildContext context) {
    return [
      CheckboxListTile(
          visualDensity: VisualDensity.compact,
          value: _solarSides[0] == 1,
          onChanged: (p) => toggleSide(0, _solarSides[0] == 1 ? 0 : 1),
          title: Text(AppLocalizations.of(context)!.north),
          dense: true),
      CheckboxListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          value: _solarSides[2] == 1,
          onChanged: (p) => toggleSide(2, _solarSides[2] == 1 ? 0 : 1),
          title: Text(AppLocalizations.of(context)!.east)),
      CheckboxListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          value: _solarSides[3] == 1,
          onChanged: (p) => toggleSide(3, _solarSides[3] == 1 ? 0 : 1),
          title: Text(AppLocalizations.of(context)!.west)),
      CheckboxListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          value: _solarSides[1] == 1,
          onChanged: (p) => toggleSide(1, _solarSides[1] == 1 ? 0 : 1),
          title: Text(AppLocalizations.of(context)!.south)),
    ];
  }

  Widget _buildEco() {
    return EconomicModels();
  }

  Widget _modelViewer() {
    // the widget will draw infinite pixels when sharing body without expanded
    // <https://stackoverflow.com/questions/56354923/flutter-bottom-overflowed-by-infinity-pixels>

    return Expanded(
      child: Center(
        child: ModelViewer(
          src: _getModelUrl(),
          alt: "A 3D model of a house",
          ar: false,
          autoRotate: false,
          cameraControls: true,
          maxCameraOrbit: "auto 90deg auto",
          backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
          exposure: 0.35,
          shadowIntensity: 0.5,
          shadowSoftness: 0,
          key: UniqueKey(), // key ensures the widget is updated
        ),
      ),
    );

    // maxOrbit ensures user cannot look under the model
  }

  String _getModelUrl() {
    var base = "assets/models/house";

    var c = "_${_solarSides.join()}";
    //var c = "_1111";

    const extension = ".glb";

    // guard clauses for invalid config

    if (_solarType == SolarType.none ||
        (_solarType == SolarType.panel && _activePanel == Panel.none) ||
        (_solarType == SolarType.tile && _activeTile == Tile.none)) {
      return "$base$extension";
    }

    String t;

    if (_solarType == SolarType.panel) {
      t = _activePanel == Panel.PanL ? "_panel_1" : "_panel_dodge";
    } else {
      t = _activeTile == Tile.Emp ? "_tile_Emp" : "_tile_Molly";
    }
    var url = "$base$t$c$extension";

    print("FETCHing $url");
    return url;
  }

  Widget _energyEst(BuildContext context) {
    List<double> monthCoeff = [
      250,
      300,
      400,
      600,
      700,
      1000,
      1200,
      1100,
      900,
      500,
      200,
      220
    ];

    double total = 0;

    List<FlSpot> estProd = [];

    double panelEff = 0.75;

    List<double> sideEff = [0.5, 1, 0.25, 0.3];

    for (int x = 0; x < monthCoeff.length; x++) {
      var e = monthCoeff[x];
      double t = 0;

      for (int i = 0; i < sideEff.length; i++) {
        t += sideEff[i] * panelEff * _solarSides[i];
      }

      total += e * t;

      estProd.add(FlSpot(x.toDouble(), e * t));
    }

    return Column(
      children: [
        Text("Total estimated electricity generation: $total kwT"),
        AspectRatio(
          aspectRatio: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LineChart(LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: estProd,
                  isCurved: true,
                  barWidth: 2,
                )
              ],
              minY: 0,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: bottomTitleWidgets,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                checkToShowHorizontalLine: (double value) {
                  return value == 1 || value == 6 || value == 4 || value == 5;
                },
              ),
            )),
          ),
        ),
        Text("With $total you can:")
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
      default:
        return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '\$ ${value + 0.5}',
        style: style,
      ),
    );
  }
}

enum EcoModelSelections { None, Private, Leasing, PPPP }

class EconomicModels extends StatefulWidget {
  const EconomicModels({super.key});

  @override
  State<EconomicModels> createState() => _EconomicModelsState();
}

class _EconomicModelsState extends State<EconomicModels> {
  var _selectedModel = EcoModelSelections.None;

  void changeModel(EcoModelSelections? e) {
    setState(() {
      _selectedModel = e!;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text("Joe");
    switch (_selectedModel) {
      case EcoModelSelections.None:
        content = Landing();
        break;
      case EcoModelSelections.Private:
        content = PrivateModel();
        break;
      case EcoModelSelections.Leasing:
        content = LeasingModel();
        break;
      case EcoModelSelections.PPPP:
        content = PPPPModel();
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
          value: EcoModelSelections.None, child: Text("Select Economic Model")),
      DropdownMenuItem(
          value: EcoModelSelections.Leasing, child: Text("Leasing")),
      DropdownMenuItem(
          value: EcoModelSelections.Private, child: Text("Private")),
      DropdownMenuItem(value: EcoModelSelections.PPPP, child: Text("PPPP")),
    ];

    return DropdownButton(
        value: _selectedModel, items: menuItems, onChanged: changeModel);
  }

  Widget PPPPModel() {
    return Text("ppp");
  }

  Widget LeasingModel() => Text("Leasing");

  Widget PrivateModel() => Text("Private");

  Widget Landing() => Text("Select a model");
}
