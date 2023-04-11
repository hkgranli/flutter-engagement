import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart' show ModelViewer;
import 'package:engagement/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';

class InteractivePage extends StatefulWidget {
  const InteractivePage({super.key});

  @override
  State<InteractivePage> createState() => _InteractivePageState();
}

enum InteractivePages { home, pvView, ecoView }

enum SolarType { none, panel, tile }

enum Panel { none, PanL, Dodge }

enum Tile { none, Molly, Emp }

class _InteractivePageState extends State<InteractivePage>
    with TickerProviderStateMixin {
  bool _showcase = true;
  var activePage = InteractivePages.home;

  var _solarSides = [1, 1, 1, 1];
  // north south east west
  // 0 = false; 1 = true

  SolarType _solarType = SolarType.panel;
  Panel _activePanel = Panel.PanL;
  Tile _activeTile = Tile.none;

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

  void setPage(int index) {
    var newPage = activePage;
    var show = _showcase;

    switch (index) {
      case 0:
        newPage = InteractivePages.home;
        break;
      case 1:
        newPage = InteractivePages.pvView;
        show = true;
        break;
      case 2:
        newPage = InteractivePages.pvView;
        show = false;
        break;
      case 3:
        newPage = InteractivePages.ecoView;
        break;
      default:
        return;
    }

    setState(() {
      activePage = newPage;
      _showcase = show;
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
      case InteractivePages.home:
        page = _buildHome();
        appBar =
            createAppBar(context, AppLocalizations.of(context)!.interactive);
        break;
      case InteractivePages.pvView:
        page = _buildPvView();
        appBar = _buildPvBar(context);
        break;
      case InteractivePages.ecoView:
        page = _buildEco();
        appBar = createAppBar(
            context,
            AppLocalizations.of(context)!.interactive,
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => setPage(0),
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
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OutlinedButton(
            onPressed: () => setPage(1), child: Text("Visualization")),
        SizedBox(height: 10),
        OutlinedButton(
            onPressed: () => setPage(2), child: Text("Efficiency Estimation")),
        SizedBox(height: 10),
        OutlinedButton(
            onPressed: () => setPage(3), child: Text("Economic Models"))
      ],
    ));
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
        "Interactive",
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setPage(0),
        ),
        TabBar(
          tabs: [
            Tab(icon: Icon(Icons.camera)),
            Tab(icon: Icon(Icons.solar_power)),
          ],
          controller: tabController,
        ));
  }

  Widget _buildPvView() {
    Widget page;

    if (_showcase) {
      page = _modelViewer();
    } else {
      page = _energyEst();
    }

    return Center(
      child: Column(
        children: [
          _buildConfig(),
          const Divider(),
          page,
        ],
      ),
    );
  }

  Widget _buildConfig() {
    List<DropdownMenuItem<SolarType>> menuItems = [
      DropdownMenuItem(value: SolarType.none, child: Text("Select Solar Type")),
      DropdownMenuItem(value: SolarType.panel, child: Text("Panel")),
      DropdownMenuItem(value: SolarType.tile, child: Text("Tile")),
    ];

    DropdownButton b = DropdownButton(items: null, onChanged: null);

    if (_solarType == SolarType.panel) {
      List<DropdownMenuItem<Panel>> panelItems = [
        DropdownMenuItem(value: Panel.none, child: Text("Select Product")),
        DropdownMenuItem(value: Panel.Dodge, child: Text("Dodge")),
        DropdownMenuItem(value: Panel.PanL, child: Text("PanL")),
      ];

      b = DropdownButton(
          value: _activePanel, items: panelItems, onChanged: setSelectedPanel);
    } else if (_solarType == SolarType.tile) {
      List<DropdownMenuItem<Tile>> tileItems = [
        DropdownMenuItem(value: Tile.none, child: Text("Select Product")),
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
            Text("Select solar type: "),
            DropdownButton(
                value: _solarType, items: menuItems, onChanged: setSolarType),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Select product: "),
            b,
          ],
        ),
        Text("Roof sides:", style: TextStyle(fontWeight: FontWeight.bold)),
        ..._sideSelector()
      ],
    );
  }

  List<Widget> _sideSelector() {
    return [
      CheckboxListTile(
          visualDensity: VisualDensity.compact,
          value: _solarSides[0] == 1,
          onChanged: (p) => toggleSide(0, _solarSides[0] == 1 ? 0 : 1),
          title: const Text("North"),
          dense: true),
      CheckboxListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          value: _solarSides[2] == 1,
          onChanged: (p) => toggleSide(2, _solarSides[2] == 1 ? 0 : 1),
          title: const Text("East")),
      CheckboxListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          value: _solarSides[3] == 1,
          onChanged: (p) => toggleSide(3, _solarSides[3] == 1 ? 0 : 1),
          title: const Text("West")),
      CheckboxListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          value: _solarSides[1] == 1,
          onChanged: (p) => toggleSide(1, _solarSides[1] == 1 ? 0 : 1),
          title: const Text("South")),
    ];
  }

  Widget check_test() {
    return InkWell(
      onTap: () {
        toggleSide(1, _solarSides[1] == 1 ? 0 : 1);
      },
      child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Checkbox(
          value: _solarSides[1] == 1,
          onChanged: (bool? newValue) {
            toggleSide(1, _solarSides[1] == 1 ? 0 : 1);
          },
        ),
        Text("Test"),
      ]),
    );
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
          key: UniqueKey(), // key ensures the widget is updated
        ),
      ),
    );

    // maxOrbit ensures user cannot look under the model
  }

  String _getModelUrl() {
    var base = "assets/models/house";

    //var c = "_${_solarSides.join()}";
    var c = "_1111";

    const extension = ".glb";

    // guard clauses for invalid config

    if (_solarType == SolarType.none ||
        (_solarType == SolarType.panel && _activePanel == Panel.none) ||
        (_solarType == SolarType.tile && _activeTile == Tile.none)) {
      return "$base$extension";
    }

    String t;

    if (_solarType == SolarType.panel) {
      t = _activePanel == Panel.PanL ? "_panel_panL" : "_panel_dodge";
    } else {
      t = _activeTile == Tile.Emp ? "_tile_Emp" : "_tile_Molly";
    }
    var url = "$base$t$c$extension";

    print("FETCHing $url");
    return url;
  }

  Widget _energyEst() {
    return Text("Est");
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
    List<Feature> features = [
      Feature(
        title: "Drink Water",
        color: Colors.blue,
        data: [
          0.2,
          0.8,
          1,
          0.7,
          0.6,
          0.2,
          0.8,
          1,
          0.7,
          0.6,
          0.2,
          0.6,
          0.2,
        ],
      )
    ];

    return _createGraph([
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mai',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ], [
      '20%',
      '40%',
      '60%',
      '80%',
      '100%'
    ], features);
  }

  Widget _createGraph(
      List<String> labelX, List<String> labelY, List<Feature> features) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
        ),
        LineGraph(
          features: features,
          size: Size(MediaQuery.of(context).size.width - 20, 400),
          labelX: labelX,
          labelY: labelY,
          showDescription: true,
          graphColor: Color.fromARGB(77, 0, 0, 0),
          graphOpacity: 0.2,
          verticalFeatureDirection: true,
          descriptionHeight: 130,
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }

  Widget LeasingModel() => Text("Leasing");

  Widget PrivateModel() => Text("Private");

  Widget Landing() => Text("Select a model");
}
