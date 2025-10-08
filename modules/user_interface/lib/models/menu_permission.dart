import 'package:flutter/material.dart';

class Permission {
  final String appName;
  final bool canAccess;

  Permission({
    required this.appName,
    required this.canAccess,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      appName: json['app_name'] as String,
      canAccess: (json['priv_access'] as String?)?.toUpperCase() == 'Y',
    );
  }
}

class MenuButton {
  final IconData icon;
  final String label;
  final String route;

  MenuButton({
    required this.icon,
    required this.label,
    required this.route,
  });
}

// Lookup estático: mapeo de app_name a botón
final Map<String, MenuButton> permissionToButton = {
  'prospectos': MenuButton(
    icon: Icons.person_outline,
    label: 'Prospectos',
    route: '/prospectos', // o HomePage.route si lo tenés definido
  ),
  'recibo_caja': MenuButton(
    icon: Icons.attach_money,
    label: 'Recibos de Caja',
    route: '/recibos', // o RecibosDeCaja.route
  ),
};

List<MenuButton> buildMenuButtonsFromPermissions(List<dynamic> permisosRaw) {
  final permisos = permisosRaw
      .cast<Map<String, dynamic>>()
      .map((p) => Permission.fromJson(p))
      .where((perm) => perm.canAccess)
      .toList();

  final botones = <MenuButton>[];
  for (final perm in permisos) {
    final btn = permissionToButton[perm.appName];
    if (btn != null) botones.add(btn);
  }
  return botones;
}
