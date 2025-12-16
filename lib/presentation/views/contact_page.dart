import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../view_models/contact_view_model.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  int _selectedIndex = 0;

  void _showAddDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter un ami"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Entrez l'adresse email de la personne que vous souhaitez ajouter.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email de l'ami",
                  hintText: "exemple@gmail.com",
                  prefixIcon: Icon(Icons.mail_outline),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ],
          ),
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

              final success = await context.read<ContactViewModel>()
                  .sendFriendRequest(emailController.text);

              if (success) {
                navigator.pop();
                scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text("Demande envoyée !"), backgroundColor: Colors.blue)
                );
              } else {
                if(context.mounted) {
                  final error = context.read<ContactViewModel>().errorMessage;
                  scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text(error ?? "Erreur"), backgroundColor: Colors.red)
                  );
                }
              }
            },
            child: const Text("Envoyer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Communauté"),
        centerTitle: false,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.person_add),
        label: const Text("Ajouter"),
      )
          : null,

      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildFriendsList(context),
          _buildRequestsList(context),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Mes Amis',
          ),

          StreamBuilder<QuerySnapshot>(
            stream: context.read<ContactViewModel>().getRequestsStream(),
            builder: (context, snapshot) {
              int requestCount = 0;
              if (snapshot.hasData) {
                requestCount = snapshot.data!.docs.length;
              }

              return NavigationDestination(
                icon: Badge(
                  isLabelVisible: requestCount > 0,
                  label: Text('$requestCount'),
                  child: const Icon(Icons.notifications_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: requestCount > 0,
                  label: Text('$requestCount'),
                  child: const Icon(Icons.notifications),
                ),
                label: 'Demandes',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    final viewModel = context.read<ContactViewModel>();

    return StreamBuilder<QuerySnapshot>(
      stream: viewModel.getContactsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) return _emptyState("Aucun ami pour le moment", Icons.diversity_3);

        final contacts = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contactDoc = contacts[index].data() as Map<String, dynamic>;
            final friendUid = contactDoc['uid'];
            final oldName = contactDoc['displayName'] ?? "Inconnu";
            final oldPhoto = contactDoc['photoURL'];

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(friendUid).snapshots(),
              builder: (context, userSnapshot) {
                String displayName = oldName;
                String? photoURL = oldPhoto;

                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  final freshName = userData['displayName'] ?? "Inconnu";
                  final freshPhoto = userData['photoURL'];

                  if (freshName != oldName || freshPhoto != oldPhoto) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) viewModel.syncContactInfo(friendUid, userData);
                    });
                  }
                  displayName = freshName;
                  photoURL = freshPhoto;
                }

                return ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      backgroundImage: photoURL != null ? NetworkImage(photoURL) : null,
                      child: photoURL == null ? Text(displayName.isNotEmpty ? displayName[0] : "?") : null
                  ),
                  title: Text(displayName, style: const TextStyle(fontWeight: FontWeight.w500)),
                  trailing: IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () {}),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildRequestsList(BuildContext context) {
    final viewModel = context.read<ContactViewModel>();

    return StreamBuilder<QuerySnapshot>(
      stream: viewModel.getRequestsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) return _emptyState("Aucune demande en attente", Icons.notifications_off_outlined);

        final requests = snapshot.data!.docs;

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index].data() as Map<String, dynamic>;
            final senderUid = request['uid'];
            final senderName = request['displayName'] ?? "Inconnu";
            final senderPhoto = request['photoURL'];

            return Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: senderPhoto != null ? NetworkImage(senderPhoto) : null,
                    child: senderPhoto == null ? Text(senderName.isNotEmpty ? senderName[0] : "?") : null,
                  ),
                  title: Text(senderName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("veut vous ajouter en ami", style: TextStyle(fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                          foregroundColor: Colors.red,
                        ),
                        icon: const Icon(Icons.close),
                        onPressed: () => viewModel.refuseRequest(senderUid),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.check),
                        onPressed: () => viewModel.acceptRequest(senderUid, request),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _emptyState(String text, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.grey.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(text, style: TextStyle(color: Colors.grey.withValues(alpha: 0.8), fontSize: 16)),
        ],
      ),
    );
  }
}