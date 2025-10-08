import 'package:flutter/material.dart';
import 'package:user_interface/resources/assets.dart';
import 'package:user_interface/resources/values.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final List<Widget>? actions;

  const AppBarWidget({super.key, this.actions}) : preferredSize = const Size.fromHeight(85.0);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  final Size preferredSize;
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 90.0,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            Assets.logoAppDark,
            fit: BoxFit.contain,
            height: Values.heightLogoApp,
          ),
        ],
      ),
      actions: widget.actions,
      centerTitle: true,
    );
  }
}
