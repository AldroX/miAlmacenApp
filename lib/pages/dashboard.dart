import 'package:flutter/material.dart';
import '../widgets/metrics_card.dart';
import '../widgets/product_list.dart';
import '../widgets/pie_chart.dart';
import '../services/product_service.dart';
import '../models/product.dart';
import '../core/theme/palette_colors.dart';

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
  Map<String, String> nameToId = {};
  bool isLoading = false;
  String? error;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      final productsList = await ProductService.getProducts();
      double invested = 0;
      double profit = 0;
      final byProduct = <String, int>{};
      final idMap = <String, String>{};

      for (var p in productsList) {
        invested += p.price * p.quantity;
        profit += (p.salePrice - p.price) * p.quantity;
        byProduct[p.name] = (byProduct[p.name] ?? 0) + p.quantity;
        idMap[p.name] = p.id;
      }

      setState(() {
        totalProducts = productsList.length;
        totalInvested = invested;
        totalProfit = profit;
        soldByProduct = Map<String, int>.from(byProduct);
        products = productsList;
        isLoading = false;
        nameToId = Map.from(idMap);
      });
    } catch (e) {
      setState(() {
        error = 'Error al cargar métricas: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.azulClaro,
      appBar: AppBar(
        backgroundColor: const Color(0xFF364c84),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Color(0xFFFFFDF5)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
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
                          onPressed: _loadData,
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
                              MetricsCard(
                                title: 'Total de inversión',
                                value: '\$${totalInvested.toStringAsFixed(2)}',
                                icon: Icons.trending_up,
                                color: Colors.blue,
                                background: AppColors.azulMarinoClaro,
                              ),
                              const SizedBox(width: 16),
                              MetricsCard(
                                title: 'Total de ganancia',
                                value: '\$${totalProfit.toStringAsFixed(2)}',
                                icon: Icons.attach_money,
                                color: Colors.green,
                                background: AppColors.verdeCute,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: const BorderSide(
                                  color: AppColors.customLightBlue),
                            ),
                            elevation: 8,
                            shadowColor: AppColors.azulMarino.withOpacity(0.2),
                            child: Padding(
                              padding: const EdgeInsets.all(26.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Distribución por Producto',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.azulMarino,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  PieChartWidget(
                                    dataMap: Map.fromEntries(
                                      soldByProduct.entries.map(
                                        (e) =>
                                            MapEntry(e.key, e.value.toDouble()),
                                      ),
                                    ),
                                    chartRadius:
                                        MediaQuery.of(context).size.width / 2.5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Stock por producto',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.azulMarino,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ProductList(
                            soldByProduct: soldByProduct,
                            nameToId: nameToId,
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
