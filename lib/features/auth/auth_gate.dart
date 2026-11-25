import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.auth, required this.onToggleTheme});

  final AuthService auth;
  final ValueChanged<Brightness> onToggleTheme;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Stream<String?> _authState = widget.auth.authStateChanges();

  @override
  void didUpdateWidget(AuthGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.auth != widget.auth) {
      _authState = widget.auth.authStateChanges();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: _authState,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Checking session',
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Could not check your session.'),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          setState(
                            () => _authState = widget.auth.authStateChanges(),
                          );
                        },
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        final userId = snapshot.data;
        if (userId == null) return LoginScreen(auth: widget.auth);

        final reduceMotion = MediaQuery.disableAnimationsOf(context);
        return TweenAnimationBuilder<double>(
          key: ValueKey(userId),
          tween: Tween(begin: reduceMotion ? 1 : 0, end: 1),
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) =>
              Opacity(opacity: value, child: child),
          child: _SignedInNavigator(
            auth: widget.auth,
            onToggleTheme: widget.onToggleTheme,
          ),
        );
      },
    );
  }
}

class _SignedInNavigator extends StatefulWidget {
  const _SignedInNavigator({required this.auth, required this.onToggleTheme});

  final AuthService auth;
  final ValueChanged<Brightness> onToggleTheme;

  @override
  State<_SignedInNavigator> createState() => _SignedInNavigatorState();
}

class _SignedInNavigatorState extends State<_SignedInNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _heroController = MaterialApp.createMaterialHeroController();

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler<Object?>(
      onPopWithResult: (result) => _navigatorKey.currentState!.pop(result),
      child: HeroControllerScope(
        controller: _heroController,
        child: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (settings) => MaterialPageRoute<void>(
            settings: settings,
            builder: (context) => HomeScreen(
              auth: widget.auth,
              onToggleTheme: widget.onToggleTheme,
            ),
          ),
        ),
      ),
    );
  }
}
