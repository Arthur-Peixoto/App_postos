import 'package:cloud_firestore/cloud_firestore.dart';

class Posto {
  final String nome;
  final GeoPoint localizacao;
  final String endereco;
  final String foto;
  final double precoDiesel;
  final double precoGasolina;

  Posto({
    required this.nome,
    required this.localizacao,
    required this.endereco,
    required this.foto,
    required this.precoDiesel,
    required this.precoGasolina,
  });
}

class PostosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Posto>> getPostosFromFirebase() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('postos').get();
      final List<Posto> postos = [];

      for (final QueryDocumentSnapshot document in querySnapshot.docs) {
        final data = document.data() as Map<String, dynamic>;
        final posto = Posto(
          nome: data['name'] ?? '',
          localizacao: data['localizacao'] ?? GeoPoint(0.0, 0.0),
          endereco: data['endereco'] ?? '',
          foto: data['foto'] ?? '',
          precoDiesel: data['precoDiesel'] ?? 0.0,
          precoGasolina: data['precoGasolina'] ?? 0.0,
        );

        postos.add(posto);
      }

      return postos;
    } catch (e) {
      print('Erro ao buscar postos: $e');
      return [];
    }
  }
}
