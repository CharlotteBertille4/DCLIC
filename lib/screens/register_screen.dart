import 'package:flutter/material.dart';
import 'package:projet_dclic/screens/login_screen.dart';
import 'package:projet_dclic/services/user_database.dart';
import 'package:projet_dclic/theme.dart';

import '../models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  final db = UserDatabase.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  //generation de l'id
  String _generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final email = _emailController.text.trim();
    final existing = await db.getUserByEmail(email);
    if (existing != null) {
      setState(() => _loading = false);
      // email déjà utilisé
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cet e-mail est déjà utilisé.')),
      );
      return;
    }

    final user = User(
      id: _generateId(),
      username: _usernameController.text.trim(),
      email: email,
      password: _passwordController.text, // pour demo seulement
    );

    await db.insertUser(user);
    setState(() => _loading = false);

    // navigation vers home (on passe user en argument si besoin)
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  String? _validateEmail(String? mail) {
    if (mail == null || mail.trim().isEmpty) return 'Email requis';
    final email = mail.trim();
    final emailReg = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailReg.hasMatch(email)) return 'Email invalide';
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Mot de passe requis';
    if (password.length < 6) return 'Au moins 6 caractères';
    return null;
  }

  String? _validateUsername(String? username) {
    if (username == null || username.trim().isEmpty) return 'Nom requis';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inscription')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Créez un compte'),
                      SizedBox(height: 16),

                      //CREATION DU CHAMP USERNAME
                      TextFormField(
                        validator: _validateUsername,
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: kSecondaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      SizedBox(height: 12),

                      //CREATION DU CHAMP EMAIL
                      TextFormField(
                        validator: _validateEmail,
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: kSecondaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      SizedBox(height: 12),

                      //CREATION DU CHAMP PASSWORD
                      TextFormField(
                        validator: _validatePassword,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: kSecondaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),

                      //ajout du bouton d'inscription
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'S’inscrire',
                                  //style: TextStyle(color: kSecondaryColor),
                                ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      // Lien vers login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Tu as déjà un compte ?'),
                          TextButton(
                            onPressed: () {
                              // Naviguer vers login_screen (à implémenter)
                              Navigator.of(context).pushNamed('/login');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: kPrimaryColor,
                            ),
                            child: const Text('Se connecter'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
