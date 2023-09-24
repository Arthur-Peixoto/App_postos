import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String nome = '';
  String email = '';
  String userID = '';

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
          nome = userInfo['nome'] ?? 'Nome do Usuário';
        });
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
