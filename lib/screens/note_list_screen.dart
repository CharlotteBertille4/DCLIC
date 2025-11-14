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
              mainAxisSize: MainAxisSize.min, // <-- fait rétrécir le dialog
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
                  decoration: const InputDecoration(labelText: 'Contenu'),
                  maxLines: null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                final content = _contentController.text.trim();
                if (content.isEmpty)
                  return; // tu peux ajouter un Snackbar si tu veux
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

  // Future<void> _addNoteDialog() async {
  //   _titleController.clear();
  //   _contentController.clear();
  //
  //   await showDialog(
  //     context: context,
  //     builder: (ctx) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         title: const Text("Nouvelle note"),
  //         content: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             TextField(
  //               controller: _titleController,
  //               decoration: InputDecoration(labelText: 'Titre (optionnel)'),
  //             ),
  //             TextField(
  //               controller: _contentController,
  //               decoration: InputDecoration(labelText: 'Contenu'),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(ctx),
  //             child: const Text("Annuler"),
  //           ),
  //           // ElevatedButton(
  //           //   onPressed: () async {
  //           //     final title = _titleController.text.trim();
  //           //     final content = _contentController.text.trim();
  //           //     if (content.isEmpty) return; // tu peux prévenir l'utilisateur
  //           //
  //           //     final now = DateTime.now().toIso8601String();
  //           //     final id = DateTime.now().millisecondsSinceEpoch; // id simple
  //           //
  //           //     final noteMap = {
  //           //       'id': id,
  //           //       'userId': user,
  //           //       'title': title.isEmpty ? null : title,
  //           //       'content': content,
  //           //       'createdAt': now,
  //           //     };
  //           //
  //           //     try {
  //           //       await db.insertNote(noteMap as Note);
  //           //       await _loadNotes(); // recharge la liste immédiatement
  //           //       Navigator.pop(context);
  //           //     } catch (e) {
  //           //       // Gérer l'erreur si besoin
  //           //       print('NOTE DB: insertNote ERROR -> $e');
  //           //       Navigator.pop(context);
  //           //     }
  //           //   },
  //           //   style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
  //           //   child: const Text(
  //           //     "Ajouter",
  //           //     style: TextStyle(color: Colors.white),
  //           //   ),
  //           // ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               final title = _titleController.text.trim();
  //               final content = _contentController.text.trim();
  //               if (content.isEmpty) return; // tu peux prévenir l'utilisateur
  //               final now = DateTime.now().toIso8601String();
  //               final id = DateTime.now().millisecondsSinceEpoch
  //                   .toString(); // id simple
  //
  //               final note = Note(
  //                 id: id,
  //                 userId: widget.user.id,
  //                 title: title.trim().isEmpty ? null : title.trim(),
  //                 content: content,
  //                 createdAt: now,
  //               );
  //               try {
  //                 await db.insertNote(note);
  //                 await _loadNotes(); // recharge la liste immédiatement
  //                 Navigator.pop(ctx);
  //               } catch (e) {
  //                 // Gérer l'erreur si besoin
  //                 print('NOTE DB: insertNote ERROR -> $e');
  //                 Navigator.pop(context);
  //               }
  //             },
  //             style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
  //             child: const Text(
  //               "Ajouter",
  //               style: TextStyle(color: Colors.white),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _editNoteDialog(Note note) async {
    final TextEditingController ctrl = TextEditingController(
      text: note.content,
    );
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Modifier la note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                decoration: const InputDecoration(
                  labelText: "Contenu de la note",
                ),
              ),
            ],
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
                final text = ctrl.text.trim();
                if (text.isNotEmpty) {
                  final updatedNote = note.copyWith(content: text);
                  await db.updateNote(updatedNote);
                  Navigator.pop(ctx);
                  _loadNotes();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              child: const Text(
                "Enregistrer",
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

  void _showNoteDetail(Note note) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: note.title != null && note.title!.trim().isNotEmpty
              ? Text(note.title!)
              : const Text('Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.content),
                const SizedBox(height: 12),
                Text(
                  'Créé le ${_formatDateTime(note.createdAt)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Fermer'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _editNoteDialog(note);
              },
              child: const Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      // appBar: AppBar(
      //   backgroundColor: kPrimaryColor,
      //   title: Text('Mes Notes — ${widget.user.username}'),
      //   actions: [
      //     IconButton(onPressed: _addNoteDialog, icon: const Icon(Icons.add)),
      //   ],
      // ),
      appBar: const CustomAppBar(title: 'Mes notes'),
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
                    // ouvre une nouvelle page avec la note complète (voir étape 5)
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
                        // Expanded gauche : titre (ligne 1) + date+contenu (ligne 2)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Ligne 1 : titre (si présent)
                              if (hasT)
                                Text(
                                  note.title!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                              // espace petit
                              if (hasT) const SizedBox(height: 6),

                              // Ligne 2 : date + début du contenu sur la même ligne
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

                                  // début du contenu (tronqué)
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

                        // icônes action à droite
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

              // itemBuilder: (ctx, i) {
              //   final note = notes[i];
              //   return ListTile(
              //     title: Text(note.title ?? '(Sans titre)'),
              //     subtitle: Text(
              //       note.content.split('T').first,
              //       maxLines: 2,
              //       overflow: TextOverflow.ellipsis,
              //     ),
              //     trailing: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         IconButton(
              //           icon: const Icon(Icons.edit, color: Colors.blueAccent),
              //           onPressed: () => _editNoteDialog(note),
              //         ),
              //         IconButton(
              //           icon: const Icon(Icons.delete, color: Colors.redAccent),
              //           onPressed: () => _deleteNoteDialog(note),
              //         ),
              //       ],
              //     ),
              //   );
              // },
            ),
    );
  }
}
