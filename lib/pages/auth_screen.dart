import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Autenticação bem-sucedida, redirecione para a próxima tela.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                HomePage(), // Substitua pelo nome da sua página de destino.
          ),
        );
      } catch (e) {
        // Trate erros de autenticação, como credenciais incorretas.
        print('Erro de autenticação: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autenticação'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (String? value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Email inválido';
                }
                return null;
              },
              onSaved: (String? value) {
                _email = value!;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
              validator: (String? value) {
                if (value!.isEmpty || value.length < 6) {
                  return 'Senha deve ter pelo menos 6 caracteres';
                }
                return null;
              },
              onSaved: (String? value) {
                _password = value!;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
