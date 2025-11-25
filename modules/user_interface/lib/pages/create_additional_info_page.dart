import 'package:flutter/material.dart';
import 'package:user_interface/componets/create_address_info.dart';
import 'package:user_interface/componets/create_labor_info.dart';
import 'package:user_interface/componets/create_order_info.dart';
import 'package:user_interface/componets/create_personal_information.dart';
import 'package:user_interface/componets/create_references.dart';
import 'package:user_interface/providers/info_addres_provider.dart';
import 'package:user_interface/providers/info_laboral_provider.dart';
import 'package:user_interface/providers/info_personal_provider.dart';
import 'package:user_interface/providers/info_referencias_provider.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/resources/theme/appbar.dart';

class AdditionalInfo extends StatefulWidget {
  const AdditionalInfo({super.key, required this.numberID});

  final String numberID;

  @override
  State<AdditionalInfo> createState() => _AdditionalInfoState();

  static Widget buildPage(BuildContext context, RouteSettings settings) {
    final args = settings.arguments as String;
    return AdditionalInfo(numberID: args);
  }

  static const String route = '/informacion-adicional';
}

class _AdditionalInfoState extends State<AdditionalInfo> {
  int currentPageIndex = 0;

  late InfoPersonalProvider personalProvider;
  late InfoAddresProvider addresProvider;
  late InfoLaboralProvider laborProvider;
  late InfoReferenciasProvider referencesProvider;

  @override
  void initState() {
    super.initState();
    personalProvider = InfoPersonalProvider();
    addresProvider = InfoAddresProvider();
    laborProvider = InfoLaboralProvider();
    referencesProvider = InfoReferenciasProvider();
    _loadSteps();
  }

  @override
  void dispose() {
    personalProvider.dispose();
    addresProvider.dispose();
    laborProvider.dispose();
    referencesProvider.dispose();
    super.dispose();
  }

  List<bool> stepsCompleted = [false, false, false, false];

  Future<void> _loadSteps() async {
    final steps = <bool>[false, false, false, false];

    

    await personalProvider.inicializarBox();
    final personal = await personalProvider.obtenerInfoPersonalPorCedula(widget.numberID);
    steps[0] = personal?.isComplete ?? false;

    await addresProvider.inicializarBox();
    final address = await addresProvider.obtenerInfoAddresPorCedula(widget.numberID);
    steps[1] = address?.isComplete ?? false;

    await laborProvider.inicializarBox();
    final laboral = await laborProvider.obtenerInfoLaboralPorCedula(widget.numberID);
    steps[2] = laboral?.isComplete ?? false;

    await referencesProvider.inicializarBox();
    final references = await referencesProvider.obtenerInfoReferenciasPorCedula(widget.numberID);
    steps[3] = references?.isComplete ?? false;

    setState(() {
      stepsCompleted = steps;
    });
  }

  void markStepCompleted(int index, bool isCompleted) {
    setState(() {
      stepsCompleted[index] = isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.iconDark,
            size: 20,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(0.9)), // 👈 limita el tamaño del texto
          child: NavigationBar(
            onDestinationSelected: (int index) {
              if (index == 4) {
                print("steps: $stepsCompleted");
                final allPrevsStepsCompleted = stepsCompleted.sublist(0, 4).every((step) => step);
                if (!allPrevsStepsCompleted) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Atención"),
                        content: const Text(
                            "Debes completar la información anterior para acceder a pedidos."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Aceptar"),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }
              }
              setState(() {
                currentPageIndex = index;
              });
            },
            indicatorColor: Colors.green,
            selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.person_2_outlined),
                label: 'Personal',
              ),
              NavigationDestination(
                icon: Icon(Icons.house_outlined),
                label: 'Domicilio',
              ),
              NavigationDestination(
                icon: Icon(Icons.work_outline),
                label: 'Laboral',
              ),
              NavigationDestination(
                icon: Icon(Icons.people_outlined),
                label: 'Referencias',
              ),
              NavigationDestination(
                icon: Icon(Icons.attach_money_outlined),
                label: 'Pedido',
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: <Widget>[
          /// Info Personal page
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: FormPersonalInformation(
                numberID: widget.numberID,
                onCompleted: (isCompleted) => markStepCompleted(0, isCompleted)),
          ),

          /// Direccion page
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: FormAddressInfo(
                numberID: widget.numberID,
                onCompleted: (isCompleted) => markStepCompleted(1, isCompleted)),
          ),

          /// Info laboral page
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: FormLaborInfo(
                numberID: widget.numberID,
                onCompleted: (isCompleted) => markStepCompleted(2, isCompleted)),
          ),

          /// Info referencias page
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: CreateReferences(
                numberID: widget.numberID,
                onCompleted: (isCompleted) => markStepCompleted(3, isCompleted)),
          ),
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: FormOrderInfo(
                numberID: widget.numberID,
                onCompleted: (isCompleted) => markStepCompleted(4, isCompleted)),
          ),
        ][currentPageIndex],
      ),
    );
  }
}
