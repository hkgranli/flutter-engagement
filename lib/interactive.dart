import 'package:engagement/components.dart';
import 'package:engagement/estimations/efficiency.dart';
import 'package:engagement/estimations/radiation.dart';
import 'package:engagement/estimations/visual.dart';
import 'package:engagement/knowledge_base/economicmodels.dart';
import 'package:engagement/knowledge_base/energystorage.dart';
import 'package:engagement/knowledge_base/regulations.dart';
import 'package:engagement/knowledge_base/solarpotential.dart';
import 'package:engagement/knowledge_base/solartechnology.dart';
import 'package:engagement/knowledge_base/sustainability.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

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
  InteractivePage({super.key, required this.activePage, this.showcasePage});

  final Pages activePage;
  final EstimationPages? showcasePage;

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

  void setPage(Pages p, [EstimationPages? ep]) {
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
        page = RegulationsPage();
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
            Tab(
                icon: Icon(Icons.sunny),
                text: AppLocalizations.of(context)!.rad_tab),
          ],
          controller: tabController,
        ));
  }

  Widget _pageSources() {
    return Container();
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

  SolarType _solarTypeCompare = SolarType.panel;
  Panel _activePanelCompare = Panel.prodOne;
  Tile _activeTileCompare = Tile.none;

  bool compare = false;

  void toggleCompare() {
    setState(() {
      compare = !compare;
    });
  }

  void setSelectedPanelCompare(dynamic p) {
    if (p is Panel) {
      setState(() {
        _activePanelCompare = p;
      });
    }
  }

  void setSelectedTileCompare(dynamic t) {
    if (t is Tile) {
      setState(() {
        _activeTileCompare = t;
      });
    }
  }

  bool _dropdownSideSelectorActive = false;

  void toggleDropdownSideSelector() {
    setState(() {
      _dropdownSideSelectorActive = !_dropdownSideSelectorActive;
    });
  }

  void setSolarTypeCompare(dynamic s) {
    setState(() {
      _solarTypeCompare = s!;
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

  Widget configRadiation() {
    return Column(
      children: [
        Text(
            "_placeholder This model shows yearly estimated radiation for surfaces over 400 kWh/m^2:"),
        UnorderedList(
          texts: [
            UnorderedListItemInline(
                text: "1110 ${AppLocalizations.of(context)!.kwt}/m^2",
                color: Colors.red),
            UnorderedListItemInline(
                text: "1000 ${AppLocalizations.of(context)!.kwt}/m^2",
                color: Colors.orange),
            UnorderedListItemInline(
                text: "800 ${AppLocalizations.of(context)!.kwt}/m^2",
                color: Colors.yellow),
            UnorderedListItemInline(
                text: "600 ${AppLocalizations.of(context)!.kwt}/m^2",
                color: Colors.green),
            UnorderedListItemInline(
                text: "400 ${AppLocalizations.of(context)!.kwt}/m^2",
                color: Colors.blue),
          ],
          inline: true,
        ),
      ],
    );
  }

  Widget _buildConfig() {
    if (widget.page == EstimationPages.radiation) return configRadiation();
    if (widget.page == EstimationPages.efficiency && compare) {
      return buildConfigCompare();
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

    Widget compareButton = widget.page == EstimationPages.aesthetic
        ? Container()
        : OutlinedButton.icon(
            onPressed: () => toggleCompare(),
            icon: Icon(Icons.compare),
            label: Text("_placeholder"));

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
        compareButton,
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

  Widget buildConfigCompare() {
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
    DropdownButton d = DropdownButton(items: null, onChanged: null);

    if (_solarType == SolarType.panel) {
      List<DropdownMenuItem<Panel>> productItems = [
        DropdownMenuItem(
            value: Panel.none,
            child: Text(AppLocalizations.of(context)!.select_product)),
        DropdownMenuItem(value: Panel.prodTwo, child: Text(Panel.prodTwo.name)),
        DropdownMenuItem(value: Panel.prodOne, child: Text(Panel.prodOne.name))
      ];

      b = DropdownButton(
          value: _activePanel,
          items: productItems,
          onChanged: setSelectedPanel);
    } else if (_solarType == SolarType.tile) {
      List<DropdownMenuItem<Tile>> productItems = [
        DropdownMenuItem(
            value: Tile.none,
            child: Text(AppLocalizations.of(context)!.select_product)),
        DropdownMenuItem(value: Tile.prodTwo, child: Text(Tile.prodTwo.name)),
        DropdownMenuItem(value: Tile.prodOne, child: Text(Tile.prodOne.name)),
      ];

      b = DropdownButton(
          value: _activeTile, items: productItems, onChanged: setSelectedTile);
    }

    if (_solarTypeCompare == SolarType.panel) {
      List<DropdownMenuItem<Panel>> productItems = [
        DropdownMenuItem(
            value: Panel.none,
            child: Text(AppLocalizations.of(context)!.select_product)),
        DropdownMenuItem(value: Panel.prodTwo, child: Text(Panel.prodTwo.name)),
        DropdownMenuItem(value: Panel.prodOne, child: Text(Panel.prodOne.name)),
      ];
      d = DropdownButton(
          value: _activePanelCompare,
          items: productItems,
          onChanged: setSelectedPanelCompare);
    } else if (_solarTypeCompare == SolarType.tile) {
      List<DropdownMenuItem<Tile>> productItems = [
        DropdownMenuItem(
            value: Tile.none,
            child: Text(AppLocalizations.of(context)!.select_product)),
        DropdownMenuItem(value: Tile.prodTwo, child: Text(Tile.prodTwo.name)),
        DropdownMenuItem(value: Tile.prodOne, child: Text(Tile.prodOne.name)),
      ];

      d = DropdownButton(
          value: _activeTileCompare,
          items: productItems,
          onChanged: setSelectedTileCompare);
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButton(
                value: _solarType, items: menuItems, onChanged: setSolarType),
            b
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButton(
                value: _solarTypeCompare,
                items: menuItems,
                onChanged: setSolarTypeCompare),
            d
          ],
        ),
        OutlinedButton.icon(
            onPressed: () => toggleCompare(),
            icon: Icon(Icons.compare),
            label: Text("_placeholder")),
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
        if (compare) {
          content = Expanded(
            child: Column(
              children: [
                Text("Config1:"),
                EnergyEstimation(
                  activePanel: _activePanel,
                  activeTile: _activeTile,
                  solarSides: _solarSides,
                  solarType: _solarType,
                  boolSlider: false,
                ),
                Text("Config2:"),
                EnergyEstimation(
                  activePanel: _activePanelCompare,
                  activeTile: _activeTileCompare,
                  solarSides: _solarSides,
                  solarType: _solarTypeCompare,
                  boolSlider: false,
                ),
              ],
            ),
          );
        } else {
          content = EnergyEstimation(
            activePanel: _activePanel,
            activeTile: _activeTile,
            solarSides: _solarSides,
            solarType: _solarType,
          );
        }
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
