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

  Widget _technicalInformation(List<FlSpot> estProd, double total) {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) =>
          toggleDropdownTechnicalInfo(),
      children: [
        ExpansionPanel(
            headerBuilder: (context, isExpanded) => ListTile(
                  title: Text(AppLocalizations.of(context)!.technical_info),
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
    List<FlSpot> estProd = EnergyContext.estimateEnergy(widget.solarType,
        widget.activePanel, widget.activeTile, widget.solarSides);
    double total = f1total(estProd);

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
    List<FlSpot> dataRaw = EnergyContext.estimateEnergy(widget.solarType,
        widget.activePanel, widget.activeTile, widget.solarSides);
    List<EnergyContext> dataMain =
        EnergyContext.energyContext(f1total(dataRaw), context);

    List<FlSpot> dataRawCompare = EnergyContext.estimateEnergy(
        widget.solarTypeCompare,
        widget.activePanelCompare,
        widget.activeTileCompare,
        widget.solarSides);
    List<EnergyContext> dataCompare =
        EnergyContext.energyContext(f1total(dataRawCompare), context);

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

  static List<FlSpot> estimateEnergy(SolarType solarType, Panel activePanel,
      Tile activeTile, List<int> solarSides) {
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

      for (int z = 0; z < sides.length; z++) {
        var side = sides[z];
        // total estimated production per side is
        // estimated incident radiation times size of the side
        // lastly _solarSides is 1 if the panel is selected and 0 if it is inactive
        //t += monthCoeff[x][sideEff[i]] * sideSize[i] * _solarSides[i];
        for (int i = 0; i < side['sizes']!.length; i++) {
          t += (side['sizes']![i] *
              side['rad']![i] *
              panelEff *
              solarSides[z] *
              (monthCoeff[x] / 6));
          //t += (side['sizes']![i] * side['rad']![i] * panelEff);
        }
      }

      estProd.add(FlSpot(x.toDouble(), (t).round().toDouble()));
    }

    return estProd;
  }
}
