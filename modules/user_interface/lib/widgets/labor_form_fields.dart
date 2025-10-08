import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/widgets/CurrencyInputFormatterCustom.dart';
import 'package:user_interface/widgets/buildlabel.dart';
import 'package:user_interface/widgets/dropdown_map_validated_widget.dart';

class LaborFormFields extends StatefulWidget {
  final TextEditingController occupationController;
  final TextEditingController independentTypeController;
  final TextEditingController activityController;
  final TextEditingController companyNitController;
  final TextEditingController companyNameController;
  final TextEditingController bossNameController;
  final TextEditingController bossPhoneController;
  final TextEditingController entryDateController;
  final TextEditingController descriptionController;
  final TextEditingController incomeController;
  final TextEditingController expensesController;

  final ValueNotifier<String?> occupationError;
  final ValueNotifier<String?> independentTypeError;
  final ValueNotifier<String?> activityError;

  final VoidCallback onDateTap;

  const LaborFormFields({
    super.key,
    required this.occupationController,
    required this.independentTypeController,
    required this.activityController,
    required this.companyNitController,
    required this.companyNameController,
    required this.bossNameController,
    required this.bossPhoneController,
    required this.entryDateController,
    required this.descriptionController,
    required this.incomeController,
    required this.expensesController,
    required this.occupationError,
    required this.independentTypeError,
    required this.activityError,
    required this.onDateTap,
  });

  @override
  State<LaborFormFields> createState() => _LaborFormFieldsState();
}

class _LaborFormFieldsState extends State<LaborFormFields> {
  @override
  void initState() {
    super.initState();
    widget.occupationController.addListener(_updateState);
    widget.independentTypeController.addListener(_updateState);
  }

  void _updateState() => setState(() {});
  

  @override
  void dispose() {
    widget.occupationController.removeListener(_updateState);
    widget.independentTypeController.removeListener(_updateState);
    super.dispose();
  }

  bool get isIndependent => widget.occupationController.text == 'I';
  bool get isFormal => widget.independentTypeController.text == 'Formal';
  bool get isInformal => widget.independentTypeController.text == 'Informal';
  bool get isPensioner => widget.occupationController.text == 'P';
  bool get isEmployee => widget.occupationController.text == 'E';

  final Map<String, String> _independentTypes = {
    'Informal': 'Informal',
    'Formal': 'Formal',
  };

  final Map<String, String> _activities = {
    '1': 'Administrativos',
    '2': 'Servicios Salud',
    '3': 'Educación',
    '4': 'Construcción',
    '5': 'Servicio Transporte',
    '6': 'Seguridad y Vigilancia',
    '7': 'Servicios Generales',
    '8': 'Servicio Hotel/Restaurante',
    '9': 'Comercio y Ventas',
    '10': 'Minería y Petróleo',
    '11': 'Entretenimiento',
    '12': 'Sector Público',
    '13': 'Industria y Producción',
    '14': 'Tecnología / Informática',
    '15': 'Otro',
    '16': 'Agricultor/Productor',
    '17': 'Cría de animales',
    '18': 'Jornalero / Rural',
    '19': 'Servicios de Belleza',
    '20': 'Artesano/Confección',
    '21': 'Servicio Domésticos',
    '22': 'Alquiler de bienes',
    '23': 'Servicios Técnicos',
    '24': 'Profesional Independiente',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isIndependent)
          DropdownMapValidatedFieldWidget(
            controller: widget.independentTypeController,
            labelText: 'Tipo independiente',
            itemsMap: _independentTypes,
            errorNotifier: widget.independentTypeError,
            initialValue: widget.independentTypeController.text,
            onChanged: (_) {
              setState(() {
                widget.activityController.clear();
                widget.companyNitController.clear();
                widget.companyNameController.clear();
              });
              },
          ),
        if (isEmployee || isIndependent)
          DropdownMapValidatedFieldWidget(
            controller: widget.activityController,
            labelText: 'Actividad',
            itemsMap: _activities,
            errorNotifier: widget.activityError,
            initialValue: widget.activityController.text,
          ),
        if (isEmployee || (isIndependent && isFormal))
          Column(
            children: [
              const SizedBox(height: 16),
              LeftAlignedLabel('NIT Empresa'),
              const SizedBox(height: 6),
              TextFormField(
                controller: widget.companyNitController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textFieldPositive),
                  ),
                ),
                validator: (value) {
                  if (isEmployee || (isIndependent && isFormal)) {
                    return value == null || value.isEmpty ? 'Campo requerido' : null;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              LeftAlignedLabel('Nombre Empresa'),
              const SizedBox(height: 6),
              TextFormField(
                controller: widget.companyNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textFieldPositive),
                  ),
                ),
                validator: (value) {
                  if (isEmployee || (isIndependent && isFormal)) {
                    return value == null || value.isEmpty ? 'Campo requerido' : null;
                  }
                  return null;
                },
              ),
            ],
          ),
        if (isEmployee)
          Column(
            children: [
              const SizedBox(height: 16),
              LeftAlignedLabel('Nombre Jefe'),
              const SizedBox(height: 6),
              TextFormField(
                controller: widget.bossNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textFieldPositive),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              LeftAlignedLabel('Celular Jefe'),
              const SizedBox(height: 6),
              TextFormField(
                controller: widget.bossPhoneController,
                maxLength: 10,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textFieldPositive),
                  ),
                  counterText: '',
                ),
                validator: (value) { 
                  if(value == null || value.isEmpty){ 
                    return 'Campo requerido';
                    }
                    if (value.length < 10) {
                      return 'Debe tener 10 dígitos';
                      }
                      return null;
                }
              ),
            ],
          ),
        const SizedBox(height: 16),
        LeftAlignedLabel('Fecha de ingreso'),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.entryDateController,
          readOnly: true,
          onTap: widget.onDateTap,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textFieldPositive),
            ),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
        ),
        const SizedBox(height: 16),
        LeftAlignedLabel('Descripción'),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.descriptionController,
          maxLines: 2,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textFieldPositive),
            ),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
        ),
        const SizedBox(height: 16),
        LeftAlignedLabel('Ingresos'),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.incomeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textFieldPositive),
            ),
          ),
          inputFormatters: [
          CurrencyInputFormatterCustom(), // ya no usas el otro
        ],
          validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
        ),
        const SizedBox(height: 16),
        LeftAlignedLabel('Gastos'),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.expensesController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textFieldPositive),
            ),
          ),
          inputFormatters: [
          CurrencyInputFormatterCustom(), // ya no usas el otro
        ],
          validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
        ),
      ],
    );
  }
}
