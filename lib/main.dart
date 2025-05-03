import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/product.dart';
import 'models/product_adapter.dart';
import 'services/product_service.dart';
import 'pages/dashboard.dart';
import 'pages/products_page.dart';
import 'pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de Hive con manejo de errores
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductAdapter());

    // Manejo de caja corrupta con logging
    try {
      await Hive.openBox<Product>(ProductService.boxName);
    } catch (e) {
      print('Error al abrir la caja: $e');
      await Hive.deleteBoxFromDisk(ProductService.boxName);
      await Hive.openBox<Product>(ProductService.boxName);
    }
  } catch (e) {
    print('Error en la inicialización de Hive: $e');
    // Aquí podrías mostrar un diálogo de error al usuario
  }

  runApp(const MyAlmacenApp());
}

class MyAlmacenApp extends StatelessWidget {
  const MyAlmacenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiAlmacén',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(44, 98, 255, 1.0),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0x00121212),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        cardTheme: CardTheme(
          color: const Color(0xffdce2f4),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
      ),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int selectedIndex = 0;
  static const List<Widget> pages = <Widget>[
    DashboardPage(),
    ProductsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            selectedIcon: Icon(Icons.list),
            label: 'Productos',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}
