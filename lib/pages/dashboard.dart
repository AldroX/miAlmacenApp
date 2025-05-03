import 'package:flutter/material.dart' hide CarouselController;
import 'package:pie_chart/pie_chart.dart';
import '../services/product_service.dart';
import '../models/dashboard_metrics.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int totalProducts = 0;
  double totalInvested = 0;
  double totalProfit = 0;
  Map<String, int> soldByProduct = {};
  bool isLoading = false;
  String? error;
  late final List<DashboardMetrics> metrics;
  int currentPage = 0;
  Map<String, double> pieChartData = {};

  @override
  void initState() {
    super.initState();
    _calculateMetrics();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _calculateMetrics() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      final products = await ProductService.getProducts();
      double invested = 0;
      double profit = 0;
      final byProduct = <String, int>{};

      for (var p in products) {
        invested += p.price * p.quantity;
        profit += (p.salePrice - p.price) * p.quantity;
        byProduct[p.name] = (byProduct[p.name] ?? 0) + p.quantity;
      }

      setState(() {
        totalProducts = products.length;
        totalInvested = invested;
        totalProfit = profit;
        soldByProduct = Map<String, int>.from(byProduct);
        metrics = [
          DashboardMetrics(
            monto: invested,
            label: 'Total de Inversión',
          ),
          DashboardMetrics(
            monto: profit,
            label: 'Total de Ganancia',
          ),
        ];
        pieChartData = Map.fromEntries(byProduct.entries.map((e) {
          return MapEntry(e.key, e.value.toDouble());
        }));
      });
    } catch (e) {
      setState(() {
        error = 'Error al cargar métricas: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _calculateMetrics,
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _calculateMetrics,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              _buildCard(
                                'Total de inversión',
                                '\$${totalInvested.toStringAsFixed(2)}',
                                Icons.trending_up,
                                Colors.blue,
                              ),
                              const SizedBox(width: 16),
                              _buildCard(
                                'Total de ganancia',
                                '\$${totalProfit.toStringAsFixed(2)}',
                                Icons.attach_money,
                                Colors.green,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Distribución por Producto',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: PieChart(
                              dataMap: pieChartData,
                              chartType: ChartType.disc,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 2.5,
                              legendOptions: const LegendOptions(
                                legendPosition: LegendPosition.bottom,
                                showLegends: true,
                              ),
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true,
                                showChartValues: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Stock por producto',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: soldByProduct.length,
                            itemBuilder: (ctx, i) {
                              final entry = soldByProduct.entries.elementAt(i);
                              final colorScheme = Theme.of(ctx).colorScheme;
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.inventory_2,
                                    color: colorScheme.secondary,
                                  ),
                                  title: Text(entry.key),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        entry.value.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.visibility),
                                        onPressed: () {
                                          showDialog(
                                            context: ctx,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Detalles de ${entry.key}'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Cantidad en inventario: ${entry.value}',
                                                      style: TextStyle(
                                                        color:
                                                            colorScheme.primary,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      'Total de inversión: \$${totalInvested.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                        color:
                                                            colorScheme.primary,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      'Total de ganancia: \$${totalProfit.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                        color:
                                                            colorScheme.primary,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: const Text('Cerrar'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        color: colorScheme.secondary,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
