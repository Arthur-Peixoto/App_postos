import 'package:flutter/material.dart';
import 'package:google_map_tracker/models/posto.dart';

// ignore: must_be_immutable
class PostoDetalhes extends StatelessWidget {
  Posto posto;
  PostoDetalhes({Key? key, required this.posto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          Image.network(posto.foto,
              height: 250,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.only(top: 24, left: 24),
            child: Text(
              posto.nome,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 60, left: 24),
            child: Text(
              posto.endereco,
            ),
          ),
        ],
      ),
    );
  }
}