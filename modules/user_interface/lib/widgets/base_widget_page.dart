import 'package:flutter/material.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/resources/theme/appbar.dart';
import 'package:user_interface/widgets/platform_icon_button.dart';

class BaseWidgetPage extends StatelessWidget {
  const BaseWidgetPage({
    super.key,
    required this.body,
    this.footer,
    this.actionWidgetRight,
    this.padding,
    this.showNavigationBack = true,
  });

  final Widget body;
  final Widget? footer;
  final Widget? actionWidgetRight;
  final EdgeInsets? padding;
  final bool showNavigationBack;

  @override
  Widget build(BuildContext context) {
    var mediaQueryHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBarWidget(),
      body: Padding(
        padding: padding ?? EdgeInsets.only(bottom: mediaQueryHeight * 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showNavigationBack)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PlatformIconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.iconDark,
                        size: 20,
                      ),
                    ),
                    if (actionWidgetRight != null) actionWidgetRight!,
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: body,
              ),
            ),
            footer ?? SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
