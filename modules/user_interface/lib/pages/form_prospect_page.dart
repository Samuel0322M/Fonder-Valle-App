import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:models/prospect_response.dart';
import 'package:user_interface/blocs/form_prospect_bloc.dart';
import 'package:user_interface/l10n/app_localizations.dart';
import 'package:user_interface/pages/base_state.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/widgets/CurrencyInputFormatterCustom.dart';
import 'package:user_interface/widgets/base_widget_page.dart';
import 'package:user_interface/widgets/dropdown_map_validated_widget.dart';
import 'package:user_interface/widgets/dropdown_validated_field_widget.dart';
import 'package:user_interface/widgets/internet_status_indicator_widget.dart';
import 'package:user_interface/widgets/platform_positive_button.dart';
import 'package:user_interface/widgets/text_field_with_label_widget.dart';

class FormProspectPage extends StatefulWidget {
  final ProspectResponse? prospect;
  const FormProspectPage({super.key, this.prospect});

  static const String route = '/form-create-prospect';

  static Widget buildPage(BuildContext context, RouteSettings settings) {
    return const FormProspectPage();
  }

  @override
  State<FormProspectPage> createState() => _FormProspectPageState();
}

class _FormProspectPageState extends BaseState<FormProspectPage, FormProspectBloc> {
  final FocusNode _focusKeyboardNode = FocusNode();
  final bool _isReadOnly = true;

  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _secondLastNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _amountIncomeController = TextEditingController();
  final _amountFinanceController = TextEditingController();
  final _commentController = TextEditingController();
  final _viaWhatsAppController = TextEditingController();
  final _departmentController = TextEditingController();
  final _cityController = TextEditingController();
  final _settlementController = TextEditingController();

  final Map<String, FocusNode> _focusNodes = {
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

    bloc.loadDepartmentsData().then((_) {
      // 👇 Aquí ya tienes allDepartments lleno
      if (widget.prospect != null) {
        final departmentId = widget.prospect!.departmentId ?? '';
        final cityId = widget.prospect!.cityId ?? '';
        final settlementId = widget.prospect!.districtId ?? '';

        final deptName = bloc.getDepartmentNameByCode(departmentId);
        final cityName = bloc.getCityNameByCode(departmentId, cityId);
        final settlementName = bloc.getSettlementNameByCode(departmentId, cityId, settlementId);

        if (deptName != null) {
          bloc.onSelectDepartment(deptName);
        }
        if (cityName != null) {
          bloc.onSelectCity(cityName);
        }
        if (settlementName != null) {
          bloc.onSelectSettlement(settlementName);
        }

        // También actualizas los controladores de texto
        _departmentController.text = deptName ?? '';
        _cityController.text = cityName ?? '';
        _settlementController.text = settlementName ?? '';
      }
    });

    bloc.canGoBack.addListener(() {
      Navigator.of(context).pop();
    });
    bloc.navigationTarget.addListener(() {
      final target = bloc.navigationTarget.value;
      if (target != null && target.isNotEmpty) {
        Navigator.of(context).pushNamed(target);
        bloc.navigationTarget.value = null;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10nInstance = AppLocalizations.of(context)!;
    l10n = l10nInstance;
    bloc.setL10n(l10nInstance); // 👈 necesario

    if (widget.prospect != null) {
      String? departmentId = widget.prospect!.departmentId ?? '';
      String? cityId = widget.prospect!.cityId ?? '';
      String? settlementid = widget.prospect!.districtId ?? '';

      _firstNameController.text = widget.prospect!.name ?? '';
      _lastNameController.text = widget.prospect!.lastName ?? '';
      _secondLastNameController.text = widget.prospect!.secondLastName ?? '';
      _idNumberController.text = widget.prospect!.numberID;
      _phoneController.text = widget.prospect!.cellphone ?? '';
      _emailController.text = widget.prospect!.email ?? '';
      _amountIncomeController.text = widget.prospect!.incomeValue ?? '';
      _amountFinanceController.text = widget.prospect!.valueRequested ?? '';
      _commentController.text = widget.prospect!.comment ?? '';
      _viaWhatsAppController.text = widget.prospect!.viaWhatsapp ?? '';
      _departmentController.text = bloc.getDepartmentNameByCode(departmentId) ?? '';
      _cityController.text = bloc.getCityNameByCode(departmentId, cityId) ?? '';
      _settlementController.text =
          bloc.getSettlementNameByCode(departmentId, cityId, settlementid) ?? '';

      if (widget.prospect!.expeditionDate != null) {
        DateTime date = DateTime.parse(widget.prospect!.expeditionDate!);
        String formatted = DateFormat('dd/MM/yyyy').format(date);
        _expeditionDateController.text = formatted;
        bloc.updateExpeditionDate(date);
      } // Sincroniza también el bloc (para cuando envíes al endpoint)

      bloc.updateFirstName(_firstNameController.text);
      bloc.updateMiddleName(_middleNameController.text);
      bloc.updateLastName(_lastNameController.text);
      bloc.updateSecondLastName(_secondLastNameController.text);
      bloc.updateIdNumber(_idNumberController.text);
      bloc.updatePhone(_phoneController.text);
      bloc.updateEmail(_emailController.text);
      bloc.updateAmountIncome(_amountIncomeController.text);
      bloc.updateAmountToFinance(_amountFinanceController.text);
      bloc.updateComment(_commentController.text);
      bloc.updateTypeIdentification(widget.prospect!.tipoIdentificacion);
      bloc.updateOccupation(widget.prospect!.occupation);
      bloc.updateviaWhatsApp(_viaWhatsAppController.text);
    }
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
          child: IgnorePointer(
            ignoring: _isReadOnly,
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
          title: "Consultar Prospecto",
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
        initialValue: widget.prospect?.tipoIdentificacion,
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
        controller: _idNumberController,
        labelText: l10n.numberOfDocument,
        onlyNumbers: true,
        onChanged: bloc.updateIdNumber,
        errorNotifier: bloc.idNumberError,
        textInputAction: TextInputAction.next,
        focusNode: _focusNodes['idNumber'],
        onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['firstName']),
      ),
      TextFieldWithLabelWidget(
        controller: _firstNameController,
        labelText: l10n.firstName,
        hintText: l10n.hintTextName,
        onChanged: bloc.updateFirstName,
        errorNotifier: bloc.firstNameError,
        textInputAction: TextInputAction.next,
        focusNode: _focusNodes['firstName'],
        onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['lastName']),
      ),
      TextFieldWithLabelWidget(
        controller: _lastNameController,
        labelText: l10n.lastName,
        hintText: l10n.hintTextLastName,
        onChanged: bloc.updateLastName,
        errorNotifier: bloc.lastNameError,
        textInputAction: TextInputAction.next,
        focusNode: _focusNodes['lastName'],
        onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['secondLastName']),
      ),
      TextFieldWithLabelWidget(
        controller: _secondLastNameController,
        labelText: l10n.secondLastName,
        hintText: l10n.hintTextLastName,
        onChanged: bloc.updateSecondLastName,
        focusNode: _focusNodes['secondLastName'],
        textInputAction: TextInputAction.next,
        onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['phone']),
      ),
      TextFieldWithLabelWidget(
        controller: _phoneController,
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
        //onSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNodes['email']),
      ),
      DropdownMapValidatedFieldWidget(
        labelText: 'Proceso Via WhatsApp',
        initialValue: _viaWhatsAppController.text,
        itemsMap: <String, String>{
          'Si': 'Si',
          'No': 'No',
        },
        errorNotifier: bloc.viaWhatsApp,
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
              onTap: _isReadOnly
                  ? null
                  : () async {
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
        controller: _emailController,
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
          // Departamento
          ValueListenableBuilder<List<String>>(
            valueListenable: bloc.departmentsList,
            builder: (_, departments, __) {
              final deptoName = bloc.getDepartmentNameByCode(
                    widget.prospect?.departmentId ?? '',
                  ) ??
                  '';

              return DropdownValidatedFieldWidget(
                errorNotifier: bloc.departmentError,
                labelText: "Departamento",
                initialValue: deptoName.isNotEmpty ? deptoName : null,
                documentTypes: departments,
                onChanged: (value) {
                  if (value != null) {
                    bloc.onSelectDepartment(value);
                  }
                },
              );
            },
          ),

          // Municipio
          ValueListenableBuilder<List<String>>(
            valueListenable: bloc.citiesList,
            builder: (_, cities, __) {
              final cityName = bloc.getCityNameByCode(
                    widget.prospect?.departmentId ?? '',
                    widget.prospect?.cityId ?? '',
                  ) ??
                  '';

              return DropdownValidatedFieldWidget(
                errorNotifier: bloc.cityError,
                labelText: "Municipio",
                initialValue: cityName.isNotEmpty ? cityName : null,
                documentTypes: cities,
                onChanged: bloc.onSelectCity,
              );
            },
          ),

          // Centro poblado
          ValueListenableBuilder<List<String>>(
            valueListenable: bloc.settlementsList,
            builder: (_, settlements, __) {
              final settlementName = bloc.getSettlementNameByCode(
                    widget.prospect?.departmentId ?? '',
                    widget.prospect?.cityId ?? '',
                    widget.prospect?.districtId ?? '',
                  ) ??
                  '';

              return DropdownValidatedFieldWidget(
                errorNotifier: bloc.settlementError,
                labelText: "Centro Poblado",
                initialValue: settlementName.isNotEmpty ? settlementName : null,
                documentTypes: settlements,
                onChanged: bloc.onSelectSettlement,
              );
            },
          ),
        ],
      ),
      DropdownMapValidatedFieldWidget(
          labelText: 'Ocupación',
          initialValue: widget.prospect?.occupation,
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
        controller: _amountIncomeController,
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
        controller: _amountFinanceController,
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
        controller: _commentController,
        labelText: l10n.comment,
        maxLines: 2,
        hintText: l10n.hintTextComment,
        onChanged: bloc.updateComment,
        textInputAction: TextInputAction.done,
        focusNode: _focusNodes['comment'],
      ),
    ];
  }

  /*
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
