import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_interface/blocs/login_bloc.dart';
import 'package:user_interface/pages/base_state.dart';
import 'package:user_interface/pages/menu_page.dart';
import 'package:user_interface/utils/application.dart';
import 'package:user_interface/widgets/base_widget_page.dart';
import 'package:user_interface/widgets/platform_positive_button.dart';
import 'package:user_interface/widgets/text_field_with_label_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String route = '/login';

  static Widget buildPage(BuildContext context, RouteSettings settings) {
    return const LoginPage();
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage, LoginBloc> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusKeyboardNode = FocusNode();

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listenLoginStream();
  }

  @override
  void dispose() {
    _focusKeyboardNode.dispose();
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool?>(
      stream: bloc.circularProgressIndicatorStream,
      builder: (context, snapshot) {
        final isLoading = snapshot.data ?? false;

        return Stack(
          children: [
            BaseWidgetPage(
              showNavigationBack: false,
              padding: const EdgeInsets.only(bottom: 20),
              body: KeyboardListener(
                focusNode: _focusKeyboardNode,
                onKeyEvent: _onKeyEvent,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.login,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextFieldWithLabelWidget(
                        labelText: l10n.user,
                        controller: _userController,
                        hintText: l10n.hintTextEmail,
                        textInputAction: TextInputAction.next,
                        onChanged: bloc.updateUser,
                        errorNotifier: bloc.userError,
                      ),
                      const SizedBox(height: 20),
                      TextFieldWithLabelWidget(
                        labelText: l10n.password,
                        controller: _passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onChanged: bloc.updatePassword,
                        errorNotifier: bloc.passwordError,
                      ),
                    ],
                  ),
                ),
              ),
              footer: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: MediaQuery.of(context).size.height * 0.06,
                ),
                child: PlatformPositiveButton(
                  onPressed: _validateAndLogin,
                  title: l10n.login,
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }

  void _onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      _validateAndLogin();
    }
  }

  void _validateAndLogin() {
    bloc.updateUser(_userController.text);
    bloc.updatePassword(_passwordController.text);

    final isValid =
        bloc.userError.value == null && bloc.passwordError.value == null;

    if (isValid) {
      bloc.login(
          _userController.text.trim(), _passwordController.text.trim());
    }
  }

  void _listenLoginStream() {
    bloc.authenticationValueStream.listen((isAuthenticated) {
      if (isAuthenticated == true) {
        final authData = Application().authenticationData;

        // Extraés los nombres de app con acceso permitido
        final allowedApps = authData.permisos
            .where((p) => p.canAccess)
            .map((p) => p.appName)
            .toList();

        Navigator.pushReplacementNamed(
          context,
          MenuPage.route,
          arguments: allowedApps, // List<String>
        );
      }
    });
  }
}
