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
    // Lista de tonos de azul
    final List<Color> colorList = [
      Colors.blue[900]!,
      Colors.blue[700]!,
      Colors.blue[500]!,
      Colors.blue[300]!,
      Colors.blue[200]!,
      Colors.blue[100]!,
    ];
    return Center(
      child: PieChart(
        dataMap: dataMap,
        chartType: ChartType.ring,
        ringStrokeWidth: 40,
        chartRadius: chartRadius,
        colorList: colorList,
        legendOptions: const LegendOptions(
          legendPosition: LegendPosition.left,
          showLegends: true,
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValuesInPercentage: false,
          showChartValues: true,
        ),
      ),
    );
  }
}
