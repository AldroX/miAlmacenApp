import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> dataMap;
  final double chartRadius;

  const PieChartWidget({
    Key? key,
    required this.dataMap,
    required this.chartRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PieChart(
        dataMap: dataMap,
        chartType: ChartType.disc,
        chartRadius: chartRadius,
        legendOptions: const LegendOptions(
          legendPosition: LegendPosition.bottom,
          showLegends: true,
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValuesInPercentage: true,
          showChartValues: true,
        ),
      ),
    );
  }
}
