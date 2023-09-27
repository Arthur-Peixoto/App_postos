import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/postos_repository.dart';

// Adicionar um posto como favorito para o usuário atual
Future<void> addPostToFavorites(String userID, String postoID) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(userID);

  // Use o método FieldValue.arrayUnion para adicionar o posto ao campo "favoritos"
  await userDoc.update({
    'favoritos': FieldValue.arrayUnion([postoID]),
  });
}

// Remover um posto dos favoritos do usuário atual
Future<void> removePostFromFavorites(String userID, String postoID) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(userID);

  // Use o método FieldValue.arrayRemove para remover o posto do campo "favoritos"
  await userDoc.update({
    'favoritos': FieldValue.arrayRemove([postoID]),
  });
}
class PostoDetalhes extends StatefulWidget {
  final Posto posto;

  PostoDetalhes({Key? key, required this.posto}) : super(key: key);

  @override
  _PostoDetalhesState createState() => _PostoDetalhesState();
}

class _PostoDetalhesState extends State<PostoDetalhes> {
  bool isFavorito = false; // Inicialmente, o posto não está favoritado.

  void toggleFavorito() {
    setState(() {
      isFavorito = !isFavorito; // Alternar entre favoritar e desfavoritar.
      if (isFavorito) {
        // Se está favoritado, adicione o posto aos favoritos.
        addPostToFavorites(_getUserID(), widget.posto.id);
      } else {
        // Se não está favoritado, remova o posto dos favoritos.
        removePostFromFavorites(_getUserID(), widget.posto.id);
      }
    });
  }

  // Função para obter o ID do usuário atual
  String _getUserID() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return '';
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          Image.network(
            widget.posto.foto,
            height: 250,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(top: 24, left: 24),
            child: Row(
              children: [
                Text(
                  widget.posto.nome,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: (){toggleFavorito();},
                  icon: Icon(
                    isFavorito ? Icons.favorite : Icons.favorite_border,
                    color: isFavorito ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 60, left: 24),
            child: Text(
              widget.posto.endereco,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 60, left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preço do Diesel: ${widget.posto.precoDiesel}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Preço da Gasolina: ${widget.posto.precoGasolina}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
