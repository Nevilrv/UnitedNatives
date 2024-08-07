import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/utils.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/widgets/widget.dart';
import 'package:location/location.dart';

class GPSPicker extends StatefulWidget {
  final LocationData picked;

  const GPSPicker({Key key, this.picked}) : super(key: key);

  @override
  _GPSPickerState createState() {
    return _GPSPickerState();
  }
}

class _GPSPickerState extends State<GPSPicker> {
  var _initPosition = const CameraPosition(
    target: LatLng(37.3325932, -121.9129757),
    zoom: 16,
  );
  Map<MarkerId, Marker> _markers = {};
  GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    if (widget.picked != null) {
      _onSetMarker(
        latitude: widget.picked.latitude ?? 40.697403,
        longitude: widget.picked.longitude ?? -74.1201063,
      );
      _initPosition = CameraPosition(
        target: LatLng(widget.picked.latitude ?? 40.697403,
            widget.picked.longitude ?? -74.1201063),
        zoom: 16,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On Apply
  void _onApply() {
    if (_markers.values.isNotEmpty) {
      final position = _markers.values.first.position;
      final item = LocationData.fromMap({
        "longitude": position.longitude,
        "latitude": position.latitude,
      });
      Navigator.pop(context, item);
    }
  }

  ///On set marker
  void _onSetMarker({
    double latitude,
    double longitude,
  }) async {
    Map<MarkerId, Marker> markers = {};
    final markerId = MarkerId('$latitude-$longitude');
    final position = LatLng(latitude, longitude);
    final Marker marker = Marker(
      markerId: markerId,
      position: position,
      infoWindow: InfoWindow(title: '$latitude-$longitude'),
    );

    markers[markerId] = marker;
    setState(() {
      _markers = markers;
    });
    await Future.delayed(const Duration(milliseconds: 250));
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          tilt: 30.0,
          zoom: 15.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (widget.picked?.isMock != false) {
      actions = [
        AppButton(
          Translate.of(context).translate('apply'),
          onPressed: _onApply,
          type: ButtonType.text,
        )
      ];
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('location'),
        ),
        actions: actions,
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
        },
        initialCameraPosition: _initPosition,
        markers: Set<Marker>.of(_markers.values),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        // cameraTargetBounds: CameraTargetBounds(
        //   LatLngBounds(
        //     northeast: LatLng(widget.picked.latitude, widget.picked.longitude),
        //     southwest: LatLng(widget.picked.latitude, widget.picked.longitude),
        //   ),
        // ),
        onTap: (item) {
          if (widget.picked?.isMock != false) {
            _onSetMarker(
              latitude: item.latitude,
              longitude: item.longitude,
            );
          }
        },
      ),
    );
  }
}
