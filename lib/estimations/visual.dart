import 'package:engagement/components.dart';
import 'package:engagement/interactive.dart';
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

class VisualizationPage extends StatelessWidget {
  const VisualizationPage(
      {super.key,
      required this.solarSides,
      required this.solarType,
      required this.activePanel,
      required this.activeTile});

  final List<int> solarSides;

  final SolarType solarType;

  final Panel activePanel;
  final Tile activeTile;

  @override
  Widget build(BuildContext context) {
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

    var c = "_${solarSides.join()}";
    //var c = "_1111";

    const extension = ".glb";

    // guard clauses for invalid config

    if (solarType == SolarType.none ||
        (solarType == SolarType.panel && activePanel == Panel.none) ||
        (solarType == SolarType.tile && activeTile == Tile.none) ||
        c == "_0000") {
      return "$base$extension";
    }

    String t;

    if (solarType == SolarType.panel) {
      t = "_panel_${activePanel.id}";
    } else {
      t = "_tile_${activeTile.id}";
      c = "_1111";
    }
    var url = "$base$t$c$extension";

    print("FETCHing $url");
    return url;
  }
}
