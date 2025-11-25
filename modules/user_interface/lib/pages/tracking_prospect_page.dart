import 'package:flutter/material.dart';
import 'package:models/prospect_response.dart';
import 'package:models/tracking_prospect_model.dart';
import 'package:user_interface/blocs/tracking_prospect_bloc.dart';
import 'package:user_interface/pages/base_state.dart';
import 'package:user_interface/pages/create_tracking_page.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/widgets/base_widget_page.dart';
import 'package:user_interface/widgets/internet_status_indicator_widget.dart';

class TrackingProspectArgument {
  final ProspectResponse prospectResponse;

  TrackingProspectArgument({required this.prospectResponse});
}

class TrackingProspectPage extends StatefulWidget {
  const TrackingProspectPage({super.key, required this.arguments});

  final TrackingProspectArgument arguments;

  static const String route = '/tracking-prospect';

  static Widget buildPage(BuildContext context, RouteSettings settings) {
    final arguments = settings.arguments as TrackingProspectArgument?;
    assert(arguments != null, '$TrackingProspectArgument can not be null');
    return TrackingProspectPage(arguments: arguments!);
  }

  @override
  State<TrackingProspectPage> createState() => _TrackingProspectPageState();
}

class _TrackingProspectPageState
    extends BaseState<TrackingProspectPage, TrackingProspectBloc> {
  late ProspectResponse prospect;

  @override
  void initState() {
    super.initState();
    prospect = widget.arguments.prospectResponse;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.getTrackingProspect(prospect.numberID);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prospectName = prospect.nameProspect ?? "Prospecto";

    final screenHeight = MediaQuery.of(context).size.height;

    return BaseWidgetPage(
      padding: EdgeInsets.zero,
      actionWidgetRight: InternetStatusIndicatorWidget(
        stream: bloc.connectivityStream,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: screenHeight * 0.20,
              width: double.infinity,
              child: _buildProfileCard(prospectName),
            ),
            const Divider(color: AppColors.divider),
            SizedBox(
              height: screenHeight * 0.60,
              child: StreamBuilder<List<TrackingProspectModel>>(
                stream: bloc.trackingProspectStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: Text('Error al cargar prospectos.'),
                    );
                  }

                  final trackingProspects = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: () async {
                      bloc.getTrackingProspect(prospect.numberID);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: _buildProspectsList(trackingProspects, prospectName),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProspectsList(
      List<TrackingProspectModel> prospects, String prospectName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...prospects.map((prospect) => _buildProspectCard(prospect)).toList(),
      ],
    );
  }

  Widget _buildProfileCard(String prospectName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          backgroundColor: Color(0xFFEAEBFF),
          child: Icon(
            Icons.person_outline,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          prospectName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          prospect.email ?? "",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          "N° de identificación: ${prospect.numberID}",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.primaryDark),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () async {
            await Navigator.pushNamed(
              context,
              CreateTrackingPage.route,
              arguments: CreateTrackingArgument(prospectResponse: prospect),
            );
            bloc.getTrackingProspect(prospect.numberID);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green,
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
              "Crear seguimiento",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.buttonTextPositive,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProspectCard(TrackingProspectModel prospect) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          InfoRow(
            icon: Icons.email_outlined,
            label: "Correo",
            value: prospect.email ?? "Sin correo",
          ),
          const SizedBox(height: 6),
          InfoRow(
            icon: Icons.calendar_today,
            label: "Fecha de llamada",
            value: prospect.callDate ?? "No disponible",
          ),
          const SizedBox(height: 6),
          InfoRow(
            icon: Icons.comment,
            label: "Comentario",
            value: prospect.comment ?? "-",
          ),
          const SizedBox(height: 6),
          InfoRow(
            icon: Icons.person,
            label: "Geoposicionamiento",
            value: prospect.geolocation ??
                widget.arguments.prospectResponse.geolocation ??
                "-",
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool boldLabel;
  final bool isEllipsis;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.boldLabel = true,
    this.isEllipsis = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 18),
        const SizedBox(width: 8),
        Text(
          "$label:",
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: boldLabel ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : "-",
            overflow: isEllipsis ? TextOverflow.ellipsis : TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
