import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String nome = '';
  String email = '';
  String userID = '';
  String fotoPerfilURL = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    User? user = _auth.currentUser;

    if (user != null) {
      setState(() {
        userID = user.uid;
        email = user.email ?? '';
      });

      DocumentSnapshot<Map<String, dynamic>> userInfo =
          await _firestore.collection('users').doc(userID).get();

      if (userInfo.exists) {
        setState(() {
          nome = userInfo['nomecompleto'] ?? 'Nome do Usuário';
        });
      }

      // Carregar a foto de perfil do Firebase Storage
      try {
        final Reference storageRef =
            _storage.ref().child('foto_perfil/$userID.jpg');
        final url = await storageRef.getDownloadURL();
        setState(() {
          fotoPerfilURL = url;
        });
      } catch (e) {
        print('Erro ao carregar a foto de perfil: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
  radius: 50,
  backgroundImage: fotoPerfilURL.isNotEmpty
      ? Image.network(fotoPerfilURL).image
      : AssetImage('images/posto-icon.png'),
),
            SizedBox(height: 20),
            Text(
              nome,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
