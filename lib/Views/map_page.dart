import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' ;

import 'package:location/location.dart';

import 'package:permission_handler/permission_handler.dart' as perm;

import '../controller/data_controller.dart';


class MapPage extends StatefulWidget {


  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();


}

class _MapPageState extends State<MapPage> {
  Location _locationController = new Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  DataController dataController = Get.find<DataController>();
  LatLng? _startLocation;
  LatLng? _eventlocation = LatLng(6.9271, 79.8612);
  LatLng? _eventlocation2 = LatLng(6.8464,79.9484);

  LatLng? _stopLocation;
  LatLng? _currentP;
  double _distance = 0.0;

  Map<PolylineId, Polyline> polylines = {};
  // Declare a BitmapDescriptor for the custom bus icon
  BitmapDescriptor ?customBusIcon;
  @override
  void initState() {
    super.initState();
    if (true) {
      // Start tracking logic
      startTracking();


    }
  }

  // Function to convert place names to LatLng coordinates
  Future<LatLng?> getLatLngFromPlaceName(String placeName) async {
    try {
      List<geocoding.Location> locations = await geocoding.locationFromAddress(placeName);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print('Error geocoding place name: $e');
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    double halfScreenHeight = MediaQuery.of(context).size.height ;




    return Scaffold(
      body: _currentP == null
          ? const Center(child: Text("Loading"))
          : Stack(
        children: [
          Container(
            height: halfScreenHeight,
            child: GoogleMap(
              onMapCreated: ((GoogleMapController controller) => _mapController.complete(controller)),
              initialCameraPosition: CameraPosition(target: _currentP!, zoom: 15),
              markers: {
                if (_currentP != null)
                  Marker(
                    markerId: MarkerId('_current_location'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                    position: _currentP!,
                  ),
                if (_eventlocation != null)
                  Marker(
                    markerId: MarkerId('event location1:'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _eventlocation!,
                  ),
                if (_eventlocation2 != null)
                  Marker(
                    markerId: MarkerId('event location2:'),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _eventlocation2!,
                  ),


              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white, // Background color for the text
              child: Center(

              ),
            ),
          ),

        ],
      ),
    );
  }



  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }
    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          if (_startLocation == null) {
            // Set start location when tracking starts
            _startLocation = _currentP;
          }
          if (_startLocation != null) {
            // Calculate distance when tracking is started
            _distance = calculateDistance(_startLocation!, _currentP!);
          }
          _cameraToPosition(_currentP!);
        });
      }
    });
  }

  Future<List<LatLng>> getPolyLinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyA1XA93ry5Cpb726iWzpd6ibIHqolIymQE",
        PointLatLng(_startLocation!.latitude, _startLocation!.longitude),
        PointLatLng(_stopLocation!.latitude, _stopLocation!.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLinesFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(polylineId: id, color: Colors.black, points: polylineCoordinates, width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }

  void startTracking() {
    getLocationUpdates().then((_) {
      setState(() {});
    });
  }

  void stopTracking() {
    // Calculate distance when tracking is stopped
    if (_startLocation != null) {
      _stopLocation = _currentP;
      _distance = calculateDistance(_startLocation!, _stopLocation!);
    }
    // Generate polyline for the tracked route
    getPolyLinePoints().then((coordinates) {
      generatePolyLinesFromPoints(coordinates);
    });
    setState(() {});
  }

  double calculateDistance(LatLng start, LatLng stop) {
    const double earthRadius = 6371000; // Earth's radius in meters

    double lat1 = start.latitude;
    double lon1 = start.longitude;
    double lat2 = stop.latitude;
    double lon2 = stop.longitude;

    // Convert latitude and longitude from degrees to radians manually
    lat1 = lat1 * (pi / 180.0);
    lon1 = lon1 * (pi / 180.0);
    lat2 = lat2 * (pi / 180.0);
    lon2 = lon2 * (pi / 180.0);

    // Check if start and stop locations are different
    if (lat1 != lat2 || lon1 != lon2) {
      print('Start location: $lat1, $lon1');
      print('Stop location: $lat2, $lon2');
    } else {

    }

    // Haversine formula
    double dlon = lon2 - lon1;
    double dlat = lat2 - lat1;
    double a = pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }


  void _stopTracking() {
    stopTracking();
    if (_startLocation != null && _stopLocation != null) {
      _stopLocation = _currentP;
      _distance = calculateDistance(_startLocation!, _stopLocation!);
    }
    setState(() {});


  }


}
