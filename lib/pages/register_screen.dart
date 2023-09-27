import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _fullName = '';
  List<String> _favoritos = []; // Campo "favoritos" como um array
  File? _imageFile;
  Image? _previewImage;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Firebase.initializeApp();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Obtém a referência do Firebase Storage para a foto de perfil.
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('foto_perfil/${userCredential.user!.uid}.jpg');

        // Se uma imagem de perfil foi selecionada, faça o upload dela para o Firebase Storage.
        if (_imageFile != null) {
          await storageRef.putFile(_imageFile!);
        }

        // Insira o usuário no Firestore com o UID como ID do documento e inclua os favoritos.
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'foto': storageRef.fullPath,
          'loginID': userCredential.user!.uid,
          'nomecompleto': _fullName,
          'favoritos': _favoritos, // Campo "favoritos"
        });

        // Registro bem-sucedido, redirecione para a próxima tela (por exemplo, a página inicial).
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                AuthScreen(), // Substitua pelo nome da sua página de destino.
          ),
        );
      } catch (e) {
        print('Erro de registro: $e');
        _showErrorDialog(
            'Erro de registro. Verifique seus dados e tente novamente.');
      }
    }
  }

  Future<void> _showErrorDialog(String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro de Registro'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final File imageFile = File(pickedImage.path);
      setState(() {
        _imageFile = imageFile;
        _previewImage = Image.file(imageFile, fit: BoxFit.cover);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _previewImage != null
              ? Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _previewImage!.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: Text('Escolher imagem de perfil'),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Nome Completo',
                          contentPadding: EdgeInsets.all(12.0),
                          border: OutlineInputBorder(),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Nome completo é obrigatório';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          _fullName = value!;
                        },
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            contentPadding: EdgeInsets.all(12.0),
                            border: OutlineInputBorder(),
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
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            contentPadding: EdgeInsets.all(12.0),
                            border: OutlineInputBorder(),
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
                              onPressed: _register,
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
          ),
        ],
      ),
    );
  }
}
