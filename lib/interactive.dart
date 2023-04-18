import 'package:engagement/components.dart';
import 'package:engagement/estimations/efficiency.dart';
import 'package:engagement/estimations/radiation.dart';
import 'package:engagement/estimations/visual.dart';
import 'package:engagement/knowledge_base/economicmodels.dart';
import 'package:engagement/knowledge_base/energystorage.dart';
import 'package:engagement/knowledge_base/solarpotential.dart';
import 'package:engagement/knowledge_base/solartechnology.dart';
import 'package:engagement/knowledge_base/sustainability.dart';
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
  InteractivePage(
      {super.key, required this.activePage, this.showcasePage = null});

  final Pages activePage;
  EstimationPages? showcasePage;

  @override
  State<InteractivePage> createState() => _InteractivePageState();
}

class _InteractivePageState extends State<InteractivePage>
    with TickerProviderStateMixin {
  late EstimationPages e;

  @override
  void initState() {
    super.initState();
    e = widget.showcasePage != null
        ? widget.showcasePage as EstimationPages
        : EstimationPages.aesthetic;
  }

  void setInteractve(EstimationPages ep) {
    setState(() {
      e = ep;
    });
  }

  void setPage(Pages p, [EstimationPages? ep = null]) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InteractivePage(
                  activePage: p,
                  showcasePage: ep,
                )));
    /*
    setState(() {
      activePage = p;
      _showcase = show!;
    });
    */
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
        page = Estimations(
          page: e,
        );
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
        page = EconomicModels();
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
                onPressed: () =>
                    setPage(Pages.pvView, EstimationPages.aesthetic),
                icon: Icon(Icons.roofing),
                label: Text(AppLocalizations.of(context)!.visualization)),
            OutlinedButton.icon(
                onPressed: () =>
                    setPage(Pages.pvView, EstimationPages.efficiency),
                icon: Icon(Icons.calculate),
                label: Text(AppLocalizations.of(context)!.eff_est)),
          ],
        ),
      ),
      OutlinedButton.icon(
          onPressed: () => setPage(Pages.pvView, EstimationPages.radiation),
          icon: Icon(Icons.sunny),
          label: Text(AppLocalizations.of(context)!.solar_potential)),
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
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton.icon(
              icon: Icon(Icons.place),
              onPressed: () => setPage(Pages.solarTechnology),
              label: Text(AppLocalizations.of(context)!.solar_technology)),
          OutlinedButton.icon(
              onPressed: () => setPage(Pages.ownershipView),
              icon: Icon(Icons.people),
              label: Text(AppLocalizations.of(context)!.eco_model))
        ],
      ))
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
    int initialIndex = 0;

    switch (e) {
      case EstimationPages.aesthetic:
        initialIndex = 0;
        break;
      case EstimationPages.efficiency:
        initialIndex = 1;
        break;
      case EstimationPages.radiation:
        initialIndex = 2;
        break;
    }

    final TabController tabController =
        TabController(length: 3, initialIndex: initialIndex, vsync: this);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        EstimationPages p;
        switch (tabController.index) {
          case 1:
            p = EstimationPages.efficiency;
            break;
          case 2:
            p = EstimationPages.radiation;
            break;
          default:
            p = EstimationPages.aesthetic;
            break;
        }
        setInteractve(p);
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
            Tab(icon: Icon(Icons.sunny), text: "_placeholder rad"),
          ],
          controller: tabController,
        ));
  }

  Widget _pageSources() {
    return Container();
  }
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

enum EstimationPages { aesthetic, radiation, efficiency }

class Estimations extends StatefulWidget {
  const Estimations({
    super.key,
    required this.page,
  });

  final EstimationPages page;

  @override
  State<Estimations> createState() => _EstimationsState();
}

class _EstimationsState extends State<Estimations> {
  var _solarSides = [1, 1, 1, 1];
  // north south east west
  // 0 = false; 1 = true

  SolarType _solarType = SolarType.panel;
  Panel _activePanel = Panel.prodOne;
  Tile _activeTile = Tile.none;

  bool _dropdownSideSelectorActive = false;
  void toggleDropdownSideSelector() {
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

  Widget _buildConfig() {
    if (widget.page == EstimationPages.radiation) {
      return Column(
        children: [
          Text(
              "_placeholder This model shows yearly estimated radiation for surfaces over 400 kWh/m^2:"),
          Text("red 1100 kwh/m^2"),
          Text("orange 1000 kwh/m^2"),
          Text("yellow 800 kwh/m^2"),
          Text("green 600 kwh/m^2"),
          Text("blue 400 kwh/m^2"),
        ],
      );
    }

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

  @override
  Widget build(BuildContext context) {
    Widget content = Container();

    switch (widget.page) {
      case EstimationPages.aesthetic:
        content = VisualizationPage(
            activePanel: _activePanel,
            activeTile: _activeTile,
            solarSides: _solarSides,
            solarType: _solarType);
        break;
      case EstimationPages.efficiency:
        content = EnergyEstimation(
            activePanel: _activePanel,
            activeTile: _activeTile,
            solarSides: _solarSides,
            solarType: _solarType);
        break;
      case EstimationPages.radiation:
        content = RadiationPage();
        break;
    }

    return Center(
      child: Column(
        children: [
          _buildConfig(),
          content,
        ],
      ),
    );
  }
}
