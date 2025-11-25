import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:models/consulta_transunion_response.dart';
import 'package:models/prospect_response.dart';
import 'package:user_interface/blocs/home_bloc.dart';
import 'package:user_interface/pages/base_state.dart';
import 'package:user_interface/pages/create_codeudor_page.dart';
import 'package:user_interface/pages/create_prospect_page.dart';
import 'package:user_interface/pages/create_additional_info_page.dart';
import 'package:user_interface/pages/form_prospect_page.dart';
import 'package:user_interface/pages/tracking_prospect_page.dart';
import 'package:user_interface/providers/response_consulta_provider.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/resources/theme/appbar.dart';
import 'package:user_interface/utils/application.dart';
import 'package:user_interface/widgets/internet_status_indicator_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String route = '/home';

  static Widget buildPage(BuildContext context, RouteSettings settings) {
    return const HomePage();
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage, HomeBloc> {
  final responseConsultaProvider = ResponseConsultaProvider();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await responseConsultaProvider.inicializarBox();
      bloc.getAllProspect();
    });
  }

  @override
  void dispose() {
    responseConsultaProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          InternetStatusIndicatorWidget(
            stream: bloc.connectivityStream,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.primaryDark),
            onPressed: () => _onLogoutPressed(),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          StreamBuilder<String>(
              stream: bloc.nameAdvisorStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                    child: Text('Error al cargar prospectos.'),
                  );
                }

                final userName = snapshot.data!;
                return _buildHeader(userName, screenHeight);
              }),
          _buildActionCard(screenHeight),
          Positioned(
            top: screenHeight * 0.28,
            left: 0,
            right: 0,
            bottom: 0,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Prospectos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.33,
            left: 0,
            right: 0,
            bottom: 10,
            child: StreamBuilder<List<ProspectResponse>>(
              stream: bloc.prospectStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                    child: Text('Error al cargar prospectos.'),
                  );
                }

                final prospects = snapshot.data!;

                return RefreshIndicator(
                  onRefresh: () async {
                    bloc.getAllProspect();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _buildProspectsList(prospects),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  } // Fin del widget constructor

  void _onLogoutPressed() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que deseas salir de la aplicación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Application().logout();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String userName, double screenHeight) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: screenHeight * 0.24,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SvgPicture.asset(
              'assets/images/background_pattern.svg',
              fit: BoxFit.cover,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: screenHeight * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(double screenHeight) {
    return Positioned(
      top: screenHeight * 0.14,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () async {
          await Navigator.pushNamed(context, CreateProspectPage.route);
          bloc.getAllProspect();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _actionButton(icon: Icons.add, label: l10n.createProspect),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.green.shade700, size: 30),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildProspectsList(List<ProspectResponse> prospects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: prospects.map((prospect) => _prospectCard(prospect)).toList(),
    );
  }

  Widget _prospectCard(ProspectResponse prospectResponse) {
    return FutureBuilder(
        future: responseConsultaProvider
            .obtenerConsultaResponsePorCedula(prospectResponse.numberID),
        builder: (context, snapshot) {
          ConsultaTransunionResponse? consultaResponse;

          if (snapshot.hasData && snapshot.data != null) {
            consultaResponse = snapshot.data as ConsultaTransunionResponse;
          }

          Color cardColor = Colors.white;
          if (consultaResponse != null) {
            if (consultaResponse.decision == "Pass") {
              cardColor = Colors.green.shade300;
            } else if (consultaResponse.homologada != null &&
                consultaResponse.homologada!.isNotEmpty) {
              cardColor = Colors.red.shade600;
            }
          }

          return GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormProspectPage(
                    prospect: prospectResponse,
                  ),
                ),
              );
              bloc.getAllProspect(); // refresca lista al volver
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundColor: Color(0xFFEAEBFF),
                          child: Icon(Icons.person_outline, color: Colors.green),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          prospectResponse.nameProspect ?? '',
                          maxLines: 2,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black87
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.black87),
                  Column(
                    children: [
                      Text( 
                        "Monto solicitado: ${formatCurrency(double.parse(prospectResponse.valueRequested ?? "0"))}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 14),
                      _buildTrackingButton(prospectResponse, consultaResponse),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildTrackingButton(ProspectResponse prospectResponse, 
  ConsultaTransunionResponse? consultaResponse) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      
      const SizedBox(width: 10),
      if (consultaResponse?.codeudor == true) ...[
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              CreateCodeudorPage.route,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              "Codeudor",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.buttonTextPositive,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ),
      ],
      const SizedBox(width: 10),
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            TrackingProspectPage.route,
            arguments: TrackingProspectArgument(
              prospectResponse: prospectResponse,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            "Seguimiento",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.buttonTextPositive,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
      ), //Este boton redirecciona a info adicional
      const SizedBox(width: 10),
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AdditionalInfo(
                numberID: prospectResponse.numberID,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.buttonPositive,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            "Info Adicional",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.buttonTextPositive,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
      )
    ]);
  }

  String formatCurrency(num? value) {
    if (value == null) return '';
    final formatter = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
      decimalDigits: 0,
    );
    return '\$ ${formatter.format(value)}';
  }
}
