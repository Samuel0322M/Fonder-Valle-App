import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_interface/widgets/platform_text_field.dart';

class TextFieldWithLabelWidget extends StatelessWidget {
  const TextFieldWithLabelWidget({
    super.key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.maxLines,
    this.onlyNumbers = false,
    this.onChanged,
    this.errorNotifier,
    this.textInputAction,
    this.inputFormatters,
    this.onSubmitted,
    this.focusNode,
    this.obscureText = false,
    this.readOnly = false,  
    this.onTap,
    this.keyboardType,
  });

  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final int? maxLines;
  final bool onlyNumbers;
  final ValueChanged<String>? onChanged;
  final ValueNotifier<String?>? errorNotifier;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onSubmitted;
  final bool obscureText;
  final bool readOnly;
  final GestureTapCallback? onTap;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: errorNotifier ?? ValueNotifier(null),
      builder: (context, errorValue, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(labelText, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            PlatformTextField(
              controller: controller,
              hintText: hintText,
              prefixIcon: prefixIcon,
              maxLines: maxLines,
              onChanged: onChanged,
              onlyNumbers: onlyNumbers,
              errorText: errorValue,
              focusNode: focusNode,
              textInputAction: textInputAction,
              inputFormatters: inputFormatters,
              onSubmitted: onSubmitted,
              obscureText: obscureText,
              readOnly: readOnly, // <-- AGREGA ESTO
              onTap: onTap, // <-- Y ESTO
              keyboardType: keyboardType,
            ),
          ],
        );
      },
    );
  }
}
