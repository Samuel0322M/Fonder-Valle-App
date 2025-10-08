import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/prospect_response.dart';
import 'package:user_interface/blocs/create_tracking_bloc.dart';
import 'package:user_interface/pages/base_state.dart';
import 'package:user_interface/widgets/base_widget_page.dart';
import 'package:user_interface/widgets/dropdown_validated_field_widget.dart';
import 'package:user_interface/widgets/internet_status_indicator_widget.dart';
import 'package:user_interface/widgets/platform_positive_button.dart';
import 'package:user_interface/widgets/platform_text_field.dart';
import 'package:user_interface/widgets/text_field_with_label_widget.dart';

class CreateTrackingArgument {
  final ProspectResponse prospectResponse;

  CreateTrackingArgument({required this.prospectResponse});
}

class CreateTrackingPage extends StatefulWidget {
  const CreateTrackingPage({super.key, required this.arguments});

  final CreateTrackingArgument arguments;

  static const String route = '/create-tracking';

  static Widget buildPage(BuildContext context, RouteSettings settings) {
    final arguments = settings.arguments as CreateTrackingArgument?;
    assert(arguments != null, '$CreateTrackingArgument can not be null');
    return CreateTrackingPage(arguments: arguments!);
  }

  @override
  State<CreateTrackingPage> createState() => _CreateTrackingPageState();
}

class _CreateTrackingPageState
    extends BaseState<CreateTrackingPage, CreateTrackingBloc> {
  final FocusNode _focusKeyboardNode = FocusNode();
  final Map<String, FocusNode> _focusNodes = {
    'fecha': FocusNode(),
    'effective': FocusNode(),
    'idAsesor': FocusNode(),
    'comentario': FocusNode(),
  };

  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    var prospect = widget.arguments.prospectResponse;
    bloc.updateIDNumber(prospect.numberID);
    bloc.canGoBack.addListener(() {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _focusKeyboardNode.dispose();
    for (var node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidgetPage(
      actionWidgetRight: InternetStatusIndicatorWidget(
        stream: bloc.connectivityStream,
      ),
      body: KeyboardListener(
        focusNode: _focusKeyboardNode,
        onKeyEvent: _onKeyEvent,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(context),
              const SizedBox(height: 20),
              ..._buildFields(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: PlatformPositiveButton(
          onPressed: bloc.createTracking,
          title: l10n.createTracking,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      l10n.createTrackingTitle,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  List<Widget> _buildFields() {
    return [
      Text(l10n.date, style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 10),
      _buildDatePicker(),
      const SizedBox(height: 20),
      DropdownValidatedFieldWidget(
        labelText: l10n.effectiveLabel,
        initialValue: l10n.yes,
        documentTypes: [l10n.yes, l10n.no],
        onChanged: bloc.updateEffective,
      ),
      const SizedBox(height: 20),
      TextFieldWithLabelWidget(
        labelText: l10n.comment,
        maxLines: 2,
        hintText: l10n.hintTextComment,
        onChanged: bloc.updateComment,
        textInputAction: TextInputAction.done,
        focusNode: _focusNodes['comentario'],
      ),
      const SizedBox(height: 20),
      ElevatedButton.icon(
        icon: const Icon(Icons.attach_file),
        label: const Text("Adjuntar archivo"),
        onPressed: () {
          _pickFile(
            errorNotifier: bloc.fileErrorNotifier,
            onFileSelected: (bytes, fileName, base64) {
              bloc.updateAttachedFile(base64, fileName);
            },
          );
        },
      ),
      ValueListenableBuilder<String?>(
        valueListenable: bloc.fileErrorNotifier,
        builder: (context, error, _) {
          if (error == null) return const SizedBox.shrink();
          return Text(error, style: TextStyle(color: Colors.red));
        },
      ),
      ValueListenableBuilder<String?>(
        valueListenable: bloc.fileNameNotifier,
        builder: (context, fileName, _) {
          if (fileName == null || fileName.isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    fileName,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.red),
                  onPressed: () => bloc.clearAttachedFile(),
                  tooltip: 'Eliminar archivo',
                ),
              ],
            ),
          );
        },
      ),
    ];
  }

  Widget _buildDatePicker() {
    return ValueListenableBuilder<String>(
      valueListenable: bloc.formattedDateNotifier,
      builder: (context, formattedDate, _) {
        _dateController.text = formattedDate;
        return GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              bloc.updateDate(pickedDate);
            }
          },
          child: AbsorbPointer(
            child: PlatformTextField(
              hintText: l10n.selectDate,
              controller: _dateController, 
              readOnly: false,
            ),
          ),
        );
      },
    );
  }

  void _onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      bloc.createTracking();
    }
  }

  Future<void> _pickFile({
    required Function(Uint8List bytes, String fileName, String base64)
        onFileSelected,
    required ValueNotifier<String?> errorNotifier,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final bytes = result.files.single.bytes!;
      final base64String = base64Encode(bytes);
      final fileName = result.files.single.name;

      final sizeInMB = bytes.lengthInBytes / (1024 * 1024);
      if (sizeInMB > 3) {
        errorNotifier.value = "El archivo no debe pesar más de 3 MB.";
        return;
      }

      errorNotifier.value = null;
      onFileSelected(bytes, fileName, base64String);
    }
  }
}
