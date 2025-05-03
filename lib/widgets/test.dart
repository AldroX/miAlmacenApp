import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class DashboardWidget extends StatelessWidget {
  /// Datos del gráfico de pastel con valores constantes
  final Map<String, double> dataMap;
  final String title;

  /// Constructor const para permitir instanciación en listas const
  const DashboardWidget({
    Key? key,
    // Datos por defecto como literal const
    this.dataMap = const {
      "Inversión": 5000,
      "Ganancia": 3000,
    },
    this.title = 'Dashboard',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildCard('Total de inversión', '\$5,000', Icons.trending_up,
                      Colors.blue),
                  const SizedBox(width: 16),
                  _buildCard('Total de ganancia', '\$3,000', Icons.attach_money,
                      Colors.green),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Distribución',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Center(
                child: PieChart(
                  dataMap: dataMap,
                  chartType: ChartType.disc,
                  chartRadius: MediaQuery.of(context).size.width / 2.5,
                  legendOptions: const LegendOptions(
                    legendPosition: LegendPosition.bottom,
                    showLegends: true,
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValuesInPercentage: true,
                    showChartValues: true,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(title,
                style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            const SizedBox(height: 4),
            Text(value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
