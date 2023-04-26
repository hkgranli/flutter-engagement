import 'package:engagement/components.dart';
import 'package:engagement/interactive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class EnergyEstimation extends StatefulWidget {
  const EnergyEstimation(
      {super.key,
      required this.solarSides,
      required this.solarType,
      required this.activePanel,
      required this.activeTile,
      this.boolSlider = true,
      this.text = true});

  final List<int> solarSides;

  final SolarType solarType;

  final Panel activePanel;
  final Tile activeTile;

  final bool boolSlider;
  final bool text;

  @override
  State<EnergyEstimation> createState() => _EnergyEstimationState();
}

class _EnergyEstimationState extends State<EnergyEstimation> {
  bool _dropdownTechnicalInfoActive = false;

  void toggleDropdownTechnicalInfo() {
    setState(() {
      _dropdownTechnicalInfoActive = !_dropdownTechnicalInfoActive;
    });
  }

  Widget _technicalInformation(List<BarChartGroupData> estProd, double total) {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) =>
          toggleDropdownTechnicalInfo(),
      elevation: 4,
      children: [
        ExpansionPanel(
            headerBuilder: (context, isExpanded) => ListTile(
                  title: Text(AppLocalizations.of(context)!.technical_info),
                ),
            body: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.fiber_manual_record, color: Colors.orange),
                  Text(AppLocalizations.of(context)!.elec_roof),
                  Icon(Icons.fiber_manual_record, color: Colors.grey),
                  Text(AppLocalizations.of(context)!.elec_fasca),
                ],
              ),
              _efficiencyGraph(estProd, total)
            ]),
            isExpanded: _dropdownTechnicalInfoActive,
            canTapOnHeader: true),
      ],
    );
  }

  Widget _efficiencyGraph(List<BarChartGroupData> estProd, double total) {
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BarChart(BarChartData(
          barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                fitInsideHorizontally: true,
                tooltipBgColor: Theme.of(context).dialogBackgroundColor,
                fitInsideVertically: true,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  print(rod.color);
                  return BarTooltipItem(
                      "${rod.toY.toInt()} ${AppLocalizations.of(context)!.kwt}",
                      TextStyle(fontStyle: FontStyle.italic, color: rod.color));
                },
              )),
          barGroups: estProd,
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
              return false;
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

  List<Widget> _buildEnergyContext(double total) {
    List data = EnergyContext.energyContext(total, context);
    List<Widget> widgets = [];

    for (var d in data) {
      widgets.add(Row(
        children: [Icon(d.icon), widget.text ? Text(d.text) : Text(d.value)],
      ));
    }

    if (widget.boolSlider) {
      widgets.add(SizedBox(
        height: 10,
      ));
      widgets.add(SliderMoneySaved(total: total));
    }

    return widgets;

    /*
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
          widget.text
              ? Text("$hoursShower ${AppLocalizations.of(context)!.est_shower}")
              : Text(
                  "$hoursShower ${(AppLocalizations.of(context)!.hours.toLowerCase())}")
        ],
      ),
      Row(
        children: [
          Icon(Icons.car_crash),
          widget.text
              ? Text("$carCharges ${AppLocalizations.of(context)!.est_tesla}")
              : Text("$carCharges")
        ],
      ),
      Row(
        children: [
          Icon(Icons.local_pizza),
          widget.text
              ? Text(
                  "${(total ~/ energyPizza)} ${AppLocalizations.of(context)!.est_pizza}")
              : Text("${(total ~/ energyPizza)}")
        ],
      ),
      SizedBox(
        height: 10,
      ),
      widget.boolSlider ? SliderMoneySaved(total: total) : Container(),
    ];*/
  }

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> estProd = EnergyContext.estimateEnergy(
        widget.solarType,
        widget.activePanel,
        widget.activeTile,
        widget.solarSides);
    double total = barChartTotal(estProd);

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //Text(AppLocalizations.of(context)!.est_gen(AppLocalizations.of(context)!.kwt, total.toInt())),
              widget.boolSlider
                  ? Text(
                      AppLocalizations.of(context)!.est_usage,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              ..._buildEnergyContext(total),
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
        Row(
          children: [
            //Icon(Icons.payment),
            Text(AppLocalizations.of(context)!.est_value,
                style: TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
        Slider(
            value: _energyPrice,
            min: 0,
            max: 600,
            divisions: 600,
            label: "${_energyPrice.round()} øre",
            onChanged: (value) => setState(() {
                  print(value);
                  _energyPrice = value;
                })),
        RichText(
          text: TextSpan(style: DefaultTextStyle.of(context).style, children: [
            WidgetSpan(child: Icon(Icons.savings)),
            TextSpan(
                text:
                    "${formatter.format((widget.total * (_energyPrice / 100)).toInt())}kr ${AppLocalizations.of(context)!.est_value_gen("${_energyPrice.toInt()} øre / ${AppLocalizations.of(context)!.kwt}")}")
          ]),
        ),
      ],
    );
  }
}

class EfficiencyTableComparator extends StatefulWidget {
  const EfficiencyTableComparator({
    super.key,
    required this.solarSides,
    required this.solarType,
    required this.activePanel,
    required this.activeTile,
    required this.solarTypeCompare,
    required this.activePanelCompare,
    required this.activeTileCompare,
  });

  final List<int> solarSides;
  final SolarType solarType;
  final Panel activePanel;
  final Tile activeTile;

  final SolarType solarTypeCompare;
  final Panel activePanelCompare;
  final Tile activeTileCompare;

  @override
  State<EfficiencyTableComparator> createState() =>
      _EfficiencyTableComparatorState();
}

class _EfficiencyTableComparatorState extends State<EfficiencyTableComparator> {
  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> dataRaw = EnergyContext.estimateEnergy(
        widget.solarType,
        widget.activePanel,
        widget.activeTile,
        widget.solarSides);
    List<EnergyContext> dataMain =
        EnergyContext.energyContext(barChartTotal(dataRaw), context);

    List<BarChartGroupData> dataRawCompare = EnergyContext.estimateEnergy(
        widget.solarTypeCompare,
        widget.activePanelCompare,
        widget.activeTileCompare,
        widget.solarSides);
    List<EnergyContext> dataCompare =
        EnergyContext.energyContext(barChartTotal(dataRawCompare), context);

    List<List<Widget>> data = [];

    for (int i = 0; i < dataMain.length; i++) {
      Widget ic = Icon(dataMain[i].icon);
      Widget t1 = Text(dataMain[i].value);
      Widget t2 = Text(dataCompare[i].value);
      data.add([ic, t1, t2]);
    }

    Widget t =
        EngagementTable(titles: ['', getProd1(), getProd2()], data: data);

    return t;
  }

  String getProd1() {
    switch (widget.solarType) {
      case SolarType.panel:
        return widget.activePanel.name;
      case SolarType.tile:
        return widget.activeTile.name;
      default:
        return "";
    }
  }

  String getProd2() {
    switch (widget.solarTypeCompare) {
      case SolarType.panel:
        return widget.activePanelCompare.name;
      case SolarType.tile:
        return widget.activeTileCompare.name;
      default:
        return "";
    }
  }
}

class EnergyContext {
  final IconData icon;
  final String text;
  final String value;

  const EnergyContext(this.icon, this.text, this.value);

  static List<EnergyContext> energyContext(double total, BuildContext context) {
    const double showerHourCost = 8.5;
    int hoursShower = total ~/ showerHourCost;

    double carBatterySize = 57.5;
    int carCharges = total ~/ carBatterySize;

    double energyPizza = 0.93;

    NumberFormat formatter = NumberFormat.decimalPattern('no');

    return [
      EnergyContext(
          Icons.bolt,
          "${formatter.format(total)} ${AppLocalizations.of(context)!.kwt}",
          "${formatter.format(total)} ${AppLocalizations.of(context)!.kwt}"),
      EnergyContext(
          Icons.shower,
          "$hoursShower ${AppLocalizations.of(context)!.est_shower}",
          "$hoursShower ${(AppLocalizations.of(context)!.hours.toLowerCase())}"),
      EnergyContext(
          Icons.car_repair,
          "$carCharges ${AppLocalizations.of(context)!.est_tesla}",
          "$carCharges"),
      EnergyContext(
          Icons.local_pizza,
          "${(total ~/ energyPizza)} ${AppLocalizations.of(context)!.est_pizza}",
          "${(total ~/ energyPizza)}"),
    ];
  }

  static List<BarChartGroupData> estimateEnergy(SolarType solarType,
      Panel activePanel, Tile activeTile, List<int> solarSides) {
    List<BarChartGroupData> estProd = [];

    double panelEff;

    switch (solarType) {
      case SolarType.panel:
        panelEff = activePanel.efficiency;
        break;
      case SolarType.tile:
        panelEff = activeTile.efficiency;
        break;
      default:
        panelEff = 0;
    }

    // north, south, east, west
    // which table coeff should be used per side
    // in m^2
    //List<List<double> sideSize = [72, 87, 38, 38];

    var roofSidesMonthly = Constants.rOOFSIDESMONTLY;
    var fascadesSidesMonthly = Constants.fASCADESIDESMONTLY;

    // loop all months of the year

    for (int x = 0; x < roofSidesMonthly.length; x++) {
      double roofTotal = 0;
      double fascadeTotal = 0;

      // loop for every side of the house

      List<num> monthRoof = roofSidesMonthly[x];
      List<num> monthFascade = fascadesSidesMonthly[x];

      for (int z = 0; z < monthRoof.length; z++) {
        // total estimated production per side is
        // estimated incident radiation times size of the side
        // lastly _solarSides is 1 if the panel is selected and 0 if it is inactive
        roofTotal += monthRoof[z] * solarSides[z] * panelEff;
        fascadeTotal += monthFascade[z] * solarSides[z] * panelEff;
      }

      BarChartGroupData b =
          BarChartGroupData(x: x, groupVertically: true, barRods: [
        BarChartRodData(
            toY: roofTotal, fromY: 0, width: 5, color: Colors.orange),
        BarChartRodData(
            toY: roofTotal + fascadeTotal,
            fromY: roofTotal,
            width: 5,
            color: Colors.grey),
      ]);

      estProd.add(b);

      //estProd.add(FlSpot(x.toDouble(), (total).round().toDouble()));
    }

    return estProd;
  }
}

class Constants {
  static final rOOFSIDESMONTLY = [
    [159.2, 637.6, 70.6, 357.6],
    [510.9, 1749.3, 228.2, 965.3],
    [1582.2, 5230.1, 772.3, 2392],
    [3402.2, 7964.9, 1669.1, 3518.6],
    [5307.3, 10184.1, 2639.2, 4328.1],
    [6322.6, 10653.8, 3070.1, 4530.3],
    [5382.8, 9245.8, 2618.5, 3949.1],
    [3556.9, 8030.9, 1769.9, 3454.5],
    [1739.5, 5173.4, 880.1, 2273.7],
    [698.2, 2821.4, 311, 1500.1],
    [217.5, 640.7, 96, 371.7],
    [66.3, 200.1, 28.6, 104.1]
  ];

  static final fASCADESIDESMONTLY = [
    [69.1, 212, 34, 325.9],
    [211.6, 727.2, 108.3, 1184.2],
    [672.6, 2144.2, 345.4, 3288.5],
    [1535.2, 3483.5, 688.9, 4289.2],
    [2304.6, 4844.8, 1078.3, 4679.8],
    [2538.7, 5103.1, 1322.3, 4589.2],
    [2302.6, 4469.2, 1087.4, 4104.4],
    [1583.2, 3762.8, 701.7, 3961.8],
    [769.1, 2179.8, 381.3, 2966.6],
    [304, 1230.7, 143.7, 2106],
    [93.8, 265.3, 46.8, 403.6],
    [28.4, 58.1, 14.1, 85.2],
  ];
}
