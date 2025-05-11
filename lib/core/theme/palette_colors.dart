// lib/core/theme/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Constructor privado para evitar instanciación
  AppColors._();

  // Colores principales
  static const Color azulMarino = Color(0xFF1D3557); // Primario
  static const Color verdeMenta = Color(0xFF3AAFA9); // Secundario
  static const Color azulClaro = Color(0xFFA8DADC); // Fondo
  static const Color grisOscuro = Color(0xFF343A40); // Texto
  static const Color verdeLima = Color(0xFFA8E6CF); // Accent

  // Variaciones de colores
  static const Color azulMarinoClaro = Color(0xFF2B4B6F);
  static const Color azulMarinoOscuro = Color(0xFF1A2F3C);
  static const Color verdeMentaClaro = Color(0xFF4ECDC4);
  static const Color verdeMentaOscuro = Color(0xFF2B8B8B);
  static const Color azulClaroClaro = Color(0xFFC4E0E5);
  static const Color azulClaroOscuro = Color(0xFF89C2D9);
  static const Color grisOscuroClaro = Color(0xFF52575C);
  static const Color grisOscuroOscuro = Color(0xFF242529);
  static const Color verdeLimaClaro = Color(0xFFB5E7D3);
  static const Color verdeLimaOscuro = Color(0xFF7ECBA2);

  // MaterialColor para usar con el tema
  static const MaterialColor azulMarinoSwatch = MaterialColor(
    _azulMarinoPrimaryValue,
    <int, Color>{
      50: azulMarinoClaro,
      100: azulMarino,
      200: azulMarino,
      300: azulMarino,
      400: azulMarino,
      500: azulMarino,
      600: azulMarinoOscuro,
      700: azulMarinoOscuro,
      800: azulMarinoOscuro,
      900: azulMarinoOscuro,
    },
  );

  static const int _azulMarinoPrimaryValue = 0xFF1D3557;
}
