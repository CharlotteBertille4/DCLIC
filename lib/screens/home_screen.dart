import 'package:flutter/material.dart';
import 'package:projet_dclic/screens/note_list_screen.dart';
import '../models/user.dart';
import '../theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Bienvenue, ${user.username}')),
      appBar: const CustomAppBar(title: 'Mes notes'),
      drawer: CustomDrawer(user: user),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tu es connecté(e) avec ${user.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: naviguer vers la liste des notes
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => NoteListScreen(user: user)),
                );
              },
              child: const Text('Aller aux notes'),
            ),
          ],
        ),
      ),
    );
  }
}
