import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../theme/bb_colors.dart';
import '../../theme/bb_text.dart';
import '../../widgets/brand_button.dart';

/// Create an account or sign in. Shown after onboarding and after sign-out.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  late bool _signUp = !context.read<AuthService>().hasAccounts;
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final auth = context.read<AuthService>();
    final error = _signUp
        ? await auth.signUp(
            name: _name.text,
            email: _email.text,
            password: _password.text,
          )
        : await auth.signIn(email: _email.text, password: _password.text);
    // On success the app root swaps this screen out.
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final muted = BBColors.textMuted(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(BBColors.padXL),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _signUp ? 'Create your account' : 'Welcome back',
                        style: BBTextResponsive.displayLarge(
                          context,
                          size: 30,
                          weight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: BBColors.padS),
                      Text(
                        _signUp
                            ? 'Save builds, track orders, and keep your cart between visits.'
                            : 'Sign in to pick up your cart and saved builds.',
                        style: BBTextResponsive.bodyLarge(
                          context,
                          color: muted,
                        ),
                      ),
                      const SizedBox(height: BBColors.padXL),
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(value: true, label: Text('Sign up')),
                          ButtonSegment(value: false, label: Text('Sign in')),
                        ],
                        selected: {_signUp},
                        showSelectedIcon: false,
                        onSelectionChanged: (s) => setState(() {
                          _signUp = s.first;
                          _error = null;
                          _formKey.currentState?.reset();
                        }),
                      ),
                      const SizedBox(height: BBColors.padXL),
                      if (_signUp) ...[
                        TextFormField(
                          controller: _name,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                          decoration: const InputDecoration(
                            labelText: 'Full name',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: AuthService.validateName,
                        ),
                        const SizedBox(height: BBColors.padM),
                      ],
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: AuthService.validateEmail,
                      ),
                      const SizedBox(height: BBColors.padM),
                      TextFormField(
                        controller: _password,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        autofillHints: [
                          _signUp
                              ? AutofillHints.newPassword
                              : AutofillHints.password,
                        ],
                        decoration: InputDecoration(
                          labelText: 'Password',
                          helperText: _signUp ? 'At least 8 characters' : null,
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            tooltip: _obscure
                                ? 'Show password'
                                : 'Hide password',
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: _signUp
                            ? AuthService.validatePassword
                            : (v) => (v == null || v.isEmpty)
                                  ? 'Enter your password.'
                                  : null,
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: BBColors.padM),
                        Text(
                          _error!,
                          style: BBTextResponsive.bodyMedium(
                            context,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          semanticsLabel: 'Error: $_error',
                        ),
                      ],
                      const SizedBox(height: BBColors.padXL),
                      BrandButton(
                        text: _signUp ? 'Create account' : 'Sign in',
                        onPressed: _loading ? null : _submit,
                        isLoading: _loading,
                        fullWidth: true,
                      ),
                      const SizedBox(height: BBColors.padL),
                      Text(
                        'Your account is stored only on this device.',
                        textAlign: TextAlign.center,
                        style: BBTextResponsive.bodySmall(
                          context,
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
