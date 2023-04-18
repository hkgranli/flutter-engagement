import 'package:engagement/components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart' show ModelViewer;
import 'package:engagement/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_compare_slider/image_compare_slider.dart';

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
          child: Column(
              children: [ZoomableImage(path: 'assets/images/potential.png')]),
        ),
      );
}
