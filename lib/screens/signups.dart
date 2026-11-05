import 'package:flutter/material.dart';
import 'package:sideproject/utils/formvalidate.dart';

void main() {
  runApp(const MaterialApp(home: Signup(), debugShowCheckedModeBanner: false));
}

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // here we are hiding the elements of the signupstate

  bool isChecked = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms and Privacy Policy.'),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Signup form is valid!')));
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return 'Please enter your name';
    }

    final words = name.split(RegExp(r"[\s'-]+"));
    final hasUncapitalizedWord = words.any((word) {
      if (word.isEmpty) {
        return true;
      }

      final firstLetter = String.fromCharCode(word.runes.first);
      return firstLetter.toUpperCase() != firstLetter ||
          firstLetter.toLowerCase() == firstLetter;
    });

    if (hasUncapitalizedWord) {
      return 'Capitalize the first letter of each name';
    }

    return null;
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

                    // Heading
                    const Text(
                      'Create your account',

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF18243B),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Join FoodMood and discover great food.',

                      textAlign: TextAlign.center,

                      style: TextStyle(fontSize: 14, color: Color(0xFF57606A)),
                    ),

                    const SizedBox(height: 32),

                    // Full name
                    _fieldLabel('Full name'),

                    TextFormField(
                      controller: _nameController,

                      textCapitalization: TextCapitalization.words,
                      decoration: _inputDecoration(
                        hint: 'Enter your full name',
                        icon: Icons.person_outline,
                      ),

                      validator: _validateName,
                    ),

                    const SizedBox(height: 18),

                    // Email
                    _fieldLabel('Email address'),

                    TextFormField(
                      controller: _emailController,

                      keyboardType: TextInputType.emailAddress,

                      decoration: _inputDecoration(
                        hint: 'you@example.com',
                        icon: Icons.email_outlined,
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

                    // Password
                    _fieldLabel('Password'),

                    TextFormField(
                      controller: _passwordController,

                      obscureText: hidePassword,

                      decoration:
                          _inputDecoration(
                            hint: 'Create a password',
                            icon: Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },

                              icon: Icon(
                                hidePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }

                        if (value.length < 8) {
                          return 'Password must contain at least 8 characters';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    // Confirm password
                    _fieldLabel('Confirm password'),

                    TextFormField(
                      controller: _confirmPasswordController,

                      obscureText: hideConfirmPassword,

                      decoration:
                          _inputDecoration(
                            hint: 'Re-enter your password',
                            icon: Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideConfirmPassword = !hideConfirmPassword;
                                });
                              },

                              icon: Icon(
                                hideConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }

                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Terms and conditions
                    CheckboxListTile(
                      value: isChecked,

                      onChanged: (value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },

                      controlAffinity: ListTileControlAffinity.leading,

                      contentPadding: EdgeInsets.zero,

                      activeColor: const Color(0xFFFF5A1F),

                      title: const Text(
                        'I agree to the Terms of Service and Privacy Policy.',

                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF57606A),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Create account button
                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: FilledButton(
                        onPressed: _createAccount,

                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5A1F),

                          foregroundColor: Colors.white,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: const Text(
                          'Create account',

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Divider
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color(0xFFE8D9D0)),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),

                          child: Text(
                            'or sign up with',

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

                    const SizedBox(height: 16),

                    // Google button
                    SizedBox(
                      width: double.infinity,
                      height: 48,

                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Google signup not implemented yet',
                              ),
                            ),
                          );
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

                    const SizedBox(height: 20),

                    // Login navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        const Text(
                          'Already have an account?',

                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF57606A),
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login screen not connected yet'),
                              ),
                            );
                          },

                          child: const Text(
                            'Log in',

                            style: TextStyle(
                              color: Color(0xFFFF5A1F),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.orange),
                        ),
                        // TextButton(onPressed: null,)
                        TextButton(
                          onPressed: null,
                          child: Text(
                            "Sign up",
                            style: TextStyle(color: Colors.orange),
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

  // Reusable field label
  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),

      child: Text(
        label,

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
    );
  }
}
