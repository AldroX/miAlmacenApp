# miAlmacén

Aplicación Flutter de gestión de inventario para pequeños comercios. Permite administrar productos, controlar stock y visualizar métricas del negocio.

## ✨ Funcionalidades

- **Dashboard** — tarjetas con total de inversión, ganancia estimada y gráfico de distribución por producto
- **CRUD de productos** — crear, editar y eliminar productos con nombre, precio de compra, precio de venta, cantidad e imagen
- **Control de stock** — aumentar o disminuir la cantidad en stock de cada producto
- **Gráfico de anillo** — visualización de la distribución del inventario por producto
- **Persistencia local** — los datos se almacenan con Hive en el dispositivo

## 🚀 Tecnologías

| Herramienta | Versión |
|-------------|---------|
| Flutter | 3.44.8 |
| Dart | 3.12.2 |
| Hive | 2.2.3 |
| Syncfusion Flutter Charts | 23.2.7 |
| Image Picker | 0.8.9 |

## 📱 Capturas

*(pendiente)*

## 🛠️ Requisitos

- Flutter SDK >=3.0.0
- Android SDK (minSdk 23)
- Dart SDK >=3.0.0

## 🔧 Instalación

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/mialmacen.git
cd mialmacen

# Instalar dependencias
flutter pub get

# Ejecutar en modo debug
flutter run

# Generar APK de debug
flutter build apk --debug
```

## 📁 Estructura del proyecto

```
lib/
├── core/
│   └── theme/
│       └── palette_colors.dart    # Paleta de colores
├── models/
│   ├── product.dart               # Modelo Product (Hive)
│   └── product_adapter.dart       # Adaptador Hive
├── pages/
│   ├── dashboard.dart             # Pantalla principal con métricas
│   ├── product_form_page.dart     # Formulario crear/editar producto
│   ├── products_page.dart         # Listado de productos
│   └── update_stock_page.dart     # Ajuste de stock
├── services/
│   └── product_service.dart       # Lógica de negocio con Hive
├── widgets/
│   ├── metrics_card.dart          # Tarjeta de métrica
│   ├── pie_chart.dart             # Gráfico de anillo
│   ├── product_dialog.dart        # Diálogo de detalle
│   ├── product_item.dart          # Ítem de producto
│   └── product_list.dart          # Lista de productos en dashboard
├── firebase_options.dart          # (no usado actualmente)
└── main.dart                      # Entry point + navegación
```

## 🧪 Tests

```bash
flutter test
```

> Actualmente el proyecto no cuenta con tests automatizados.

## 📄 Licencia

Este proyecto es de uso personal/comercial libre.
