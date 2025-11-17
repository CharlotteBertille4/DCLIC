import 'package:flutter/material.dart';
import 'package:projet_dclic/screens/note_detail_screen.dart';

import '../models/note.dart';
import '../models/user.dart';
import '../services/note_database.dart';
import '../theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class NoteListScreen extends StatefulWidget {
  final User user;
  const NoteListScreen({super.key, required this.user});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final db = NoteDatabase.instance;
  List<Note> notes = [];
  bool _loading = true;

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  bool hasTitle(String? t) => t != null && t.trim().isNotEmpty;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadNotes();
  }

  //rechargement des notes par user
  Future<void> _loadNotes() async {
    final data = await db.getNotesByUser(widget.user.id);
    setState(() {
      notes = data;
      _loading = false;
    });
  }

  //formulaire des crud de note

  Future<void> _addNoteDialog() async {
    _titleController.clear();
    _contentController.clear();

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Nouvelle note"),
          content: SingleChildScrollView(
            // important pour éviter que le dialog prenne toute la hauteur
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre (optionnel)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _contentController,
                  maxLines: 8, // textarea large
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: "Contenu",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                "Annuler",
                style: TextStyle(color: kSecondaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                final content = _contentController.text.trim();
                if (content.isEmpty) return;
                final now = DateTime.now().toIso8601String();
                final id = DateTime.now().millisecondsSinceEpoch.toString();

                final note = Note(
                  id: id,
                  userId: widget.user.id,
                  title: title.isEmpty ? null : title,
                  content: content,
                  createdAt: now,
                );

                try {
                  await db.insertNote(note);
                  await _loadNotes();
                  Navigator.pop(ctx);
                } catch (e) {
                  print('NOTE DB: insertNote ERROR -> $e');
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              child: const Text(
                "Ajouter",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editNoteDialog(Note note) async {
    // Pré-remplir les champs avec les valeurs actuelles
    _titleController.text = note.title ?? "";
    _contentController.text = note.content;

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Modifier la note"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre (optionnel)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _contentController,
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: "Contenu",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                "Annuler",
                style: TextStyle(color: kSecondaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                final content = _contentController.text.trim();

                if (content.isEmpty) return;

                final updated = Note(
                  id: note.id, // garder le même ID
                  userId: note.userId, // garder le même userId
                  title: title.isEmpty ? null : title,
                  content: content,
                  createdAt: note.createdAt, // on garde la date d'origine
                );

                try {
                  await db.updateNote(updated);
                  await _loadNotes();
                  Navigator.pop(ctx);
                } catch (e) {
                  print("NOTE DB: updateNote ERROR -> $e");
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              child: const Text(
                "Modifier",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteNoteDialog(Note note) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Confirmation"),
          content: const Text("Voulez-vous vraiment supprimer cette note ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                "Annuler",
                style: TextStyle(color: kSecondaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await db.deleteNote(note.id);
                Navigator.pop(ctx);
                _loadNotes();
              },
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              child: const Text(
                "Supprimer",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDateTime(String iso) {
    final dt = DateTime.parse(iso);
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year.toString();
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');

    return "$day/$month/$year – $hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: const CustomAppBar(title: 'Liste des notes'),
      drawer: CustomDrawer(user: widget.user),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
          ? const Center(child: Text("Aucune note pour l’instant"))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              separatorBuilder: (_, __) => const Divider(),
              itemCount: notes.length,
              itemBuilder: (ctx, i) {
                final note = notes[i];

                final hasT = hasTitle(note.title);
                final dateStr = _formatDateTime(note.createdAt);

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoteDetailScreen(note: note),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 8.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasT)
                                Text(
                                  note.title!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              if (hasT) const SizedBox(height: 6),
                              Row(
                                children: [
                                  // date
                                  Text(
                                    dateStr,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      note.content,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: kSecondaryColor,
                              ),
                              onPressed: () => _editNoteDialog(note),
                              tooltip: 'Modifier',
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: kSecondaryColor,
                              ),
                              onPressed: () => _deleteNoteDialog(note),
                              tooltip: 'Supprimer',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNoteDialog,
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
