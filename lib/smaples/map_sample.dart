import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_maps/screens/home_screen.dart';
import 'package:geolocator/geolocator.dart';
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
  // List<DropdownMenuItem> dropDownPlaces = [
  //   DropdownMenuItem(child: Text("متحف المجوهرات الملكية")),
  //   DropdownMenuItem(child: Text("قلعة قايتباي")),
  //   DropdownMenuItem(child: Text("المتحف المصري"))
  //];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Set<Marker> markers = {};
  late GoogleMapController googleMapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black.withOpacity(.5),
          title: Text(
            "Places Helper",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        drawer: SafeArea(
          child: Drawer(
            backgroundColor: Colors.black54,
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(10),
                    ),
                    child: Image.network(
                      "https://www.vetogate.com/UploadCache/libfiles/442/8/600x338o/716.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    color: Colors.black.withOpacity(.0),
                    elevation: 6,
                    child: InkWell(
                      onTap: () {
                        _changePosition(_castlePosition);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(7),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            Icon(Icons.castle,
                                color: Color.fromARGB(255, 255, 119, 0)),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Fort Qaitbey",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "قلعة قايتباي",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.black.withOpacity(.0),
                    elevation: 6,
                    child: InkWell(
                      onTap: () {
                        _changePosition(_musemposition);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(7),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            Icon(Icons.museum,
                                color: Color.fromARGB(255, 255, 119, 0)),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                Text(
                                  "Royal Jewelry Museum",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "متحف المجوهرات الملكية",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
          ),
        ),
        body: GoogleMap(
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);

            googleMapController = controller;
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            Position position = await _determinePosition();

            googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 14)));

            markers.clear();

            markers.add(Marker(
                markerId: const MarkerId('currentLocation'),
                position: LatLng(position.latitude, position.longitude)));

            setState(() {});
          },
          label: const Text("Current Location"),
          icon: const Icon(Icons.location_history),
        ));
  }

  Future<void> _changePosition(CameraPosition myposition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(myposition));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
