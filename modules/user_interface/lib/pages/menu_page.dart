import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user_interface/componets/botones_menu.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/resources/theme/appbar.dart';
import 'package:user_interface/utils/application.dart';


class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.allowedApps});

  static const String route = '/menu';

  static Widget buildPage(BuildContext context, RouteSettings settings) {
    final allowedApps = (settings.arguments as List<String>?) ?? [];
    return MenuPage(allowedApps: allowedApps);
  }

  final List<String> allowedApps;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.primaryDark),
            onPressed: () => _onLogoutPressed(context),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/background_pattern.svg',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(14.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BotonesMenu(allowedApps: widget.allowedApps),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onLogoutPressed(BuildContext context) {
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
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }
}
