import 'package:flutter/material.dart';

class PostosPage extends StatefulWidget {
  const PostosPage({Key? key}) : super(key: key);

  @override
  State<PostosPage> createState() => _PostosPageState();
}

class _PostosPageState extends State<PostosPage> {
  // Exemplo de uma lista de postos favoritados (você deve substituir isso pelos seus dados reais)
  final List<String> postosFavoritados = [
    'Posto A',
    'Posto B',
    'Posto C',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Postos Favoritados'),
      ),
      body: ListView.builder(
        itemCount: postosFavoritados.length,
        itemBuilder: (context, index) {
          final posto = postosFavoritados[index];
          return ListTile(
            title: Text(posto),
            // Personalize este ListTile para exibir informações detalhadas do posto, se necessário.
          );
        },
      ),
    );
  }
}
