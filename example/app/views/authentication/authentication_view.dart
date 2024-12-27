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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Authentication View"),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => _login(context),
          child: const Text("Login"),
        ),
      ],
    );
  }
}
