import 'package:flutter/material.dart';

@immutable
class AppColors {
  const AppColors._();

  // Paleta de colores principal (Naranja de la interfaz)
  static const Map<int, Color> primary = {
    50: Color.fromRGBO(255, 138, 61, .1),
    100: Color.fromRGBO(255, 138, 61, .2),
    200: Color.fromRGBO(255, 138, 61, .3),
    300: Color.fromRGBO(255, 138, 61, .4),
    400: Color.fromRGBO(255, 138, 61, .5),
    500: Color.fromRGBO(255, 138, 61, .6),
    600: Color.fromRGBO(255, 138, 61, .7),
    700: Color.fromRGBO(255, 138, 61, .8),
    800: Color.fromRGBO(255, 138, 61, .9),
    900: Color.fromRGBO(255, 138, 61, 1),
  };

  static MaterialColor primarySwatch = const MaterialColor(0xFF2720A5, primary);

  // Colores principales
  static const Color primaryDark = Color(0xFF2720A5);
  //static const Color primaryDark = Color(0xFF22CAD6);
  static const Color secondaryColor = Color(0xFF22CAD6);
  //static const Color secondaryColor = Color(0xFF2720A5);
  static const Color backgroundLight = Colors.white;
  static const Color backgroundDark = Color(0xFFF5F5F5);

  // Textos
  static const Color textTitleLight = Color(0xFFFFFFFF);
  static const Color textTitleDark = Color(0xFF222222);
  static const Color textBodyLight = Color(0xFFFFFFFF);
  static const Color textBodyDark = Color(0xFF4A4A4A);
  static const Color textSubtitle = Color(0xFF8E8E93);

  // Iconos
  static const Color iconLight = Color(0xFF248081);
  static const Color iconDark = Color(0xFF8E8E93);
  static const Color iconDisabled = Color(0x3E8E8E93);

  // Estados de Prospectos
  static const Color approvedStatus = Color(0xFF31BDB6);
  static const Color pendingStatus = Color(0xFF2720A5);
  static const Color rejectedStatus = Color(0xFFFF3A30);

  // Botones
  static const Color buttonPositive = primaryDark;
  static const Color buttonTextPositive = Colors.white;
  static const Color buttonDisabled = Color(0xFFD2D2D2);

  // Text-field
  static const Color textFieldPositive = Color(0xFFB8B8B8);
  static const Color textFieldFocus = Color(0xFFA0A0A0);

  // Otros colores
  static const Color divider = Color(0xFFE0E0E0);
  static const Color listItemSelected = Color(0xFFF5F5F5);
  static const Color warningToast = Color(0xFFFDFDBC);
  static const Color errorToast = Color(0xFFFF3A30);
  static const Color defaultEditorTextColor = Color(0xFF212121);
  static const Color surfaceTintColorEditor = Colors.white;

  // Segmentos y Controles
  static const Color segmentedControlBorder = primaryDark;
  static const Color segmentedControlSelected = Colors.white;
  static const Color segmentedControlUnselected = primaryDark;

  // Indicadores
  static const Color dotIndicator = Color(0xFFC4C4C4);
  static const Color dotIndicatorSelected = Color(0xFF8E8E93);

  // Textos de Edición
  static const Color defaultStudentAnnotation = Colors.black;
  static const Color defaultTeacherAnnotation = Colors.red;
  static const Color defaultTeacherFeedbackAnnotation = Color(0xFF388E67);
  static const Color defaultCursor = Color(0xFF22CAD6);
}
