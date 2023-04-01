import 'package:engagement/components.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class InteractivePage extends StatefulWidget {
  const InteractivePage({super.key});

  @override
  State<InteractivePage> createState() => _InteractivePageState();
}

enum InteractivePages { home, pvView, ecoView }

class _InteractivePageState extends State<InteractivePage>
    with TickerProviderStateMixin {
  bool _showcase = true;
  var activePage = InteractivePages.home;

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
    var theme = Theme.of(context);
    Widget page;
    AppBar appBar;

    switch (activePage) {
      case InteractivePages.home:
        page = _buildHome();
        appBar = CreateAppBar(theme, "Interactive");
        break;
      case InteractivePages.pvView:
        page = _buildPvView();
        appBar = _buildPvBar(theme);
        break;
      case InteractivePages.ecoView:
        page = _buildEco();
        appBar = CreateAppBar(
            theme,
            "Interactive",
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => setPage(0),
            ));
        break;
      default:
        page = Text("wtf");
        appBar = CreateAppBar(theme, "Interactive");
        break;
    }

    return Scaffold(
      appBar: appBar,
      body: SafeArea(child: page),
      bottomNavigationBar: CreateNavBar(theme, 1, context),
    );
  }

  Widget _buildHome() {
    return Center(
        child: Column(
      children: [
        OutlinedButton(
            onPressed: () => setPage(1), child: Text("Visualization")),
        OutlinedButton(
            onPressed: () => setPage(2), child: Text("Efficiency Estimation")),
        OutlinedButton(
            onPressed: () => setPage(3), child: Text("Economic Models"))
      ],
    ));
  }

  AppBar _buildPvBar(ThemeData theme) {
    final TabController tabController =
        TabController(length: 2, initialIndex: _showcase ? 0 : 1, vsync: this);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        print(tabController.index);
        toggleShowcase(tabController.index);
      }
    });

    return CreateAppBar(
        theme,
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
      page = _ModelViewer();
    } else {
      page = EnergyEst();
    }

    return page;
  }

  Widget _buildEco() {
    return Text("Eco");
  }

  Widget _ModelViewer() {
    return ModelViewer(
      src: 'http://192.168.50.28:8000/house.glb',
      alt: "A 3D model of a house",
      ar: false,
      autoRotate: false,
      cameraControls: true,
      maxCameraOrbit: "auto 90deg auto",
    );
  }

  Widget EnergyEst() {
    return Text("Est");
  }
}
