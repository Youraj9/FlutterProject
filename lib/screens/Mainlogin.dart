import 'package:flutter/material.dart';
// import 'package:sideproject/utils/form_validators.dart';
import 'package:sideproject/utils/formvalidate.dart';

void main() {
  runApp(const MaterialApp(home: Login(), debugShowCheckedModeBanner: false));
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Password visibility
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  // Login validation
  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login form validated successfully!')),
    );

    // Later we will connect the Node.js login API here.
  }

  void _showNotImplemented(String feature) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$feature not implemented yet')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F3),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    // FoodMood logo
                    const Icon(
                      Icons.restaurant,
                      color: Color(0xFFFF5A1F),
                      size: 42,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'FoodMood',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF18243B),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Welcome heading
                    const Text(
                      'Welcome back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF18243B),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Log in to discover your favorite food.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFF57606A)),
                    ),

                    const SizedBox(height: 32),

                    // Email field
                    _label('Email address'),

                    TextFormField(
                      controller: _emailController,

                      keyboardType: TextInputType.emailAddress,

                      textInputAction: TextInputAction.next,

                      autofillHints: const [AutofillHints.email],

                      decoration: _inputDecoration(
                        hint: 'Enter your email',
                        icon: Icons.mail_outline,
                      ),

                      // validator: (value) {
                      //   if (value == null || value.trim().isEmpty) {
                      //     return 'Please enter your email';
                      //   }

                      //   if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      //       .hasMatch(value.trim())) {
                      //     return 'Please enter a valid email';
                      //   }

                      //   return null;
                      // },
                      validator: FormValidators.validateEmail,
                    ),

                    const SizedBox(height: 18),

                    // Password field
                    _label('Password'),

                    TextFormField(
                      controller: _passwordController,

                      obscureText: _hidePassword,

                      textInputAction: TextInputAction.done,

                      autofillHints: const [AutofillHints.password],

                      onFieldSubmitted: (_) => _login(),
                      //   what does this part means here . (_) => login()
                      decoration:
                          _inputDecoration(
                            hint: 'Enter your password',
                            icon: Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },

                              icon: Icon(
                                _hidePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }

                        return null;
                      },
                      // validator: FormValidators.validateEmail,
                    ),

                    const SizedBox(height: 8),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,

                      child: TextButton(
                        onPressed: () {
                          _showNotImplemented('Password recovery');
                        },

                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Color(0xFFFF5A1F),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: FilledButton(
                        onPressed: _login,

                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5A1F),
                          foregroundColor: Colors.white,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color(0xFFE8D9D0)),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),

                          child: Text(
                            'or continue with',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8993A3),
                            ),
                          ),
                        ),

                        const Expanded(
                          child: Divider(color: Color(0xFFE8D9D0)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Google button
                    SizedBox(
                      width: double.infinity,
                      height: 48,

                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showNotImplemented('Google sign-in');
                        },

                        icon: const Icon(Icons.g_mobiledata, size: 28),

                        label: const Text('Continue with Google'),

                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF18243B),
                          backgroundColor: Colors.white,

                          side: const BorderSide(color: Color(0xFFE8D9D0)),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Signup navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF57606A),
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            _showNotImplemented('Signup navigation');
                          },

                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Color(0xFFFF5A1F),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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

  // Reusable label
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),

      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF18243B),
        ),
      ),
    );
  }

  // Reusable input decoration
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF8993A3)),

      prefixIcon: Icon(icon, color: const Color(0xFF8993A3)),

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8D9D0)),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8D9D0)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF5A1F), width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
