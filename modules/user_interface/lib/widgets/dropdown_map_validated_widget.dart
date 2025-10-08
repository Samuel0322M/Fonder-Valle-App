import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:user_interface/resources/theme/app_colors.dart';

class DropdownMapValidatedFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? initialValue; // debe ser la KEY ("P", "F", "A")
  final String? value;        // también la KEY
  final String? hint;
  final Map<dynamic, String> itemsMap;
  final void Function(String?)? onChanged;
  final ValueNotifier<String?>? errorNotifier;

  const DropdownMapValidatedFieldWidget({
    super.key,
    this.controller,
    required this.labelText,
    this.initialValue,
    this.value,
    this.hint,
    required this.itemsMap,
    this.onChanged,
    this.errorNotifier,
  });

  @override
  State<DropdownMapValidatedFieldWidget> createState() =>
      _DropdownMapValidatedFieldWidgetState();
}

class _DropdownMapValidatedFieldWidgetState
    extends State<DropdownMapValidatedFieldWidget> {
  final BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10));
  late final TextEditingController _internalController;
  bool _isInternalController = false;

  Map<dynamic, String> _itemsMap = {};
  List<DropdownMenuItem<String>> _itemsDropdownMenuItem = [];

  /// 🔹 Valor seleccionado actual (siempre la KEY del mapa)
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController();
      _isInternalController = true;
    } else {
      _internalController = widget.controller!;
    }

    _updateItems(widget.itemsMap);
    _handleInitialValue();
  }

  void _handleInitialValue() {
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      if (_itemsMap.containsKey(widget.initialValue)) {
        _selectedValue = widget.initialValue;
        _internalController.text = widget.initialValue!; // guardamos KEY
      } else {
        _selectedValue = null;
        _internalController.text = '';
      }
    }
  }

  @override
  void didUpdateWidget(covariant DropdownMapValidatedFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.itemsMap.isEmpty) {
      _selectedValue = null;
      _internalController.text = '';
    }

    if (!mapEquals(oldWidget.itemsMap, widget.itemsMap)) {
      _updateItems(widget.itemsMap);
    }

    if (oldWidget.initialValue != widget.initialValue) {
      _handleInitialValue();
    }

    // 🔹 Sincronizar con valor externo
    if (oldWidget.value != widget.value) {
      setState(() {
        if (widget.value != null && _itemsMap.containsKey(widget.value)) {
          _selectedValue = widget.value;
          _internalController.text = widget.value!;
        } else {
          _selectedValue = null;
          _internalController.text = '';
        }
      });
    }
  }

  void _updateItems(Map<dynamic, String> newMap) {
    final cleanedMap = Map.fromEntries(
      newMap.entries.where((e) => e.value.trim().isNotEmpty),
    );

    setState(() {
      _itemsMap = cleanedMap;
      _itemsDropdownMenuItem = _itemsMap.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key.toString(), // KEY
          child: Text(entry.value), // LABEL
        );
      }).toList();

      // 🔹 limpiar si el valor ya no existe
      if (_selectedValue != null && !_itemsMap.containsKey(_selectedValue)) {
        _selectedValue = null;
        _internalController.text = '';
      }
    });
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(widget.labelText, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 10),
        ValueListenableBuilder<String?>(
          valueListenable: widget.errorNotifier ?? ValueNotifier(null),
          builder: (context, errorValue, _) {
            return DropdownButtonFormField<String>(
              isExpanded: true,
              value: _selectedValue, // 🔹 siempre usamos _selectedValue
              style: const TextStyle(color: AppColors.textSubtitle),
              icon: const SizedBox.shrink(),
              decoration: decorationDropdown(errorValue),
              items: _itemsDropdownMenuItem,
              onChanged: (String? newValue) {
                if (newValue != null && !_itemsMap.containsKey(newValue)) {
                  return;
                }
                setState(() {
                  _selectedValue = newValue;
                  _internalController.text = newValue ?? '';
                });
                widget.onChanged?.call(newValue);
              },
              validator: (value) {
                if (widget.errorNotifier?.value != null) {
                  return widget.errorNotifier?.value;
                }
                return null;
              },
            );
          },
        ),
      ],
    );
  }

  InputDecoration decorationDropdown(String? errorValue) {
    return InputDecoration(
      prefixIcon: const Icon(Icons.keyboard_arrow_down_outlined,
          color: AppColors.textBodyDark),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.buttonPositive),
        borderRadius: borderRadius,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.textFieldPositive),
        borderRadius: borderRadius,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.textFieldFocus),
        borderRadius: borderRadius,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: borderRadius,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: borderRadius,
      ),
      errorText: errorValue,
    );
  }
}
