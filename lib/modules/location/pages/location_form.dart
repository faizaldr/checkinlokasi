// ubah main.dart -> home: LocationFormPage()
import 'dart:async';

import 'package:checkinlokasi/modules/location/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../models/location_response_model.dart';

class LocationFormPage extends StatefulWidget {
  final Data? locationData;

  const LocationFormPage({super.key, this.locationData});

  @override
  State<StatefulWidget> createState() {
    return _LocationFormPageState();
  }
}

class _LocationFormPageState extends State<LocationFormPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _placeNameC = TextEditingController();
  TextEditingController _placeTypeC = TextEditingController();
  TextEditingController _commentC = TextEditingController();
  TextEditingController _latitudeC = TextEditingController();
  TextEditingController _longitudeC = TextEditingController();
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _placeNameC.text = widget.locationData?.placeName ?? '';
    _placeTypeC.text = widget.locationData?.placeType ?? '';
    _commentC.text = widget.locationData?.comment ?? '';
    _latitudeC.text = widget.locationData?.latitude.toString() ?? '';
    _longitudeC.text = widget.locationData?.longitude.toString() ?? '';
    _getCurrentLocation(); //mendapatkan lokasi
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationService = LocationService();
      final hasPermission = await locationService.requestPermission();
      if (hasPermission && mounted) {
        _locationSubscription = locationService.locationStream.listen((
          locData,
        ) {
          if (mounted) {
            setState(() {
              _latitudeC.text = locData.latitude?.toString() ?? '';
              _longitudeC.text = locData.longitude?.toString() ?? '';
            });
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
  bool get _isEdit => widget.locationData != null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? "Edit Lokasi" : "Tambah Lokasi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _placeNameC,
                decoration: InputDecoration(
                  labelText: "Nama Lokasi",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
