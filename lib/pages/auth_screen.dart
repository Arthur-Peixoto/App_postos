import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_map_tracker/pages/register_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

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
  Image? backgroundImage;

  @override
  void initState() {
    super.initState();
    loadBackgroundImage();
  }

  Future<void> loadBackgroundImage() async {
    await Firebase.initializeApp();
    final Reference ref = FirebaseStorage.instance.ref().child('posto.jpg');

    final String url = await ref.getDownloadURL();
    setState(() {
      backgroundImage = Image.network(url, fit: BoxFit.cover);
    });
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // ignore: unused_local_variable
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
        _showErrorDialog('Login inválido. Verifique seu email e senha.');
      }
    }
  }

  Future<void> _showErrorDialog(String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro de Autenticação'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo.
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.local_gas_station), // Ícone de combustível
            SizedBox(width: 8), // Espaçamento entre o ícone e o texto
            Text('Postos', style: TextStyle(fontSize: 24)), // Aumento do tamanho do texto
          ],
        ),
        centerTitle: true, // Centraliza o título na AppBar.
      ),
      body: Stack(
        children: [
          if (backgroundImage != null)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: backgroundImage!.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5), // Fundo semitransparente
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          contentPadding: EdgeInsets.all(12.0),
                          border: InputBorder.none, // Sem borda
                        ),
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
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5), // Fundo semitransparente
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          contentPadding: EdgeInsets.all(12.0),
                          border: InputBorder.none, // Sem borda
                        ),
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
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _signIn,
                            child: Text('Login'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                            },
                            child: Text('Registrar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
