import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/themes/app_colors.dart';
import '../components/atoms/aerisys_button.dart';
import '../components/atoms/aerisys_text_field.dart';
import '../view_models/auth_view_model.dart';
import '../view_models/map_view_model.dart';
import '../components/atoms/aerisys_icon.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthViewModel>().currentUser;
    _nameController.text = user?.displayName ?? "";
    _emailController.text = user?.email ?? "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();
    final user = viewModel.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Mon Profil"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.darkSlate,
                    backgroundImage: _getProfileImage(user?.photoURL),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.brandBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const AerisysIcon(
                        Icons.camera_alt,
                        color: AppColors.textWhite,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            AerisysTextField(
              controller: _emailController,
              enabled: false,
              labelText: "Email",
              prefixIcon: const AerisysIcon(Icons.email),
              hintText: user?.email ?? "Non renseigné",
            ),
            const SizedBox(height: 16),

            AerisysTextField(
              controller: _nameController,
              labelText: "Nom d'affichage",
              hintText: "Votre nom",
              prefixIcon: const AerisysIcon(Icons.person),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: AerisysButton.filled(
                text: viewModel.isLoading
                    ? "Enregistrement..."
                    : "Sauvegarder les modifications",
                icon: const AerisysIcon(Icons.save),
                isLoading: viewModel.isLoading,
                onPressed: () async {
                  final success = await context
                      .read<AuthViewModel>()
                      .updateProfile(
                        newName: _nameController.text,
                        newImageFile: _selectedImage,
                      );

                  if (context.mounted) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Profil mis à jour !"),
                          backgroundColor: AppColors.success,
                        ),
                      );
                      setState(() {
                        _selectedImage = null;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(viewModel.errorMessage!),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  }
                },
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),

            AerisysButton.text(
              text: "Se déconnecter",
              icon: const AerisysIcon(Icons.logout, color: AppColors.error),
              foregroundColor: AppColors.error,
              onPressed: () async {
                final bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Déconnexion"),
                    content: const Text(
                      "Voulez-vous vraiment vous déconnecter ?",
                    ),
                    actions: [
                      AerisysButton.text(
                        text: "Annuler",
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      AerisysButton.text(
                        text: "Se déconnecter",
                        foregroundColor: AppColors.error,
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  await context.read<MapViewModel>().stopTracking();

                  if (context.mounted) {
                    await context.read<AuthViewModel>().logout();
                  }

                  if (context.mounted) {
                    context.go(AppRoutes.login);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getProfileImage(String? firebasePhotoUrl) {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    }
    if (firebasePhotoUrl != null && firebasePhotoUrl.isNotEmpty) {
      return NetworkImage(firebasePhotoUrl);
    }
    return const NetworkImage(
      "https://ui-avatars.com/api/?name=User&background=random",
    );
  }
}
