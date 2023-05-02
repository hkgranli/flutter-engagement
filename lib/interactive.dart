import 'dart:io';

import 'package:engagement/components.dart';
import 'package:engagement/estimations/efficiency.dart';
import 'package:engagement/estimations/radiation.dart';
import 'package:engagement/estimations/visual.dart';
import 'package:engagement/knowledge_base/economicmodels.dart';
import 'package:engagement/knowledge_base/energystorage.dart';
import 'package:engagement/knowledge_base/regulations.dart';
import 'package:engagement/knowledge_base/solarpotential.dart';
import 'package:engagement/knowledge_base/solartechnology.dart';
import 'package:engagement/knowledge_base/sources.dart';
import 'package:engagement/knowledge_base/sustainability.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

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
  none(efficiency: 0, id: -1, name: "None", url:""),
  prodOne(efficiency: 0.211, id: 1, name: "Evervolt H", url: "https://ftp.panasonic.com/solar/datasheet/ds_evpv390h.pdf"),
  prodTwo(efficiency: 0.17, id: 2, name: "RS Pro Poly", url: "https://docs.rs-online.com/13c9/0900766b815873b0.pdf");

  const Panel({required this.efficiency, required this.id, required this.name, required this.url});

  final double efficiency;
  final int id;
  final String name;
  final String url;
}

enum Tile {
  none(efficiency: 0, id: -1, name: "None", url : ""),
  prodOne(efficiency: 0.19, id: 1, name: "Solarstone", url: "https://solarstone.com/assets/product-cards/_2023-04-solar-tiled-roof-datasheet.pdf"),
  prodTwo(efficiency: 0.192, id: 2, name: "ErgoSun", url:"https://www.ergosun.com/_files/ugd/29edcf_7d4fce17429f458fa660ce124e007ff7.pdf");

  const Tile({required this.efficiency, required this.id, required this.name, required this.url});

  final double efficiency;
  final int id;
  final String name;
  final String url;
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

  bool knowledge = false;
  bool visualization = false;
  bool moreInfo = false;

  bool a = true;

  void toggleMoreInfo() {
    setState(() {
      moreInfo = !moreInfo;
    });
  }

  void toggleVisualization() {
    setState(() {
      visualization = !visualization;
    });
  }

  void toggleKnowledge() {
    setState(() {
      knowledge = !knowledge;
    });
  }

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
        page = ExternalPage();
        title = AppLocalizations.of(context)!.external_resources;
        break;
      case Pages.ownershipView:
        page = EconomicModels();
        title = AppLocalizations.of(context)!.eco_model;
        break;
      case Pages.sources:
        page = SourcesPage();
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

  List<Widget> newKnowledge() {
    var knowledgeList = [];

    if (knowledge) {
      knowledgeList.addAll([
        ListTile(
          leading: Icon(Icons.sunny),
          title: Text(AppLocalizations.of(context)!.solar_potential),
          trailing: Icon(Icons.arrow_right),
          onTap: () => setPage(Pages.potential),
        ),
        ListTile(
          leading: Icon(Icons.battery_4_bar),
          title: Text(AppLocalizations.of(context)!.energy_storage),
          trailing: Icon(Icons.arrow_right),
          onTap: () => setPage(Pages.storage),
        ),
        ListTile(
          leading: Icon(Icons.rule),
          title: Text(AppLocalizations.of(context)!.regulations),
          trailing: Icon(Icons.arrow_right),
          onTap: () => setPage(Pages.regulations),
        ),
        ListTile(
          leading: Icon(Icons.energy_savings_leaf),
          title: Text(AppLocalizations.of(context)!.sustainability),
          trailing: Icon(Icons.arrow_right),
          onTap: () => setPage(Pages.pvView),
        ),
        ListTile(
          leading: Icon(Icons.engineering),
          title: Text(AppLocalizations.of(context)!.solar_technology),
          trailing: Icon(Icons.arrow_right),
          onTap: () => setPage(Pages.solarTechnology),
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: Text(AppLocalizations.of(context)!.eco_model),
          trailing: Icon(Icons.arrow_right),
          onTap: () => setPage(Pages.ownershipView),
        )
      ]);
    }

    return [
      Center(
        child: Card(
            child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.book),
              title: Text(AppLocalizations.of(context)!.knowledge_base),
              subtitle: Text(AppLocalizations.of(context)!.knowledge_short),
              trailing: knowledge
                  ? Icon(Icons.arrow_upward)
                  : Icon(Icons.arrow_downward),
              onTap: () => toggleKnowledge(),
            ),
            ...knowledgeList
          ],
        )),
      ),
    ];
  }

  List<Widget> oldKnowledge() {
    return [
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
  }

  List<Widget> newInteractive() {
    var interactiveList = [];

    if (visualization) {
      interactiveList = [
        ListTile(
          leading: Icon(Icons.roofing),
          title: Text(AppLocalizations.of(context)!.aesthetic),
          trailing: Icon(Icons.arrow_right),
          onTap: () => setPage(Pages.pvView, EstimationPages.aesthetic),
        ),
        ListTile(
          leading: Icon(Icons.calculate),
          title: Text(AppLocalizations.of(context)!.eff_est),
          trailing: Icon(Icons.arrow_right),
          onTap: () => setPage(Pages.pvView, EstimationPages.efficiency),
        ),
        ListTile(
          leading: Icon(Icons.sunny),
          title: Text(AppLocalizations.of(context)!.solar_potential),
          trailing: Icon(Icons.arrow_right),
          onTap: () => setPage(Pages.pvView, EstimationPages.radiation),
        )
      ];
    }

    return [
      Center(
        child: Card(
            child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.touch_app),
              title: Text(AppLocalizations.of(context)!.visualization),
              subtitle: Text(AppLocalizations.of(context)!.visualization_short),
              trailing: Icon(
                  visualization ? Icons.arrow_upward : Icons.arrow_downward),
              onTap: () => toggleVisualization(),
            ),
            ...interactiveList
          ],
        )),
      ),
    ];
  }

  List<Widget> oldInteractive() {
    return [
      Text(
        AppLocalizations.of(context)!.interactive,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
              onPressed: () => setPage(Pages.pvView, EstimationPages.aesthetic),
              icon: Icon(Icons.roofing),
              label: Text(AppLocalizations.of(context)!.visualization)),
          OutlinedButton.icon(
              onPressed: () =>
                  setPage(Pages.pvView, EstimationPages.efficiency),
              icon: Icon(Icons.calculate),
              label: Text(AppLocalizations.of(context)!.eff_est)),
        ],
      ),
      OutlinedButton.icon(
          onPressed: () => setPage(Pages.pvView, EstimationPages.radiation),
          icon: Icon(Icons.sunny),
          label: Text(AppLocalizations.of(context)!.solar_potential)),
    ];
  }

  Widget _pageHome() {
    var moreList = [];

    if (moreInfo) {
      moreList = [
        ListTile(
          leading: Icon(Icons.more),
          title: Text(AppLocalizations.of(context)!.external_resources),
          trailing: Icon(Icons.arrow_right),
          onTap: () => setPage(Pages.external),
        ),
        ListTile(
          leading: Icon(Icons.source),
          title: Text(AppLocalizations.of(context)!.sources),
          trailing: Icon(Icons.arrow_right),
          onTap: () => setPage(Pages.sources),
        ),
      ];
    }

    var more = Center(
      child: Card(
        child: Column(children: [
          ListTile(
            leading: Icon(Icons.book),
            title: Text(AppLocalizations.of(context)!.more_info),
            trailing: moreInfo
                ? Icon(Icons.arrow_upward)
                : Icon(Icons.arrow_downward),
            onTap: () => toggleMoreInfo(),
          ),
          ...moreList
        ]),
      ),
    );

    var knowledgeComponent = a ? newKnowledge() : oldKnowledge();
    var interactiveComponent = a ? newInteractive() : oldInteractive();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(
          children: [
            ...knowledgeComponent,
            Divider(),
            ...interactiveComponent,
            Divider(),
            more,
            SizedBox(height: 10),
          ],
        )),
      ),
    );
  }

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
                text: AppLocalizations.of(context)!.aesthetic),
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
}

class ExternalPage extends StatefulWidget {
  const ExternalPage({
    super.key,
  });

  @override
  State<ExternalPage> createState() => _ExternalPageState();
}

class _ExternalPageState extends State<ExternalPage> {
  bool englishDropdown = false;
  bool norwegianDropdown = false;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Center(
          child: Column(children: [
            ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              switch (panelIndex) {
                case 0:
                  setState(() {
                    norwegianDropdown = !norwegianDropdown;
                  });
                  break;
                case 1:
                  setState(() {
                    englishDropdown = !englishDropdown;
                  });
                  break;
              }
            },
            children: [
              ExpansionPanel(
                  headerBuilder: (context, isExpanded) => ListTile(
                        title: Text(
                            AppLocalizations.of(context)!.sources_img_intro),
                      ),
                  body: norwegianBody(),
                  isExpanded: norwegianDropdown),
              ExpansionPanel(
                  headerBuilder: (_, __) => ListTile(
                        title: Text(AppLocalizations.of(context)!
                            .sources_content_intro),
                      ),
                  body: englishBody(),
                  canTapOnHeader: true,
                  isExpanded: englishDropdown),
            ],
          ),
          ]),
        ),
      );

  Widget englishBody(){
    return Container();
  }

  Widget norwegianBody(){
    return Column(
      children: [
      ElevatedButton(child: Text("Click"), onPressed: () => launchUrl(Uri.parse("https://blogg.sintef.no/sintefenergy-nb/solcellepanel-pa-taket-er-det-lonnsomt")))]
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

  SolarType _solarType = SolarType.none;
  Panel _activePanel = Panel.none;
  Tile _activeTile = Tile.none;

  SolarType _solarTypeCompare = SolarType.none;
  Panel _activePanelCompare = Panel.none;
  Tile _activeTileCompare = Tile.none;

  List<bool> radiationSelect = [true, false];
  List<bool> overviewSelect = [true, false, false, false];

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

    List<Widget> conf = radiationSelect[0]? radiationModelConfig() : radiationOverviewConfig();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
            
          ToggleButtons(
        direction: Axis.horizontal,
        onPressed: (int index) {
          setState(() {
            // The button that is tapped is set to true, and the others to false.
            for (int i = 0; i < radiationSelect.length; i++) {
              radiationSelect[i] = i == index;
            }
          });
        },
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        constraints: const BoxConstraints(
          minHeight: 40.0,
          minWidth: 80.0,
        ),
        isSelected: radiationSelect,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context)!.rad_model),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context)!.rad_overview),
          ),
        ],
      ),
        ...conf
        ],
      ),
    );
  }

  List<Widget> radiationModelConfig() {
    return [
      Text(AppLocalizations.of(context)!.radiation_about),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.fiber_manual_record, color: Colors.red),
              Text("1000 ${AppLocalizations.of(context)!.kwtt}/m^2"),
              Icon(Icons.fiber_manual_record, color: Colors.orange),
              Text("800 ${AppLocalizations.of(context)!.kwtt}/m^2"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.fiber_manual_record, color: Colors.yellow),
              Text("500 ${AppLocalizations.of(context)!.kwtt}/m^2"),
              Icon(Icons.fiber_manual_record, color: Colors.blue),
              Text("300 ${AppLocalizations.of(context)!.kwtt}/m^2"),
            ],
          )
    ];
  }

  List<Widget> radiationOverviewConfig(){
    return [
      ToggleButtons(
        direction: Axis.horizontal,
        onPressed: (int index) {
          setState(() {
            // The button that is tapped is set to true, and the others to false.
            for (int i = 0; i < overviewSelect.length; i++) {
              overviewSelect[i] = i == index;
            }
          });
        },
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        constraints: const BoxConstraints(
          minHeight: 40.0,
          minWidth: 80.0,
        ),
        isSelected: overviewSelect,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context)!.dir_ne),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context)!.dir_nw),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context)!.dir_se),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(AppLocalizations.of(context)!.dir_sw),
          ),
        ],
      ),
    ];
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
            label: Text(AppLocalizations.of(context)!.compare));

    DropdownButton b = DropdownButton(items: null, onChanged: null);

    Widget questionMark = Container();

    if (_solarType == SolarType.panel) {
      List<DropdownMenuItem<Panel>> panelItems = [
        DropdownMenuItem(
            value: Panel.none,
            child: Text(AppLocalizations.of(context)!.select_product)),
        DropdownMenuItem(
            value: Panel.prodTwo,
            child: Text(
                "${Panel.prodTwo.name} ${((Panel.prodTwo.efficiency) * 100).toInt()}%")),
        DropdownMenuItem(
            value: Panel.prodOne,
            child: Text(
                "${Panel.prodOne.name} ${((Panel.prodOne.efficiency) * 100).toInt()}%")),
      ];

      if (_activePanel != Panel.none) {
        questionMark = productInfoButton();
      }

      b = DropdownButton(
          value: _activePanel, items: panelItems, onChanged: setSelectedPanel);
    } else if (_solarType == SolarType.tile) {
      List<DropdownMenuItem<Tile>> tileItems = [
        DropdownMenuItem(
            value: Tile.none,
            child: Text(AppLocalizations.of(context)!.select_product)),
        DropdownMenuItem(
            value: Tile.prodTwo,
            child: Text(
                "${Tile.prodTwo.name} ${((Tile.prodTwo.efficiency) * 100).toInt()}%")),
        DropdownMenuItem(
            value: Tile.prodOne,
            child: Text(
                "${Tile.prodOne.name} ${((Tile.prodOne.efficiency) * 100).toInt()}%")),
      ];

      if (_activeTile != Tile.none) {
        questionMark = productInfoButton();
      }

      b = DropdownButton(
          value: _activeTile, items: tileItems, onChanged: setSelectedTile);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("${AppLocalizations.of(context)!.select_type}: "),
              DropdownButton(
                value: _solarType,
                items: menuItems,
                onChanged: setSolarType,
                isDense: true,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("${AppLocalizations.of(context)!.select_product}: "),
              b,
              questionMark
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
                  isExpanded: _dropdownSideSelectorActive,
                  canTapOnHeader: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget productInfoButton() {
    return IconButton(
      icon: Icon(Icons.question_mark),
      onPressed: () {
        print("press");
        showModalBottomSheet(
            context: context, builder: (context) => productInfo());
      },
      tooltip: 'ProductInfo',
    );
  }

  Widget productInfo() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            specTable(),
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.specs),
              onPressed: () async {
                Uri? u = getActiveUri();
                if(u == null) return; 
                if(await canLaunchUrl(u)) launchUrl(u, mode: LaunchMode.externalApplication);
              },),
          ],
        ),
      ),
    );
  }

  Widget specTable(){
    return Container();
    /*
    var data = [[Text('test')]];
    var titles = ['test'];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: EngagementTable(titles: titles, data: data, titleStyled: false,),
    );*/
  }

  Uri? getActiveUri(){
    if(_solarType == SolarType.panel){
      return _activePanel == Panel.none? null : Uri.parse(_activePanel.url);
    } else if (_solarType == SolarType.tile){
      return _activeTile == Tile.none? null : Uri.parse(_activeTile.url);

    }
    return null;
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
            icon: Icon(Icons.arrow_back),
            label: Text("Single")),
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
                isExpanded: _dropdownSideSelectorActive,
                canTapOnHeader: true),
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

  Widget buildRadiationPage(){
    if(radiationSelect[0]) return RadiationPage();
    
    List<String> images = ['pNE', 'pNW', 'pSE', 'pSW'];
    String image;

    if(overviewSelect[0]){
      image = images[0];
    } else if(overviewSelect[1]){
      image = images[1];
    }else if(overviewSelect[2]){
      image = images[2];
    }else if(overviewSelect[3]){
      image = images[3];
    } else {
      return Container(); // should never happen or smth 
    }

    return ZoomableImage(path:"assets/images/${image}_dot.png");
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
              child: EfficiencyTableComparator(
                  activePanel: _activePanel,
                  activePanelCompare: _activePanelCompare,
                  activeTile: _activeTile,
                  activeTileCompare: _activeTileCompare,
                  solarSides: _solarSides,
                  solarType: _solarType,
                  solarTypeCompare: _solarTypeCompare,
                  key: UniqueKey()));
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
        content = buildRadiationPage();
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
