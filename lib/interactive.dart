import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart' show ModelViewer;
import 'package:engagement/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_compare_slider/image_compare_slider.dart';


enum Pages {
  home,
  pvView,
  ownershipView,
  potential,
  storage,
  regulations,
  sustainability,
  external,
  solarTechnology,
  sources
}

enum SolarType { none, panel, tile }

enum Panel {
  none(efficiency: 0, id: -1, name: "None"),
  prodOne(efficiency: 0.20, id: 1, name: "Darksun"),
  prodTwo(efficiency: 0.23, id: 2, name: "Bluepan");

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
  bool _dropdownTechnicalInfoActive = false;

  var _solarSides = [1, 1, 1, 1];
  // north south east west
  // 0 = false; 1 = true

  SolarType _solarType = SolarType.panel;
  Panel _activePanel = Panel.prodOne;
  Tile _activeTile = Tile.none;

  void toggleDropdownSideSelector() {
    setState(() {
      _dropdownSideSelectorActive = !_dropdownSideSelectorActive;
    });
  }

  void toggleDropdownTechnicalInfo() {
    setState(() {
      _dropdownTechnicalInfoActive = !_dropdownTechnicalInfoActive;
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
        page = SolarPotential();
        title = AppLocalizations.of(context)!.solar_potential;
        break;
      case Pages.storage:
        page = PageEnergyStorage();
        title = AppLocalizations.of(context)!.energy_storage;
        break;
      case Pages.regulations:
        page = _pageRegulations();
        title = AppLocalizations.of(context)!.regulations;
        break;
      case Pages.sustainability:
        page = PageSustainability();
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
      case Pages.sources:
        page = _pageSources();
        title = AppLocalizations.of(context)!.sources;
        break;
      case Pages.solarTechnology:
        page = SolarTechnology();
        title = AppLocalizations.of(context)!.solar_technology;
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
      bottomNavigationBar: EngagementNavBar(index: 1),
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
      Center(
          child: OutlinedButton.icon(
              icon: Icon(Icons.place),
              onPressed: () => setPage(Pages.solarTechnology),
              label: Text(AppLocalizations.of(context)!.solar_technology)))
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
            Divider(),
            Text(
              "_placeholder More information",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            OutlinedButton.icon(
                onPressed: () => setPage(Pages.external),
                icon: Icon(Icons.more),
                label: Text(AppLocalizations.of(context)!.external_resources)),
            OutlinedButton.icon(
                onPressed: () => setPage(Pages.sources),
                icon: Icon(Icons.source),
                label: Text(AppLocalizations.of(context)!.sources)),
            SizedBox(height: 10),
          ],
        )),
      ),
    );
  }

  Widget _pageRegulations() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Text(AppLocalizations.of(context)!.reg_content_p1),
            Text(AppLocalizations.of(context)!.reg_content_p2),
            UnorderedList([
              AppLocalizations.of(context)!.reg_content_l1_i1,
              AppLocalizations.of(context)!.reg_content_l1_i2,
              AppLocalizations.of(context)!.reg_content_l1_i3,
            ]),
            ZoomableImage(path: 'assets/images/regulations.png'),
            SizedBox(
              height: 10,
            ),
            Text(
              "_placeholder Guidelines by Byantikvaren",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ]),
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
        OutlinedButton.icon(
            onPressed: () => print("pressed"),
            icon: Icon(Icons.compare),
            label: Text("_placeholder Compare")),
        ExpansionPanelList(
          expansionCallback: (panelIndex, isExpanded) =>
              toggleDropdownSideSelector(),
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
    List<double> monthCoeff = [
      .05,
      .18,
      .5,
      .8,
      .98,
      1,
      .94,
      .73,
      .55,
      .27,
      .06,
      .01
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
    // in m^2
    //List<List<double> sideSize = [72, 87, 38, 38];

    var sides = [
      {
        'sizes': [72.91],
        'rad': [400]
      },
      {
        'sizes': [32.69, 48.80, 7.18],
        'rad': [1000, 800, 600]
      },
      {
        'sizes': [38.59],
        'rad': [400]
      },
      {
        'sizes': [27.62, 9.26, 2.61],
        'rad': [1100, 1000, 800]
      }
    ];

    // loop all months of the year

    for (int x = 0; x < monthCoeff.length; x++) {
      double t = 0;

      // loop for every side of the house

      for (var side in sides) {
        // total estimated production per side is
        // estimated incident radiation times size of the side
        // lastly _solarSides is 1 if the panel is selected and 0 if it is inactive
        //t += monthCoeff[x][sideEff[i]] * sideSize[i] * _solarSides[i];
        for (int i = 0; i < side['sizes']!.length; i++) {
          t += (side['sizes']![i] * side['rad']![i] * panelEff * (monthCoeff[x]/12));
          //t += (side['sizes']![i] * side['rad']![i] * panelEff);
        }
      }

      estProd.add(FlSpot(x.toDouble(), (t).round().toDouble()));
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

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //Text(AppLocalizations.of(context)!.est_gen(AppLocalizations.of(context)!.kwt, total.toInt())),
              Text(
                AppLocalizations.of(context)!.est_usage,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 10,
              ),
              ..._energyContext(total),
              SizedBox(
                height: 10,
              ),
              _technicalInformation(estProd, total),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _energyContext(double total) {
    const double showerHourCost = 8.5;
    int hoursShower = total ~/ showerHourCost;

    double carBatterySize = 57.5;
    int carCharges = total ~/ carBatterySize;

    double energyPizza = 625;

    NumberFormat formatter = NumberFormat.decimalPattern('no');

    return [
      Row(
        children: [
          Icon(Icons.bolt),
          Text(
              "${formatter.format(total)} ${AppLocalizations.of(context)!.kwt}")
        ],
      ),
      Row(
        children: [
          Icon(Icons.shower),
          Text("$hoursShower _placeholder Hours oin Shower")
        ],
      ),
      Row(
        children: [
          Icon(Icons.car_crash),
          Text("$carCharges _placeholder Full Tesla Model 3 charges")
        ],
      ),
      Row(
        children: [
          Icon(Icons.local_pizza),
          Text("${(total ~/ energyPizza)} _placeholder Stek of pizza")
        ],
      ),
      SliderMoneySaved(total: total)
    ];
  }

  Widget _technicalInformation(List<FlSpot> estProd, double total) {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) =>
          toggleDropdownTechnicalInfo(),
      children: [
        ExpansionPanel(
            headerBuilder: (context, isExpanded) => ListTile(
                  title: Text("_placeholder Technical info"),
                ),
            body: Column(children: [_efficiencyGraph(estProd, total)]),
            isExpanded: _dropdownTechnicalInfoActive),
      ],
    );
  }

  Widget _efficiencyGraph(List<FlSpot> estProd, double total) {
    return AspectRatio(
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

  Widget _pageSources() {
    return Container();
  }
}

class PageEnergyStorage extends StatefulWidget {
  const PageEnergyStorage({
    super.key,
  });

  @override
  State<PageEnergyStorage> createState() => _PageEnergyStorageState();
}

class _PageEnergyStorageState extends State<PageEnergyStorage> {
  bool batteryActive = false;
  bool heatActive = false;
  bool mechanicActive = false;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
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
                      isExpanded: batteryActive),
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
                      isExpanded: heatActive),
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
                      isExpanded: mechanicActive)
                ],
              ),
              Divider(),
              Text(
                "_placeholder Summary",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              EngagementTable(titles: [
                'Type',
                'Risk',
                'Lifespan',
                'Efficiency'
              ], data: [
                ['Li-ion Battery', 'High', '2-3 years', '95%'],
                ['Pumped Storage', 'Very Low', '50 years', '80%'],
                ['Thermal and Heat storage', 'Low', '15-20 years', '50-90%'],
              ])
            ]),
          ),
        ),
      );
  Widget batteryBody() => Column(children: [
    Text(AppLocalizations.of(context)!
                            .energy_storage_content_battery_p1),
                            SizedBox(height: 10,),
                            Text(AppLocalizations.of(context)!
                            .energy_storage_content_battery_p2),
                            SizedBox(height: 10,),
                            Text(AppLocalizations.of(context)!
                            .energy_storage_content_battery_p3),
  ]);

  Widget thermalBody() => Column(children: [
    Text(AppLocalizations.of(context)!
                            .energy_storage_content_thermal_p1)
  ],);

  Widget hydroBody () => Column(
children: [
  Text(AppLocalizations.of(context)!
                            .energy_storage_content_mechanical_p1),
                            SizedBox(height: 10,),
                            Text(AppLocalizations.of(context)!
                            .energy_storage_content_mechanical_p2)
],
  );

}

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
              /*UnorderedList([
                AppLocalizations.of(context)!.social_sustainability,
                AppLocalizations.of(context)!.sus_eco,
                AppLocalizations.of(context)!.sus_env,
              ]),

              ExpansionPanelList(
          expansionCallback: (panelIndex, isExpanded) =>
              toggleDropdownSideSelector(),
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
              
              
              */
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
                      body: Text(AppLocalizations.of(context)!
                          .social_sustainability_content),
                      isExpanded: socialActive),
                  ExpansionPanel(
                      headerBuilder: (_, __) => ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.sus_eco,
                            ),
                          ),
                      body: Text(AppLocalizations.of(context)!
                          .economic_sustainability),
                      isExpanded: ecoActive),
                  ExpansionPanel(
                      headerBuilder: (_, __) => ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.sus_env,
                            ),
                          ),
                      body: Text(AppLocalizations.of(context)!
                          .environmental_sustainability_content),
                      isExpanded: envActive)
                ],
              ),
            ]),
          ),
        ),
      );
}

class SolarTechnology extends StatefulWidget {
  const SolarTechnology({
    super.key,
  });

  @override
  State<SolarTechnology> createState() => _SolarTechnologyState();
}

class _SolarTechnologyState extends State<SolarTechnology> {
  bool monoCrystalActive = false;
  bool polyCrystalActive = false;
  bool thinFilmActive = false;
  bool showcaseOld = false;
  bool showcaseNew = false;

  bool trad = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
                "_placeholder. There are three main PV-systems available: Monocrystalline, Polycrystaline and Thin film. "),
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                switch (panelIndex) {
                  case 0:
                    setState(() {
                      monoCrystalActive = !monoCrystalActive;
                    });
                    break;
                  case 1:
                    setState(() {
                      polyCrystalActive = !polyCrystalActive;
                    });
                    break;
                  case 2:
                    setState(() {
                      thinFilmActive = !thinFilmActive;
                    });
                    break;
                    case 3:
                    setState(() {
                      showcaseOld = !showcaseOld;
                    });
                    break;
                    case 4:
                    setState(() {
                      showcaseNew = !showcaseNew;
                    });
                    break;
                }
              },
              children: [
                ExpansionPanel(
                    headerBuilder: (context, isExpanded) => ListTile(
                          title: Text(
                            "Monocrystalline",
                          ),
                        ),
                    body: Text(AppLocalizations.of(context)!
                        .social_sustainability_content),
                    isExpanded: monoCrystalActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text("Polycrystaline"),
                        ),
                    body: Text(
                        AppLocalizations.of(context)!.economic_sustainability),
                    isExpanded: polyCrystalActive),
                ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text("Thin Film"),
                        ),
                    body: Text(AppLocalizations.of(context)!
                        .environmental_sustainability_content),
                    isExpanded: thinFilmActive),
                    ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text("Example Kirkegata 35"),
                        ),
                    body: kirkegata35(),
                    isExpanded: showcaseOld),
                    ExpansionPanel(
                    headerBuilder: (_, __) => ListTile(
                          title: Text("Example Berggate 4B"),
                        ),
                    body: berggate(),
                    isExpanded: showcaseNew)
              ],
            ),
            
            
          ],
        ),
      ),
    );
  }

  Widget berggate(){
    return Column(children: [
ZoomableImage(path: 'assets/images/berggate4b-default.png'),
            ZoomableImage(path: 'assets/images/berggate4b-trad-panel.png'),
            ZoomableImage(path: 'assets/images/berggate4b-alt-panel.png')
    ],);
  }

  Widget kirkegata35(){
    return Column(children :[
      Text("_placeholder Drag to see - (House without tiles on the left)"),
        OutlinedButton(onPressed: () =>
        setState(() {
          trad = !trad;
        }), child: Text(!trad ? "Traditional panel" : "Colored panel")),
      ImageCompareSlider(
  itemOne: Image.asset('assets/images/kirkegata35-default.png'),
  itemTwo: Image.asset(trad ? 'assets/images/kirkegata35-trad-panel.png' : 'assets/images/kirkegata35-alt-panel.png'),
    itemOneBuilder: (child, context) => IntrinsicHeight(child: child),
  itemTwoBuilder: (child, context) => IntrinsicHeight(child: child),
)
      /*ZoomableImage(path: 'assets/images/kirkegata35-default.png'),
            ZoomableImage(path: 'assets/images/kirkegata35-trad-panel.png'),
            ZoomableImage(path: 'assets/images/kirkegata35-alt-panel.png'),*/
            ]
    );
  }
}

class SolarPotential extends StatefulWidget {
  const SolarPotential({
    super.key,
  });

  @override
  State<SolarPotential> createState() => _SolarPotentialState();
}

class _SolarPotentialState extends State<SolarPotential> {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Center(
          child: Column(children: [
            ZoomableImage(path: 'assets/images/potential.png')
          ]),
        ),
      );
}

class SliderMoneySaved extends StatefulWidget {
  SliderMoneySaved({super.key, required this.total});

  final double total;

  @override
  State<SliderMoneySaved> createState() => _SliderMoneySavedState();
}

class _SliderMoneySavedState extends State<SliderMoneySaved> {
  double _energyPrice = 1;

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat.decimalPattern('no');
    return Column(
      children: [
        RichText(
          text: TextSpan(style: DefaultTextStyle.of(context).style, children: [
            WidgetSpan(child: Icon(Icons.payment)),
            TextSpan(
                text:
                    "_placeholder Drag to change electricity price calculate market value:")
          ]),
        ),
        Slider(
            value: _energyPrice,
            min: 0,
            max: 600,
            divisions: 600,
            label: "${_energyPrice.round()}øre",
            onChanged: (value) => setState(() {
                  print(value);
                  _energyPrice = value;
                })),
        RichText(
          text: TextSpan(style: DefaultTextStyle.of(context).style, children: [
            WidgetSpan(child: Icon(Icons.savings)),
            TextSpan(
                text:
                    "${formatter.format((widget.total * (_energyPrice / 100)).toInt())}kr _placeholder Worth of electricity generated at ${_energyPrice.toInt()} øre/kwt")
          ]),
        ),
      ],
    );
  }
}

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
