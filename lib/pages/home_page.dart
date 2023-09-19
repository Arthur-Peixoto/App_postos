import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_map_tracker/controllers/postos_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  int _currentIndex = 0; // Índice atual da BottomNavigationBar

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    _cameraPosition = CameraPosition(
      target: LatLng(
        context.read<PostosController>().lat,
        context.read<PostosController>().long,
      ),
      zoom: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<PostosController>(
        create: (context) => PostosController(),
        child: Builder(builder: (context) {
          return _buildBody();
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Aqui você pode adicionar a lógica para navegar para diferentes páginas com base no índice selecionado.
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_gas_station),
            label: 'Postos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return _getMap();
  }

  Widget _getMap() {
    return Consumer<PostosController>(
      builder: (context, local, child) {
        return GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          myLocationEnabled: true,
          markers: local.markers,
          onMapCreated: (GoogleMapController controller) async {
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
            local.setMapsController(controller);
            local.getPosicao();
            local.loadPostos();
          },
        );
      },
    );
  }
}