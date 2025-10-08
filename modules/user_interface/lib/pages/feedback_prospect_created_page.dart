import 'package:flutter/material.dart';
import 'package:user_interface/blocs/feedback_prospect_created_bloc.dart';
import 'package:user_interface/pages/base_state.dart';
import 'package:user_interface/widgets/base_widget_page.dart';
import 'package:user_interface/widgets/platform_positive_button.dart';

class FeedbackProspectCreatedPage extends StatefulWidget {
  const FeedbackProspectCreatedPage({super.key});

  @override
  State<FeedbackProspectCreatedPage> createState() =>
      _FeedbackProspectCreatedPageState();

  static const String route = '/feedback-prospect-created';

  static Widget buildPage(BuildContext context, RouteSettings settings) {
    return const FeedbackProspectCreatedPage();
  }
}

class _FeedbackProspectCreatedPageState extends BaseState<
    FeedbackProspectCreatedPage, FeedbackProspectCreatedBloc> {
  final FocusNode _focusKeyboardNode = FocusNode();

  @override
  void dispose() {
    _focusKeyboardNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidgetPage(
      padding: EdgeInsets.only(bottom: 20),
      body: Column(
        children: [],
      ),
      footer: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: PlatformPositiveButton(
          onPressed: () {},
          title: "Continuar",
        ),
      ),
    );
  }
}
