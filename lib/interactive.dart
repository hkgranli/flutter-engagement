import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart' show ModelViewer;
import 'package:engagement/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Pages {
  home,
  pvView,
  ownershipView,
  potential,
  storage,
  regulations,
  sustainability,
  external
}

enum SolarType { none, panel, tile }

enum Panel {
  none(efficiency: 0, id: -1, name: "None"),
  prodOne(efficiency: 0.22, id: 1, name: "Darksun"),
  prodTwo(efficiency: 0.35, id: 2, name: "Bluepan");

  const Panel({required this.efficiency, required this.id, required this.name});

  final double efficiency;
  final int id;
  final String name;
}

enum Tile {
  none(efficiency: 0, id: -1, name: "None"),
  prodOne(efficiency: 0.12, id: 1, name: "Maxitile"),
  prodTwo(efficiency: 0.15, id: 2, name: "Sunking");

  const Tile({required this.efficiency, required this.id, required this.name});

  final double efficiency;
  final int id;
  final String name;
}

class InteractivePage extends StatefulWidget {
  InteractivePage({super.key, required this.activePage, this.showcase = false});

  final Pages activePage;
  bool showcase;

  @override
  State<InteractivePage> createState() => _InteractivePageState();
}

class _InteractivePageState extends State<InteractivePage>
    with TickerProviderStateMixin {
  bool _showcase = true;

  @override
  void initState() {
    super.initState();
    _showcase = widget.showcase;
  }

  bool _dropdownSideSelectorActive = false;

  var _solarSides = [1, 1, 1, 1];
  // north south east west
  // 0 = false; 1 = true

  SolarType _solarType = SolarType.none;
  Panel _activePanel = Panel.none;
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
    switch (widget.activePage) {
      case Pages.pvView:
        return AppLocalizations.of(context)!.interactive;
      case Pages.ownershipView:
        return AppLocalizations.of(context)!.interactive;
      case Pages.potential:
        return AppLocalizations.of(context)!.solar_potential;
      case Pages.storage:
        return AppLocalizations.of(context)!.energy_storage;
      case Pages.regulations:
        return AppLocalizations.of(context)!.regulations;
      case Pages.sustainability:
        return AppLocalizations.of(context)!.sustainability;
      case Pages.external:
        return AppLocalizations.of(context)!.external_resources;
      default:
        return AppLocalizations.of(context)!.read;
    }
  }

  void setPage(Pages p, [bool? show = false]) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InteractivePage(
                  activePage: p,
                  showcase: show!,
                )));
    /*
    setState(() {
      activePage = p;
      _showcase = show!;
    });
    */
  }

  void toggleShowcase(int index) {
    setState(() {
      _showcase = index == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;

    AppBar? appBar;
    String? title;

    switch (widget.activePage) {
      case Pages.home:
        page = _pageHome();
        title = AppLocalizations.of(context)!.information;
        break;
      case Pages.pvView:
        page = _pageInteractive();
        appBar = _buildPvBar(context);
        break;
      case Pages.potential:
        page = _pageSolarPotential(context);
        title = AppLocalizations.of(context)!.solar_potential;
        break;
      case Pages.storage:
        page = _pageEnergyStorage();
        title = AppLocalizations.of(context)!.energy_storage;
        break;
      case Pages.regulations:
        page = _pageRegulations();
        title = AppLocalizations.of(context)!.regulations;
        break;
      case Pages.sustainability:
        page = _pageSustainability();
        title = AppLocalizations.of(context)!.sustainability;
        break;
      case Pages.external:
        page = _pageSourceAndExternal();
        title = AppLocalizations.of(context)!.external_resources;
        break;
      case Pages.ownershipView:
        page = _buildEco();
        title = AppLocalizations.of(context)!.eco_model;
        break;
      default:
        page = _pageHome();
        title = AppLocalizations.of(context)!.information;
        break;
    }

    // this checks if appbar is null, if yes then eval to set correct appbar
    appBar ??= widget.activePage == Pages.home
        ? createAppBar(context, title!)
        : _appBarWithBack(context, title!);

    return Scaffold(
      appBar: appBar,
      body: SafeArea(child: page),
      bottomNavigationBar: createNavBar(1, context),
    );
  }

  AppBar _appBarWithBack(BuildContext context, String title) {
    return createAppBar(
        context,
        title,
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setPage(Pages.home),
        ));
  }

  Widget _pageHome() {
    var about = Text(AppLocalizations.of(context)!.information_context);

    List<Widget> interactive = [
      Text(
        AppLocalizations.of(context)!.interactive,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      SizedBox(height: 10),
      Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton.icon(
                onPressed: () => setPage(Pages.pvView, true),
                icon: Icon(Icons.roofing),
                label: Text(AppLocalizations.of(context)!.visualization)),
            OutlinedButton.icon(
                onPressed: () => setPage(Pages.pvView, false),
                icon: Icon(Icons.calculate),
                label: Text(AppLocalizations.of(context)!.eff_est)),
          ],
        ),
      ),
      OutlinedButton.icon(
          onPressed: () => setPage(Pages.ownershipView),
          icon: Icon(Icons.people),
          label: Text(AppLocalizations.of(context)!.eco_model))
    ];

    List<Widget> knowledgeBase = [
      Text(
        AppLocalizations.of(context)!.knowledge_base,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      SizedBox(height: 10),
      Center(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                  onPressed: () => setPage(Pages.potential),
                  icon: Icon(Icons.sunny),
                  label: Text(AppLocalizations.of(context)!.solar_potential)),
              OutlinedButton.icon(
                  onPressed: () => setPage(Pages.storage),
                  icon: Icon(Icons.battery_4_bar),
                  label: Text(AppLocalizations.of(context)!.energy_storage)),
            ]),
      ),
      SizedBox(height: 10),
      Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton.icon(
                icon: Icon(Icons.rule),
                onPressed: () => setPage(Pages.regulations),
                label: Text(AppLocalizations.of(context)!.regulations)),
            SizedBox(height: 10),
            OutlinedButton.icon(
                icon: Icon(Icons.energy_savings_leaf),
                onPressed: () => setPage(Pages.sustainability),
                label: Text(AppLocalizations.of(context)!.sustainability)),
          ],
        ),
      ),
      SizedBox(height: 10),
      OutlinedButton.icon(
          onPressed: () => setPage(Pages.external),
          icon: Icon(Icons.more),
          label: Text(AppLocalizations.of(context)!.external_resources)),
      SizedBox(height: 10),
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(
          children: [
            about,
            Divider(),
            ...knowledgeBase,
            Divider(),
            ...interactive,
          ],
        )),
      ),
    );
  }

  Widget _pageEnergyStorage() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(children: [
              Text(AppLocalizations.of(context)!.energy_storage_content_intro),
              UnorderedList([
                AppLocalizations.of(context)!
                    .energy_storage_content_intro_battery,
                AppLocalizations.of(context)!
                    .energy_storage_content_intro_thermal,
                AppLocalizations.of(context)!
                    .energy_storage_content_intro_mechanical
              ]),
              Divider(),
              Text(
                  AppLocalizations.of(context)!.energy_storage_content_battery),
              Divider(),
              Text(
                  AppLocalizations.of(context)!.energy_storage_content_thermal),
              Divider(),
              Text(AppLocalizations.of(context)!
                  .energy_storage_content_mechanical)
            ]),
          ),
        ),
      );

  Widget _pageRegulations() => SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Text(AppLocalizations.of(context)!.reg_content_p1),
              Text(AppLocalizations.of(context)!.reg_content_p2),
              UnorderedList([
                AppLocalizations.of(context)!.reg_content_l1_i1,
                AppLocalizations.of(context)!.reg_content_l1_i2,
                AppLocalizations.of(context)!.reg_content_l1_i3,
              ]),
              InteractiveViewer(
                panEnabled: false,
                boundaryMargin: EdgeInsets.all(100),
                maxScale: 3,
                minScale: 0.75,
                child: Image.asset(
                  'assets/images/regulations.png',
                ),
              ),
            ]),
          ),
        ]),
      );

  Widget _pageSustainability() => SingleChildScrollView(
        child: Center(
          child: Column(children: [
            Text(AppLocalizations.of(context)!.sus_content_p1),
            UnorderedList([
              AppLocalizations.of(context)!.social_sustainability,
              AppLocalizations.of(context)!.sus_eco,
              AppLocalizations.of(context)!.sus_env,
            ]),
            Divider(),
            Text(
              AppLocalizations.of(context)!.social_sustainability,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Divider(),
            Text(
              AppLocalizations.of(context)!.sus_eco,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Divider(),
            Text(
              AppLocalizations.of(context)!.sus_env,
              style: Theme.of(context).textTheme.titleMedium,
            )
          ]),
        ),
      );

  Widget _pageSolarPotential(BuildContext context) => SingleChildScrollView(
        child: Center(
          child: Column(children: []),
        ),
      );

  Widget _pageSourceAndExternal() => SingleChildScrollView(
        child: Center(
          child: Column(children: []),
        ),
      );

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

  Widget _pageInteractive() {
    Widget page;

    if (_showcase) {
      page = _pageVisualization();
    } else {
      page = _pageEnergyEstimation(context);
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
        DropdownMenuItem(value: Panel.prodTwo, child: Text(Panel.prodTwo.name)),
        DropdownMenuItem(value: Panel.prodOne, child: Text(Panel.prodOne.name)),
      ];

      b = DropdownButton(
          value: _activePanel, items: panelItems, onChanged: setSelectedPanel);
    } else if (_solarType == SolarType.tile) {
      List<DropdownMenuItem<Tile>> tileItems = [
        DropdownMenuItem(
            value: Tile.none,
            child: Text(AppLocalizations.of(context)!.select_product)),
        DropdownMenuItem(value: Tile.prodTwo, child: Text(Tile.prodTwo.name)),
        DropdownMenuItem(value: Tile.prodOne, child: Text(Tile.prodOne.name)),
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
                        AppLocalizations.of(context)!.roof_sides,
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

  Widget _pageVisualization() {
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
        (_solarType == SolarType.tile && _activeTile == Tile.none) ||
        c == "_0000") {
      return "$base$extension";
    }

    String t;

    if (_solarType == SolarType.panel) {
      t = "_panel_${_activePanel.id}";
    } else {
      t = "_tile_${_activeTile.id}";
      c = "_1111";
    }
    var url = "$base$t$c$extension";

    print("FETCHing $url");
    return url;
  }

  List<FlSpot> _estimateEnergy() {
    List<List<double>> monthCoeff = [
      [5.63, 5.2, 4.54], // jan
      [16.7, 15.36, 13.26], // feb
      [54.8, 51.3, 45.59], // mar
      [105.5, 97.09, 84.41], // apr
      [153.4, 140, 119.81], // mai
      [157, 139.77, 113.82], // jun
      [160, 143.4, 117.94], // jul
      [116, 104.94, 88.10], // aug
      [66, 61, 52.98], // sep
      [32.1, 30.32, 27.59], // oct
      [8.17, 7.56, 6.63], // nov
      [2.9, 2.64, 2.25], // des
    ];

    List<FlSpot> estProd = [];

    double panelEff;

    switch (_solarType) {
      case SolarType.panel:
        panelEff = _activePanel.efficiency;
        break;
      case SolarType.tile:
        panelEff = _activeTile.efficiency;
        break;
      default:
        panelEff = 0;
    }

    // north, south, east, west
    // which table coeff should be used per side
    List<int> sideEff = [2, 1, 2, 0];
    // in m^2
    List<double> sideSize = [99, 99, 27, 27];

    // loop all months of the year

    for (int x = 0; x < monthCoeff.length; x++) {
      double t = 0;

      // loop for every side of the house

      for (int i = 0; i < sideEff.length; i++) {
        // total estimated production per side is
        // estimated incident radiation times size of the side
        // lastly _solarSides is 1 if the panel is selected and 0 if it is inactive
        t += monthCoeff[x][sideEff[i]] * sideSize[i] * _solarSides[i];
      }

      estProd.add(FlSpot(x.toDouble(), (panelEff * t).round().toDouble()));
    }

    return estProd;
  }

  double _f1total(List<FlSpot> list) {
    double total = 0;

    for (var f in list) {
      total += f.y;
    }

    return total;
  }

  Widget _pageEnergyEstimation(BuildContext context) {
    List<FlSpot> estProd = _estimateEnergy();
    double total = _f1total(estProd);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!
              .est_gen(AppLocalizations.of(context)!.kwt, total.toInt())),
          SizedBox(
            height: 10,
          ),
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
                  leftTitles: AxisTitles(sideTitles: SideTitles()),
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
          ..._energyContext(total),
          Text(AppLocalizations.of(context)!.average_consumption),
          Text(AppLocalizations.of(context)!.energy_perspective(
              total.toInt(), AppLocalizations.of(context)!.kwt)),
          Text("I snitt brukes 14 560 kwt til oppvarming i året")
        ],
      ),
    );
  }

  List<Widget> _energyContext(double total) {
    const double showerHourCost = 8.5;
    int hoursShower = total ~/ showerHourCost;

    return [
      Row(
        children: [Icon(Icons.shower), Text("$hoursShower")],
      )
    ];
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

enum EcoModelSelections { none, community, leasing, PPPP }

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
      case EcoModelSelections.PPPP:
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
          value: EcoModelSelections.PPPP,
          child: Text(AppLocalizations.of(context)!.pPPP_short)),
    ];

    return DropdownButton(
        value: _selectedModel, items: menuItems, onChanged: changeModel);
  }

  Widget _p4Model(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            _img('assets/images/4p.png', context),
            Text(AppLocalizations.of(context)!.owner_4p)
          ]),
        ),
      );

  Widget _leasingModel(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            _img('assets/images/leasing.png', context),
            Text(AppLocalizations.of(context)!.owner_leasing)
          ]),
        ),
      );

  Widget _communityShared(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          _img('assets/images/community.png', context, "Label"),
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

  Column _img(String path, BuildContext context, [String? label]) => Column(
        children: [
          InteractiveViewer(
            panEnabled: false,
            boundaryMargin: EdgeInsets.all(100),
            maxScale: 3,
            minScale: 0.75,
            child: Image.asset(
              path,
            ),
          ),
          label is String
              ? Text(label, style: Theme.of(context).textTheme.labelSmall)
              : SizedBox.shrink()
        ],
      );
}
