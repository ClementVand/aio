import 'package:aio/aio.dart';
import 'package:flutter/material.dart';

import '../../constants/routes.dart';

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({super.key});

  void _login(BuildContext context) {
    App().session.login("__token__", onLogin: () => context.go(Routes.home));
  }

  @override
  Widget build(BuildContext context) {
    return PagePlaceholder(
      label: "Authentication View",
      onButtonPressed: () => _login(context),
    );
  }
}
