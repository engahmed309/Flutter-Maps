import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.240768, 29.963070),
    zoom: 10.4746,
  );

  static const CameraPosition _musemposition = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(31.240768, 29.963070),
      tilt: 59.440717697143555,
      zoom: 15.151926040649414);
  static const CameraPosition _castlePosition = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(31.212330, 29.883490),
      tilt: 59.440717697143555,
      zoom: 15.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.3),
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        _changePosition(_musemposition);
                      },
                      icon: Icon(
                        Icons.museum,
                        color: Colors.black,
                      ),
                      label: Text("متحف المجوهرات الملكيه",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _changePosition(_castlePosition);
                      },
                      icon: Icon(
                        Icons.castle_rounded,
                        color: Colors.black,
                      ),
                      label: Text("قلعة قايتباي",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('متحف المجوهرات الملكيه'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _changePosition(CameraPosition myposition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(myposition));
  }
}
