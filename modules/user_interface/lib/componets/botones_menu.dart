// botones_menu.dart
import 'package:flutter/material.dart';
import 'package:user_interface/pages/home_page.dart';
import 'package:user_interface/pages/recibo_caja_page.dart';
import 'package:user_interface/resources/theme/app_colors.dart';

class BotonesMenu extends StatefulWidget {
  final List<String> allowedApps; // <- recibe los app_name autorizados

  const BotonesMenu({super.key, required this.allowedApps});

  @override
  State<BotonesMenu> createState() => _BotonesMenuState();
}

class MenuButton {
  final IconData icon;
  final String label;
  final String route;

  MenuButton({required this.icon, required this.label, required this.route});
}

class _BotonesMenuState extends State<BotonesMenu> {
  // definición estática de todos los posibles botones
  final Map<String, MenuButton> _allButtons = {
    'prospectos': MenuButton(
      icon: Icons.person_outline,
      label: 'Prospectos',
      route: HomePage.route,
    ),
    'recibo_caja': MenuButton(
      icon: Icons.attach_money,
      label: 'Recibos \nde Caja',
      route: RecibosDeCaja.route,
    ),
  };

  List<MenuButton> get _visibleButtons {
    return widget.allowedApps
        .where((app) => _allButtons.containsKey(app))
        .map((app) => _allButtons[app]!)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          '¿Qué haremos hoy?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ..._visibleButtons.map((b) => _buildMenuCard(
              icon: b.icon,
              label: b.label,
              onPressed: () {
                Navigator.pushNamed(context, b.route);
              },
            )),
      ],
    );
  }
}

Widget _buildMenuCard({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: double.infinity,
      height: 140,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon, size: 120.0, color: AppColors.buttonPositive),
          Text(
            label,
            style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
