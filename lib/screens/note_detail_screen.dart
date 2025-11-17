import 'package:flutter/material.dart';
import '../models/note.dart';
import '../theme.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  String _formatDateTime(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final d = dt.day.toString().padLeft(2, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final y = dt.year.toString();
      final h = dt.hour.toString().padLeft(2, '0');
      final mn = dt.minute.toString().padLeft(2, '0');
      return '$d/$m/$y • $h:$mn';
    } catch (_) {
      return iso.split('T').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = note.title?.trim();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("Détail de la note", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- TITRE OPTIONNEL ---
            if (title != null && title.isNotEmpty)
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

            /// --- ESPACE ---
            const SizedBox(height: 8),

            /// --- DATE & HEURE ---
            Text(
              _formatDateTime(note.createdAt),
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const Divider(height: 30),

            /// --- CONTENU ---
            Text(
              note.content,
              style: const TextStyle(fontSize: 17, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}
