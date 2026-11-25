import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.auth});

  final AuthService auth;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _hidePassword = true;
  bool _signingIn = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_signingIn || !_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _signingIn = true;
      _error = null;
    });

    try {
      await widget.auth.signIn(
        email: _email.text.trim(),
        password: _password.text,
      );
      if (!mounted) return;
      TextInput.finishAutofillContext();
    } on AuthFailure catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Sign-in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _signingIn = false);
    }
  }

  void _clearError(String _) {
    if (_error != null) setState(() => _error = null);
  }

  ThemeData _formTheme(ThemeData theme) {
    final dark = theme.brightness == Brightness.dark;
    final accent = dark ? const Color(0xffc2b7ff) : const Color(0xff4e3ca5);
    final scheme = theme.colorScheme.copyWith(
      primary: accent,
      onPrimary: dark ? const Color(0xff1b1039) : Colors.white,
      onSurface: dark ? const Color(0xfff8f6ff) : const Color(0xff201a32),
      onSurfaceVariant: dark
          ? const Color(0xffb9b3cc)
          : const Color(0xff625a77),
    );
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: dark ? const Color(0xff3a354d) : const Color(0xffdfdaeb),
      ),
    );

    return theme.copyWith(
      colorScheme: scheme,
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        fillColor: dark ? const Color(0xff222033) : const Color(0xfff8f6fc),
        prefixIconColor: scheme.onSurfaceVariant,
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        floatingLabelStyle: TextStyle(color: accent),
        border: fieldBorder,
        enabledBorder: fieldBorder,
        focusedBorder: fieldBorder.copyWith(
          borderSide: BorderSide(color: accent, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(0, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildForm(ThemeData theme, {required bool wide}) {
    final colors = theme.colorScheme;
    final error = _error;

    return Theme(
      data: theme,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: wide ? 40 : 24,
          vertical: wide ? 36 : 28,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: AutofillGroup(
              onDisposeAction: AutofillContextAction.cancel,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        'Sign in',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: colors.onSurface,
                          fontSize: wide ? 40 : 34,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Open the member directory.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 26),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [
                        AutofillHints.username,
                        AutofillHints.email,
                      ],
                      autocorrect: false,
                      readOnly: _signingIn,
                      validator: validateEmail,
                      onChanged: _clearError,
                      onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _password,
                      focusNode: _passwordFocus,
                      obscureText: _hidePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      autocorrect: false,
                      enableSuggestions: false,
                      readOnly: _signingIn,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          tooltip: _hidePassword
                              ? 'Show password'
                              : 'Hide password',
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                          ),
                        ),
                      ),
                      validator: validatePassword,
                      onChanged: _clearError,
                      onFieldSubmitted: (_) => _signIn(),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 14),
                      Semantics(
                        liveRegion: true,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              error,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onErrorContainer,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    AppButton(
                      label: 'Sign in',
                      trailingIcon: Icons.arrow_forward_rounded,
                      loadingLabel: 'Signing in',
                      loading: _signingIn,
                      onPressed: _signIn,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formTheme = _formTheme(theme);
    final dark = theme.brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.75, -0.85),
            radius: 1.1,
            colors: dark
                ? const [Color(0xff252144), Color(0xff101019)]
                : const [Color(0xffeae4ff), Color(0xfff8f7fc)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 760;
              final form = _buildForm(formTheme, wide: wide);
              final artwork = _SignInArtwork(wide: wide);
              final radius = BorderRadius.circular(wide ? 30 : 24);

              return CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: wide ? 32 : 20,
                          vertical: 24,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: wide ? 1040 : 480,
                          ),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: reduceMotion ? 1 : 0, end: 1),
                            duration: reduceMotion
                                ? Duration.zero
                                : const Duration(milliseconds: 320),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, (1 - value) * 10),
                                child: child,
                              ),
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: radius,
                                boxShadow: [
                                  BoxShadow(
                                    color: dark
                                        ? const Color(0x66000000)
                                        : const Color(0x241d1040),
                                    blurRadius: 46,
                                    offset: const Offset(0, 20),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: dark
                                    ? const Color(0xff191827)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: dark
                                        ? const Color(0xff39324f)
                                        : const Color(0xffe3dced),
                                  ),
                                  borderRadius: radius,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: wide
                                    ? IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(flex: 11, child: artwork),
                                            Expanded(flex: 10, child: form),
                                          ],
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [artwork, form],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SignInArtwork extends StatelessWidget {
  const _SignInArtwork({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/branding/sign-in-artwork.webp',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            excludeFromSemantics: true,
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.35, 0.65, 1],
                colors: [
                  Colors.transparent,
                  Color(0x40080717),
                  Color(0xff080717),
                ],
              ),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: wide ? 490 : 226),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(wide ? 36 : 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text.rich(
                      const TextSpan(
                        text: 'NINE',
                        children: [
                          TextSpan(
                            text: '.',
                            style: TextStyle(color: Color(0xffc2b7ff)),
                          ),
                        ],
                      ),
                      style: AppTheme.wordmark.copyWith(
                        color: const Color(0xfffbf8ff),
                        fontSize: wide ? 88 : 59,
                        letterSpacing: wide ? -6 : -4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nine people. Nine identities.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xffded7f5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
