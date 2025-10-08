import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:user_interface/resources/theme/app_colors.dart';

class DropdownValidatedFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? initialValue;
  final String? value;
  final String? hint;
  final List<String> documentTypes;
  final void Function(String?)? onChanged;
  final ValueNotifier<String?>? errorNotifier;

  const DropdownValidatedFieldWidget({
    super.key,
    this.controller,
    required this.labelText,
    this.initialValue,
    this.value,
    this.hint,
    required this.documentTypes,
    this.onChanged,
    this.errorNotifier,
  });

  @override
  State<DropdownValidatedFieldWidget> createState() =>
      _DropdownValidatedFieldWidgetState();
}

class _DropdownValidatedFieldWidgetState
    extends State<DropdownValidatedFieldWidget> {
  final BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10));
  late final TextEditingController _internalController;
  bool _isInternalController = false;
  List<String> _items = [];
  List<DropdownMenuItem<String>> _itemsDropdownMenuItem = [];
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

    _updateItems(widget.documentTypes);
    _handleInitialValue();
  }

  void _handleInitialValue() {
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      if (_items.contains(widget.initialValue)) {
        _selectedValue = widget.initialValue;
        _internalController.text = widget.initialValue!;
      } else {
        _selectedValue = null;
        _internalController.text = '';
      }
    }
  }

  @override
  void didUpdateWidget(covariant DropdownValidatedFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!listEquals(oldWidget.documentTypes, widget.documentTypes)) {
      _updateItems(widget.documentTypes);
    }

    if (oldWidget.initialValue != widget.initialValue) {
      _handleInitialValue();
    }

      if (oldWidget.value != widget.value) {
    setState(() {
      _selectedValue = widget.value;
      _internalController.text = widget.value ?? '';
    });
  }
  }

  void _updateItems(List<String> newItems) {
    final uniqueItems = newItems
        .where((item) => item.trim().isNotEmpty)
        .map((e) => e.trim())
        .toSet()
        .toList()
      ..sort();

    setState(() {
      _items = uniqueItems;
      _itemsDropdownMenuItem = _items.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList();

      if (_selectedValue != null && !_items.contains(_selectedValue)) {
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
              value: widget.value ?? _selectedValue,
              style: const TextStyle(color: AppColors.textSubtitle),
              icon: const SizedBox.shrink(),
              decoration: decorationDropdown(errorValue),
              items: _itemsDropdownMenuItem,
              onChanged: (String? newValue) {
                if (newValue != null && !_items.contains(newValue)) {
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

  InputDecoration? decorationDropdown(String? errorValue) {
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
