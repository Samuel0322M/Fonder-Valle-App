import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:user_interface/blocs/create_codeudor_bloc.dart';
import 'package:user_interface/pages/base_state.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/widgets/CurrencyInputFormatterCustom.dart';
import 'package:user_interface/widgets/base_widget_page.dart';
import 'package:user_interface/widgets/dropdown_map_validated_widget.dart';
import 'package:user_interface/widgets/dropdown_validated_field_widget.dart';
import 'package:user_interface/widgets/internet_status_indicator_widget.dart';
import 'package:user_interface/widgets/platform_positive_button.dart';
import 'package:user_interface/widgets/text_field_with_label_widget.dart';


class CreateCodeudorPage extends StatefulWidget {
  const CreateCodeudorPage({super.key});

  static const String route = '/create-codeudor';

  static Widget buildPage(BuildContext context, RouteSettings settings) {
    return const CreateCodeudorPage();
  }

  @override
  State<CreateCodeudorPage> createState() => _CreateCodeudorPageState();
}

class _CreateCodeudorPageState extends BaseState<CreateCodeudorPage, CreateProspectBloc> {
  final FocusNode _focusKeyboardNode = FocusNode();

  final Map<String, FocusNode> _focusNodes = {
    "tipoIdentificacion" : FocusNode(),
    'firstName': FocusNode(),
    'middleName': FocusNode(),
    'lastName': FocusNode(),
    'secondLastName': FocusNode(),
    'idNumber': FocusNode(),
    'phone': FocusNode(),
    'email': FocusNode(),
    'neighborhood': FocusNode(),
    'address': FocusNode(),
    'amount': FocusNode(),
    'comment': FocusNode(),
  };

  String? selectedDepartment;
  String? selectedCity;
  String? selectedSettlement;
  final TextEditingController _expeditionDateController = TextEditingController();

  @override
  void dispose() {
    _expeditionDateController.dispose();
    _focusKeyboardNode.dispose();
    for (var f in _focusNodes.values) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc.loadDepartmentsData();
     _focusNodes['idNumber']?.addListener(() {
  });
    bloc.canGoBack.addListener(() {
      Navigator.of(context).pop();
    });

    // 🚀 Escucha para navegar a la pantalla de TransUnion cuando se crea con éxito en API
    bloc.navigationTarget.addListener(() {
      final target = bloc.navigationTarget.value;
      if (target != null && target.isNotEmpty) {
        Navigator.of(context).pushNamed(target);
        // Limpia después de navegar para evitar re-disparos
        bloc.navigationTarget.value = null;
      }
    });
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
            children: <Widget>[
              _buildTitle(context),
              ..._buildTextFields(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: PlatformPositiveButton(
          onPressed: () {
            final isValid = bloc.validateForm();
            if (isValid) {
              bloc.createProspect(context);
            }
          },
          title: l10n.createProspect,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      l10n.addInfo,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  List<Widget> _buildTextFields() {
    return [
      DropdownMapValidatedFieldWidget(
        labelText: 'Tipo de Identificación',
        itemsMap: <String, String>{
          '1': 'Cédula de ciudadanía y NUIP',
          '2': 'Número de identificación tributaria',
          '3': 'Persona jurídica del extranjero',
          '4': 'Cédula de Extranjería',
          '5': 'Pasaporte',
          '6': 'Carné Diplomático',
          '7': 'Tarjeta de Identidad',
          '8': 'Documento Nacional de Identidad',
          '9': 'Permiso Especial de Permanencia',
        },
        errorNotifier: bloc.typeIdentificationError,
        onChanged: bloc.updateTypeIdentification,
      ),
        TextFieldWithLabelWidget(
        labelText: l10n.numberOfDocument,
        onlyNumbers: true,
        onChanged: bloc.updateIdNumber,
        errorNotifier: bloc.idNumberError,
        textInputAction: TextInputAction.next,
        focusNode: _focusNodes['idNumber'],
        onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['firstName']),
      ),
      TextFieldWithLabelWidget(
        labelText: l10n.firstName,
        hintText: l10n.hintTextName,
        onChanged: bloc.updateFirstName,
        errorNotifier: bloc.firstNameError,
        textInputAction: TextInputAction.next,
        focusNode: _focusNodes['firstName'],
        onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['middleName']),
      ),
      TextFieldWithLabelWidget(
        labelText: l10n.middleName,
        hintText: l10n.hintTextName,
        onChanged: bloc.updateMiddleName,
        focusNode: _focusNodes['middleName'],
        textInputAction: TextInputAction.next,
        onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['lastName']),
      ),
      TextFieldWithLabelWidget(
        labelText: l10n.lastName,
        hintText: l10n.hintTextLastName,
        onChanged: bloc.updateLastName,
        errorNotifier: bloc.lastNameError,
        textInputAction: TextInputAction.next,
        focusNode: _focusNodes['lastName'],
        onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['secondLastName']),
      ),
      TextFieldWithLabelWidget(
        labelText: l10n.secondLastName,
        hintText: l10n.hintTextLastName,
        onChanged: bloc.updateSecondLastName,
        focusNode: _focusNodes['secondLastName'],
        textInputAction: TextInputAction.next,
        onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['phone']),
      ),
      TextFieldWithLabelWidget(
        labelText: l10n.contactPhoneNumber,
        onlyNumbers: false,
        inputFormatters: [PhoneInputFormatter(defaultCountryCode: 'CO')],
        prefixIcon: const Icon(
          Icons.phone_outlined,
          color: AppColors.textBodyDark,
        ),
        onChanged: (value) {
          final cleanValue = value.replaceAll(RegExp(r'\D'), '');
          bloc.updatePhone(cleanValue);
        },
        errorNotifier: bloc.contactPhoneError,
        textInputAction: TextInputAction.next,
        focusNode: _focusNodes['phone'],
        //onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['expeditiondDate']),
      ),
      DropdownMapValidatedFieldWidget(
        labelText: 'Proceso Via WhatsApp',
        itemsMap: <String, String>{
          'Si': 'Si',
          'No': 'No',
        },
        errorNotifier: bloc.viaWhatsAppError,
        onChanged: bloc.updateviaWhatsApp,
      ),
      //iria el campo fecha expedicion
      const SizedBox(height: 10),
      Text("Fecha Expedicion"),
      const SizedBox(height: 8),
      ValueListenableBuilder<String?>(
          valueListenable: bloc.expeditionDateError,
          builder: (context, error, _) {
            return TextField(
              controller: _expeditionDateController,
              focusNode: _focusNodes['expeditiondDate'],
              onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['email']),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textFieldPositive),
                ),
                hintText: "DD/MM/YYYY",
                prefixIcon: const Icon(Icons.calendar_today, color: AppColors.textSubtitle),
                errorText: error,
              ),
              keyboardType: TextInputType.datetime,
              onChanged: (value) {
                if (value.isEmpty) {
                  bloc.updateExpeditionDate(null);
                  return;
                }
                try {
                  final parsed = DateFormat('dd/MM/yyyy').parseStrict(value);
                  bloc.updateExpeditionDate(parsed);
                } catch (_) {
                  bloc.expeditionDateError.value = "Formato inválido";
                }
              },
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  locale: const Locale('es', 'CO'),
                );
                if (picked != null) {
                  _expeditionDateController.text = DateFormat('dd/MM/yyyy').format(picked);
                  bloc.updateExpeditionDate(picked);
                }
              },
              onEditingComplete: () {
                if (_expeditionDateController.text.isEmpty) {
                  bloc.updateExpeditionDate(null);
                }
              },
            );
          }),
      TextFieldWithLabelWidget(
        labelText: l10n.email,
        hintText: l10n.hintTextEmail,
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: AppColors.textSubtitle,
        ),
        onChanged: bloc.updateEmail,
        errorNotifier: bloc.emailError,
        textInputAction: TextInputAction.next,
        focusNode: _focusNodes['email'],
        //onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['amountIncome']),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<List<String>>(
            valueListenable: bloc.departmentsList,
            builder: (_, departments, __) => DropdownValidatedFieldWidget(
              errorNotifier: bloc.departmentError,
              labelText: "Departamento",
              initialValue: bloc.selectedDepartmentNotifier.value,
              documentTypes: departments,
              onChanged: (value) {
                if (value != null) {
                  bloc.onSelectDepartment(value);
                }
              },
            ),
          ),
          ValueListenableBuilder<List<String>>(
            valueListenable: bloc.citiesList,
            builder: (_, cities, __) {
              if (bloc.selectedDepartmentNotifier.value == null) {
                return const SizedBox.shrink();
              }

              return DropdownValidatedFieldWidget(
                errorNotifier: bloc.cityError,
                labelText: "Municipio",
                initialValue: bloc.selectedCityNotifier.value,
                documentTypes: cities,
                onChanged: bloc.onSelectCity,
              );
            },
          ),
          ValueListenableBuilder<List<String>>(
            valueListenable: bloc.settlementsList,
            builder: (_, settlements, __) {
              if (bloc.selectedDepartmentNotifier.value == null ||
                  bloc.selectedCityNotifier.value == null) {
                return const SizedBox.shrink();
              }

              return DropdownValidatedFieldWidget(
                errorNotifier: bloc.settlementError,
                labelText: "Centro Poblado",
                initialValue: bloc.selectedSettlementNotifier.value,
                documentTypes: settlements,
                onChanged: bloc.onSelectSettlement,
              );
            },
          ),
        ],
      ),
      DropdownMapValidatedFieldWidget(
        labelText: 'Ocupación',
        itemsMap: <String, String>{
          'I': 'Independiente',
          'E': 'Empleado',
          'P': 'Pensionado',
        },
        errorNotifier: bloc.occupationError,
        onChanged: bloc.updateOccupation,
      ),
      //valor ingresos
      TextFieldWithLabelWidget(
        labelText: l10n.IncomeValue,
        onlyNumbers: false,
        prefixIcon: const Icon(
          Icons.attach_money_outlined,
          color: AppColors.textSubtitle,
        ),
        onChanged: (value) {
          final cleanValue = value.replaceAll('.', '');
          bloc.updateAmountIncome(cleanValue);
        },
        errorNotifier: bloc.amountIncomeError,
        textInputAction: TextInputAction.next,
        focusNode: _focusNodes['amountIncome'],
        onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['amountFinance']),
        inputFormatters: [
          CurrencyInputFormatterCustom(), // ya no usas el otro
        ],
      ),
      TextFieldWithLabelWidget(
        labelText: l10n.valueToBeFinanced,
        onlyNumbers: false,
        prefixIcon: const Icon(
          Icons.attach_money_outlined,
          color: AppColors.textSubtitle,
        ),
        onChanged: (value) {
          final cleanValue = value.replaceAll('.', '');
          bloc.updateAmountToFinance(cleanValue);
        },
        errorNotifier: bloc.amountToFinanceError,
        textInputAction: TextInputAction.next,
        focusNode: _focusNodes['amountFinance'],
        onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['comment']),
        inputFormatters: [
          CurrencyInputFormatterCustom(), // ya no usas el otro
        ],
      ),
      TextFieldWithLabelWidget(
        labelText: l10n.comment,
        maxLines: 2,
        hintText: l10n.hintTextComment,
        onChanged: bloc.updateComment,
        textInputAction: TextInputAction.done,
        focusNode: _focusNodes['comment'],
      ),

      const SizedBox(height: 20),
    ];
  }

/*

  buildCapturePhoto(
        title: "Subir foto cédula (frente)",
        onImageSelected: bloc.updateFrontIdPhoto,
        errorNotifier: bloc.frontPhotoError,
        previewNotifier: bloc.frontIdPhotoPreview,
      ),
      buildCapturePhoto(
        title: "Subir foto cédula (respaldo)",
        onImageSelected: bloc.updateBackIdPhoto,
        errorNotifier: bloc.backPhotoError,
        previewNotifier: bloc.backIdPhotoPreview,
      ),
      buildCapturePhoto(
        title: "Subir foto del rostro",
        onImageSelected: bloc.updateFacePhoto,
        errorNotifier: bloc.facePhotoError,
        previewNotifier: bloc.facePhotoPreview,
      ),

  Widget buildCapturePhoto({
    required String title,
    required Function(Uint8List) onImageSelected,
    required ValueNotifier<String?> errorNotifier,
    required ValueNotifier<Uint8List?> previewNotifier,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => _pickImage(
              onImageSelected: onImageSelected,
              errorNotifier: errorNotifier,
            ),
            icon: const Icon(Icons.camera_alt),
            label: Text(title),
          ),
        ),
        const SizedBox(height: 6),
        ValueListenableBuilder<String?>(
          valueListenable: errorNotifier,
          builder: (_, error, __) {
            if (error == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<Uint8List?>(
          valueListenable: previewNotifier,
          builder: (_, bytes, __) {
            if (bytes == null) return const SizedBox.shrink();
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    bytes,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => previewNotifier.value = null,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _pickImage({
    required Function(Uint8List) onImageSelected,
    required ValueNotifier<String?> errorNotifier,
  }) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        pickedFile.path,
        quality: 70,
        minWidth: 1080,
        minHeight: 1080,
        format: CompressFormat.jpeg,
      );

      if (compressedBytes == null) {
        errorNotifier.value = "No se pudo procesar la imagen.";
        return;
      }

      final sizeInMB = compressedBytes.length / (1024 * 1024);
      if (sizeInMB > 3) {
        errorNotifier.value =
            "La imagen sigue siendo muy pesada. Intenta tomarla con menor resolución.";
        return;
      }

      errorNotifier.value = null;
      onImageSelected(Uint8List.fromList(compressedBytes));
    }
  }
  */
  void _onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      bloc.createProspect(context);
    }
  }
}

