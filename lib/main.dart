import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/product.dart';
import 'models/product_adapter.dart';
import 'services/product_service.dart';
import 'pages/dashboard.dart';
import 'pages/products_page.dart';
import 'widgets/test.dart';
import 'core/theme/palette_colors.dart';

const Color kActiveColor = Color.fromRGBO(44, 98, 255, 1.0);
const Color kInactiveColor = Color(0xFF95B1EE);

const String homeIcon = '''
    <svg width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-home">
    <path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M5 12l-2 0l9 -9l9 9l-2 0" />
    <path d="M5 12v7a2 2 0 0 0 2 2h10a2 2 0 0 0 2 -2v-7" />
    <path d="M9 21v-6a2 2 0 0 1 2 -2h2a2 2 0 0 1 2 2v6" /></svg>
    ''';

const String listIcon = '''
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
  <path d="M13 5h8" />
  <path d="M13 9h5" />
  <path d="M13 15h8" />
  <path d="M13 19h5" />
  <path d="M3 4m0 1a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v4a1 1 0 0 1 -1 1h-4a1 1 0 0 1 -1 -1z" />
  <path d="M3 14m0 1a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v4a1 1 0 0 1 -1 1h-4a1 1 0 0 1 -1 -1z" />
  </svg>
  ''';

const String settingsIcon = '''
    <svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="2"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-settings-check">
    <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
    <path d="M11.445 20.913a1.665 1.665 0 0 1 -1.12 -1.23a1.724 1.724 0 0 0 -2.573 -1.066c-1.543 .94 -3.31 -.826 -2.37 -2.37a1.724 1.724 0 0 0 -1.065 -2.572c-1.756 -.426 -1.756 -2.924 0 -3.35a1.724 1.724 0 0 0 1.066 -2.573c-.94 -1.543 .826 -3.31 2.37 -2.37c1 .608 2.296 .07 2.572 -1.065c.426 -1.756 2.924 -1.756 3.35 0a1.724 1.724 0 0 0 2.573 1.066c1.543 -.94 3.31 .826 2.37 2.37a1.724 1.724 0 0 0 1.065 2.572c1.31 .318 1.643 1.79 .997 2.694" /><path d="M15 19l2 2l4 -4" />
    <path d="M9 12a3 3 0 1 0 6 0a3 3 0 0 0 -6 0" />
    </svg>
    ''';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductAdapter());

    try {
      await Hive.openBox<Product>(ProductService.boxName);
    } catch (_) {
      await Hive.deleteBoxFromDisk(ProductService.boxName);
      await Hive.openBox<Product>(ProductService.boxName);
    }
  } catch (e) {
    // Manejo de error
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
  final List<Widget> pages = const [
    DashboardPage(),
    ProductsPage(),
    ComplateProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<String> icons = [
    homeIcon,
    listIcon,
    settingsIcon,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.azulMarinoOscuro,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'MiAlmacen',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          )),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: icons
            .map((svg) => BottomNavigationBarItem(
                  icon: SvgPicture.string(
                    svg,
                    colorFilter: ColorFilter.mode(
                      icons.indexOf(svg) == selectedIndex
                          ? kActiveColor
                          : kInactiveColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: '',
                ))
            .toList(),
      ),
    );
  }
}
