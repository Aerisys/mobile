import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../view_model/contact_view_model.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  void _showAddContactDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter un contact"),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "Email du contact",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          FilledButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              // Appel au ViewModel
              final success = await context.read<ContactViewModel>()
                  .addContactByEmail(emailController.text);

              if (success) {
                navigator.pop();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text("Contact ajouté !"), backgroundColor: Colors.green),
                );
              } else {
                final error = context.read<ContactViewModel>().errorMessage;
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text(error ?? "Erreur"), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ContactViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Contacts"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContactDialog(context),
        child: const Icon(Icons.person_add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: viewModel.getContactsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Erreur de chargement"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey.shade600),
                  const SizedBox(height: 16),
                  const Text("Aucun contact pour le moment"),
                ],
              ),
            );
          }

          final contacts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final data = contacts[index].data() as Map<String, dynamic>;

              final String name = (data['displayName'] != null && data['displayName'].isNotEmpty)
                  ? data['displayName']
                  : "Utilisateur sans nom";
              final String email = data['email'] ?? "";
              final String? photoURL = data['photoURL'];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: photoURL != null
                      ? NetworkImage(photoURL)
                      : null,
                  child: photoURL == null ? Text(name[0].toUpperCase()) : null,
                ),
                title: Text(name),
                subtitle: Text(email),
                trailing: IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    // TODO: Naviguer vers la page de chat plus tard
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}