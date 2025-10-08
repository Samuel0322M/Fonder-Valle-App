import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatterCustom extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Elimina todos los caracteres no numéricos
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Formatea con separadores de miles
    if (newText.isNotEmpty) {
      final number = int.parse(newText);
      final formatter = NumberFormat('#,###', 'es_CO');
      newText = formatter.format(number);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}


