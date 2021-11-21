import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mutoni/global.dart';
import 'dart:async';

import 'package:mutoni/model/riviere.dart';

class MapSample extends StatefulWidget {
  Riviere riviere;

  MapSample(this.riviere);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  late CameraPosition _kGooglePlex;

  late CameraPosition riv;

  late Position position;


  pos() async{
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    riv = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.4746,
    );

    setState(() {
      _kGooglePlex = riv;
    });
    _add(position, 'Ma Position', BitmapDescriptor.hueGreen);

    if(widget.riviere.name != 'name'){
      print('belhanda');
      _add(LatLng(widget.riviere.latitude, widget.riviere.longitude), '${widget.riviere.name}', 
      BitmapDescriptor.hueCyan);

      LatLngBounds bound = LatLngBounds(
        southwest: LatLng(position.latitude, position.longitude), 
        northeast: LatLng(widget.riviere.latitude, widget.riviere.longitude));

      CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
      
      setState(() {
        _kGooglePlex = CameraPosition(
          target: LatLng(widget.riviere.latitude, widget.riviere.longitude),
          zoom: 14.4746,
        );
      });
    }
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

void _add(pos, String title, descriptor) {
    final MarkerId markerId = MarkerId(uuid.v1());

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        pos.latitude,
        pos.longitude,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(descriptor),
      infoWindow: InfoWindow(title: '${title}', snippet: '*'),
      onTap: () {
      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pos();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}