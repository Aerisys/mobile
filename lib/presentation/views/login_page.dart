import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/themes/app_assets.dart';
import '../../core/themes/app_colors.dart';
import '../view_models/auth_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.background),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black26, 
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.0),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                   const SizedBox(height: 40),
                  Image.asset(AppAssets.logo),
                  const Text(
                    'Connexion',
                    style: TextStyle(
                      fontFamily: 'Inter', 
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: AppColors.mainText,
                      letterSpacing: 1.0,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Main Card Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Social Buttons
                        _SocialLoginButton(
                          icon: FontAwesomeIcons.google,
                          text: 'Continuer avec Google',
                          onPressed: () {}, // TODO: Implement Google Sign In
                          iconColor: Colors.red, // Approximation for Google logo color
                        ),
                        const SizedBox(height: 16),
                        _SocialLoginButton(
                          icon: FontAwesomeIcons.apple,
                          text: 'Continuer avec Apple',
                          onPressed: () {}, // TODO: Implement Apple Sign In
                          iconColor: Colors.black,
                        ),

                        const SizedBox(height: 24),
                        
                        // Divider
                        const Row(
                          children: [
                            Expanded(child: Divider(color: Colors.white54)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Ou entrez vos identifiants',
                                style: TextStyle(color: AppColors.mainText, fontSize: 12),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.white54)),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Input Fields
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Email...',
                            filled: true,
                            fillColor: AppColors.mainText,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: AppColors.noirProfond),
                          decoration: InputDecoration(
                            hintText: 'Mot de passe...',
                            filled: true,
                            fillColor: AppColors.mainText,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Options Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Row(
                               children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: _rememberMe, 
                                      onChanged: (val) {
                                        setState(() {
                                          _rememberMe = val ?? false;
                                        });
                                      },
                                      side: const BorderSide(color: AppColors.mainText),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Se rappeler de moi', style: TextStyle(color: AppColors.mainText),),
                               ],
                             ),
                             TextButton(
                              onPressed: () {}, // TODO: Forgot password
                              child: const Text(
                                'Mot de passe oublié ?',
                                style: TextStyle(color: AppColors.bleuAzur), 
                              ),
                             )
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: viewModel.isLoading
                                ? null
                                : () async {
                                    FocusScope.of(context).unfocus();

                                    final bool success = await context
                                        .read<AuthViewModel>()
                                        .login(
                                          _emailController.text,
                                          _passwordController.text,
                                        );

                                    if (!context.mounted) return;

                                    if (success) {
                                      if (!context.mounted) return;
                                      context.go(AppRoutes.home);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            viewModel.errorMessage!,
                                            style: const TextStyle(color: AppColors.mainText),
                                          ),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.bleuAzur,
                              foregroundColor: AppColors.mainText,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: viewModel.isLoading
                              ? const CircularProgressIndicator(color: AppColors.mainText)
                              : const Text('Commencer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        
                        const SizedBox(height: 24),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Vous n'avez pas de compte ? ", style: TextStyle(color: AppColors.mainText)),
                            GestureDetector(
                               onTap: () => context.go(AppRoutes.register),
                               child: const Text(
                                'Créer', 
                                style: TextStyle(
                                  color: AppColors.bleuAzur, 
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final Color iconColor;

  const _SocialLoginButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainText,
          foregroundColor: AppColors.noirProfond,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: iconColor),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.noirProfond,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
