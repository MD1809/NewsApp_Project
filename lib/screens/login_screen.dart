import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app_project/screens/main_screen.dart';
import 'package:news_app_project/screens/signup_screen.dart';
import 'package:news_app_project/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:news_app_project/services/theme_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await ArticleService.syncLocalOnLogin();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No account found for this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = themeController.isDark;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;


    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const MainScreen()),
                          );
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: colors.onBackground,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          themeController.toggleTheme();
                        },
                        icon: Icon(
                          isDark ? Icons.light_mode : Icons.dark_mode,
                          color: colors.onBackground,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Image.asset('assets/images/logo_app_news.png', height: 180),
                  const SizedBox(height: 60),

                  // Welcome text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back!",
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.onBackground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "We're happy to have you back. Log in to see what's new and continue exploring!",
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: colors.onBackground),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle:
                      TextStyle(color: colors.onBackground.withOpacity(0.5)),
                      filled: true,
                      fillColor: colors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter your email' : null,
                  ),

                  const SizedBox(height: 24),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: colors.onBackground),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle:
                      TextStyle(color: colors.onBackground.withOpacity(0.5)),
                      filled: true,
                      fillColor: colors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter your password' : null,
                  ),

                  const SizedBox(height: 0),

                  // Remember + Forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) =>
                                setState(() => _rememberMe = value!),
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(color: colors.onBackground),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot the password?',
                          style: TextStyle(color: colors.primary),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                        color: colors.onPrimary,
                      )
                          : Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: colors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account? ",
                        style: TextStyle(color: colors.onBackground),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(color: colors.primary),
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
    );
  }
}
