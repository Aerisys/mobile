import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/themes/app_assets.dart';
import '../../core/themes/app_colors.dart';
import '../components/atoms/aerisys_button.dart';
import '../components/atoms/aerisys_loader.dart';
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
                image: NetworkImage(AppAssets.onlineBackground),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(AppColors.black26, BlendMode.darken),
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
                  AppColors.black.withValues(alpha: 0.0),
                  AppColors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),

          if (viewModel.isLoading)
            const Center(child: AerisysLoader())
          else
            _buildMainContent(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, AuthViewModel viewModel) {
    return SafeArea(
      child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Logo and Title
                  Image.asset(
                    AppAssets.logoAERISYS,
                    color: AppColors.white,
                    height: 80,
                  ),
                  const Text(
                    'Connexion',
                    style: TextStyle(
                      fontFamily: 'Hanson',
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textWhite,
                      letterSpacing: 1.0,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Main Card Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: AppColors.black, // Solid black card per mockup
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: Column(
                      children: [
                        // Social Buttons
                        AerisysButton.social(
                          icon: const FaIcon(FontAwesomeIcons.google, color: AppColors.error),
                          text: 'Continuer avec Google',
                          onPressed: () {}, // TODO: Implement Google Sign In
                        ),
                        const SizedBox(height: 16),
                        AerisysButton.social(
                          icon: const FaIcon(FontAwesomeIcons.apple, color: AppColors.black),
                          text: 'Continuer avec Apple',
                          onPressed: () {}, // TODO: Implement Apple Sign In
                        ),

                        const SizedBox(height: 24),

                        // Divider
                        const Row(
                          children: [
                            Expanded(child: Divider(color: AppColors.textWhite70)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Ou entrez vos identifiants',
                                style: TextStyle(
                                  color: AppColors.textWhite70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: AppColors.textWhite70)),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Input Fields
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: AppColors.black),
                          decoration: InputDecoration(
                            hintText: 'Email...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: AppColors.textWhite,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
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
                          style: const TextStyle(color: AppColors.black),
                          decoration: InputDecoration(
                            hintText: 'Mot de passe...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: AppColors.textWhite,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
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
                            Expanded(
                              child: Row(
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
                                      side: const BorderSide(
                                        color: AppColors.textWhite70,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Flexible(
                                    child: Text(
                                      'Se rappeler de moi',
                                      style: TextStyle(
                                        color: AppColors.textWhite,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AerisysButton.text(
                              text: 'Mot de passe oublié ?',
                              onPressed: () {}, // TODO: Forgot password
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Action Button
                        AerisysButton.primary(
                          text: 'Commencer',
                          isLoading: viewModel.isLoading,
                          onPressed: () async {
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
                              context.go(AppRoutes.permissions);
                            } else {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    viewModel.errorMessage!,
                                    style: const TextStyle(
                                      color: AppColors.textWhite,
                                    ),
                                  ),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 24),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Vous n'avez pas de compte ? ",
                              style: TextStyle(color: AppColors.textWhite),
                            ),
                            AerisysButton.text(
                              text: 'Créer',
                              onPressed: () => context.go(AppRoutes.register),
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
        ),
    );
  }
}
