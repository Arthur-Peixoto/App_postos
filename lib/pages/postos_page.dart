import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/postos_repository.dart';

class PostosPage extends StatefulWidget {
  const PostosPage({Key? key}) : super(key: key);

  @override
  State<PostosPage> createState() => _PostosPageState();
}

class _PostosPageState extends State<PostosPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Postos Favoritados'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _getFavoritosStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar postos favoritados'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final favoritos = snapshot.data?.get('favoritos') as List<dynamic>?;

          if (favoritos == null || favoritos.isEmpty) {
            return Center(child: Text('Nenhum posto favoritado.'));
          }

          return ListView.builder(
            itemCount: favoritos.length,
            itemBuilder: (context, index) {
              return _buildPostoCard(favoritos[index]);
            },
          );
        },
      ),
    );
  }

  Stream<DocumentSnapshot> _getFavoritosStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.empty();
    }

    return _firestore.collection('users').doc(user.uid).snapshots();
  }

  Widget _buildPostoCard(String postoID) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('postos').doc(postoID).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return SizedBox.shrink(); // Posto não encontrado
        }

        final postoData = snapshot.data!.data() as Map<String, dynamic>;
        final posto = Posto(
          id: postoID,
          nome: postoData['nome'] ?? '',
          endereco: postoData['endereco'] ?? '',
          foto: postoData['foto'] ?? '',
          precoDiesel: postoData['precoDiesel'] ?? 0.0,
          precoGasolina: postoData['precoGasolina'] ?? 0.0,
          localizacao: GeoPoint(0.0, 0.0)
        );

        return _buildPostoCardUI(posto);
      },
    );
  }

  Widget _buildPostoCardUI(Posto posto) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Image.network(
            posto.foto,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  posto.nome,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  posto.endereco,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Preço do Diesel: ${posto.precoDiesel.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Preço da Gasolina: ${posto.precoGasolina.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
