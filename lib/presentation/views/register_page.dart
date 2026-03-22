import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/themes/app_assets.dart';
import '../../core/themes/app_colors.dart';
import '../components/atoms/aerisys_button.dart';
import '../view_models/auth_view_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                colorFilter: ColorFilter.mode(
                  AppColors.black26, 
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
                  AppColors.black.withValues(alpha: 0.0),
                  AppColors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    children: [
                       const SizedBox(height: 20),
                       // Logo and Title
                       Image.asset(
                        AppAssets.logoAERISYS,
                        height: 80,
                      ),
                      const Text(
                        'Créer un\ncompte',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Hanson', 
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textWhite,
                          letterSpacing: 1.0,
                          height: 1.0, 
                        ),
                      ),

                      const SizedBox(height: 20),

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
                                    'Ou continuer avec email',
                                    style: TextStyle(color: AppColors.textWhite70, fontSize: 12),
                                  ),
                                ),
                                Expanded(child: Divider(color: AppColors.textWhite70)),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Form Fields
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _nameController,
                                    hintText: 'Nom',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _firstNameController,
                                    hintText: 'Prénom',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _emailController,
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _dobController,
                              hintText: 'Date de naissance',
                              keyboardType: TextInputType.datetime,
                               // Ideally use a date picker here
                               readOnly: false, // Set to true if using date picker
                            ),
                             const SizedBox(height: 16),
                            _buildTextField(
                              controller: _passwordController,
                              hintText: 'Mot de passe...',
                              obscureText: true,
                            ),
                             const SizedBox(height: 16),
                            _buildTextField(
                              controller: _confirmPasswordController,
                              hintText: 'confirmer mot de passe',
                              obscureText: true,
                            ),

                            const SizedBox(height: 24),

                            // Action Button
                            AerisysButton.primary(
                              text: 'Commencer',
                              isLoading: viewModel.isLoading,
                              onPressed: () async {
                                FocusScope.of(context).unfocus();

                                if (_passwordController.text !=
                                    _confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Les mots de passe ne correspondent pas.",
                                        style: TextStyle(color: AppColors.textWhite),
                                      ),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                  return;
                                }

                                final bool success = await context
                                    .read<AuthViewModel>()
                                    .register(
                                      _emailController.text,
                                      _passwordController.text,
                                    );

                                if (!context.mounted) return;

                                if (success) {
                                  if (!context.mounted) return;
                                  context.go(AppRoutes.permissions);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        viewModel.errorMessage ?? "Erreur inconnue",
                                        style: const TextStyle(color: AppColors.textWhite),
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
                                const Text("Vous avez déjà un compte ? ", style: TextStyle(color: AppColors.textWhite),),
                                AerisysButton.text(
                                  text: 'Se connecter',
                                  onPressed: () => context.go(AppRoutes.login),
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
            )
          ),
        ],
      )
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.black),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: AppColors.textWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
