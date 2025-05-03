import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProductPieChart extends StatelessWidget {
  final List<PieData> pieData;
  final String title;

  const ProductPieChart({
    super.key,
    required this.pieData,
    this.title = 'Productos por Categoría',
  });

  @override
  Widget build(BuildContext context) {
    return pieData.isEmpty
        ? const Center(child: Text('No hay datos disponibles'))
        : SfCircularChart(
            title: ChartTitle(text: title),
            legend: Legend(isVisible: true),
            series: <PieSeries<PieData, String>>[
              PieSeries<PieData, String>(
                explode: true,
                explodeIndex: 0,
                dataSource: pieData,
                xValueMapper: (PieData data, _) => data.xData,
                yValueMapper: (PieData data, _) => data.yData,
                dataLabelMapper: (PieData data, _) =>
                    '${data.xData}: ${data.yData} productos',
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                  labelIntersectAction: LabelIntersectAction.none,
                  connectorLineSettings: ConnectorLineSettings(
                    color: Colors.black,
                    width: 1,
                    length: '20%',
                  ),
                ),
              ),
            ],
          );
  }
}

class PieData {
  final String xData;
  final num yData;
  final String text;

  PieData(this.xData, this.yData, this.text);
}
