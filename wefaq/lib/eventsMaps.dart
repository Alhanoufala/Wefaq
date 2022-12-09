import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:wefaq/screens/detail_screens/event_detail_screen.dart';

class MapSampleEvents extends StatefulWidget {
  @override
  State<MapSampleEvents> createState() => MapSampleState();
}

class MapSampleState extends State<MapSampleEvents> {
  Completer<GoogleMapController> _controller = Completer();

  late LatLng currentLatLng = const LatLng(48.8566, 2.3522);

  @override
  void initState() {
    _goToCurrentLocation();
    getMarkers();
    String apiKey = 'AIzaSyCkRaPfvVejBlQIAWEjc9klnkqk6olnhuc';
    googlePlace = GooglePlace(apiKey);

    super.initState();
  }

  final _firestore = FirebaseFirestore.instance;
  List<Marker> markers = [];
  static final TextEditingController _startSearchFieldController =
      TextEditingController();

  DetailsResult? startPosition;

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  } //permission

  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
    });
    return;
  }

  Future<void> _goToCurrentLocation() async {
    await _determinePosition();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLatLng, zoom: 15)));
  }

  //get markers
  Future getMarkers() async {
    await for (var snapshot in _firestore.collection('AllEvent').snapshots())
      for (var project in snapshot.docs) {
        setState(() {
          markers.add(new Marker(
            markerId: MarkerId(project['name']),
            position: new LatLng(project['lat'], project['lng']),
            infoWindow: InfoWindow(
                title: project['name'],
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => eventDetailScreen(
                                eventName: project['name'],
                              )));
                }),
          ));
        });
      }
  }

  changeLocation() async {
    final GoogleMapController controller = await _controller.future;
    double? lat = startPosition?.geometry?.location?.lat;
    double? lng = startPosition?.geometry?.location?.lng;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat!, lng!), zoom: 14)));
    _startSearchFieldController.clear();
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCurrentLocation,
        label: const Text('Current location'),
        icon: const Icon(Icons.location_searching,
            color: Color.fromARGB(221, 137, 171, 187)),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 2, left: 1, right: 1),
            child: TextFormField(
              controller: _startSearchFieldController,
              decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 202, 198, 198)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87, width: 2.0),
                  ),
                  suffixIcon: _startSearchFieldController.text.isEmpty
                      ? Icon(Icons.search,
                          color: Color.fromARGB(221, 137, 171, 187))
                      : IconButton(
                          icon: Icon(Icons.search,
                              color: Color.fromARGB(221, 137, 171, 187)),
                          onPressed: () {
                            changeLocation();
                          },
                        )),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 1000), () {
                  if (value.isNotEmpty) {
                    //places api
                    autoCompleteSearch(value);
                  } else {
                    //clear out the results
                    setState(() {
                      predictions = [];
                      startPosition = null;
                    });
                  }
                });
              },
            ),
          ),
          Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromARGB(221, 137, 171, 187),
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      predictions[index].description.toString(),
                    ),
                    onTap: () async {
                      final placeId = predictions[index].placeId!;
                      final details = await googlePlace.details.get(placeId);
                      if (details != null &&
                          details.result != null &&
                          mounted) {
                        setState(() {
                          startPosition = details.result;
                          _startSearchFieldController.text =
                              details.result!.name!;

                          predictions = [];
                        });
                      }
                    },
                  );
                }),
          ),
          Expanded(
            child: GoogleMap(
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
              mapType: MapType.normal,
              markers: markers.toSet(),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              initialCameraPosition:
                  CameraPosition(target: currentLatLng, zoom: 14),
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),
        ],
      ),
    );
  }
}
