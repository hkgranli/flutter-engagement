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

class EnergyEstimation extends StatefulWidget {
  const EnergyEstimation(
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
  State<EnergyEstimation> createState() => _EnergyEstimationState();
}

class _EnergyEstimationState extends State<EnergyEstimation> {
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

    switch (widget.solarType) {
      case SolarType.panel:
        panelEff = widget.activePanel.efficiency;
        break;
      case SolarType.tile:
        panelEff = widget.activeTile.efficiency;
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
          t += (side['sizes']![i] *
              side['rad']![i] *
              panelEff *
              (monthCoeff[x] / 12));
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

  bool _dropdownTechnicalInfoActive = false;

  void toggleDropdownTechnicalInfo() {
    setState(() {
      _dropdownTechnicalInfoActive = !_dropdownTechnicalInfoActive;
    });
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

  @override
  Widget build(BuildContext context) {
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
}
