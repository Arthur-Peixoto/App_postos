import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_tracker/widgets/postos_detalhes.dart';
import '../models/postos_repository.dart';

class PostosController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String erro = '';
  Set<Marker> markers = Set<Marker>();
  late GoogleMapController _mapsController;
  BuildContext? context;
  PostosRepository _postosRepository = PostosRepository();

  setContext(BuildContext ctx) {
    context = ctx;
  }

  void setMapsController(GoogleMapController controller) {
    _mapsController = controller;
  }

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();
    loadPostosFromFirebase();
  }

  loadPostosFromFirebase() async {
    final postos = await _postosRepository
        .getPostosFromFirebase(); // Use await para obter os postos
    markers.clear(); // Limpe os marcadores antes de adicionar os novos

    for (final posto in postos) {
      markers.add(
        Marker(
          markerId: MarkerId(posto.nome),
          position:
              LatLng(posto.localizacao.latitude, posto.localizacao.longitude),
              icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(),
            'images/posto-icon.png',
          ),
          onTap: () => {
            showModalBottomSheet(
              context: context!,
              builder: (context) => PostoDetalhes(posto: posto),
            )
          },
        ),
      );
    }
    notifyListeners();
  }

  getPosicao() async {
    try {
      Position posicao = await _posicaoAtual();
      lat = posicao.latitude;
      long = posicao.longitude;
      _mapsController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    } catch (e) {
      erro = e.toString();
    }
    notifyListeners();
  }

  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;

    bool ativado = await Geolocator.isLocationServiceEnabled();
    if (!ativado) {
      return Future.error('Por favor, habilite a localização no smartphone');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Você precisa autorizar o acesso à localização');
    }

    return await Geolocator.getCurrentPosition();
  }
}
