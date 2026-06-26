// ubah main.dart -> home: LocationFormPage()
import 'dart:async';

import 'package:checkinlokasi/modules/location/data/location_api.dart';
import 'package:checkinlokasi/modules/location/pages/liveness_page.dart';
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
              TextFormField(
                controller: _placeTypeC,
                decoration: InputDecoration(
                  labelText: "Tipe Lokasi",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _commentC,
                decoration: InputDecoration(
                  labelText: "Komentar",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _latitudeC,
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Latitude",
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _longitudeC,
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Longitude",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isEdit ? "SIMPAN PERUBAHAN" : "TAMBAH LOKASI"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submit() async {

    final bool? livenessSuccess = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LivenessPage(),
      ),
    );

    if (livenessSuccess != true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menyimpan lokasi: Verifikasi Wajah gagal.")),
        );
      }
      return;
    }

    final placeName = _placeNameC.text.trim();
    final placeType = _placeTypeC.text.trim();
    final comment = _commentC.text.trim();
    final latitude = double.tryParse(_latitudeC.text.trim()) ?? 0.0;
    final longitude = double.tryParse(_longitudeC.text.trim()) ?? 0.0;
    bool success = false;
    if (!_isEdit) {
      success = await LocationApi().addLocation(
        placeName: placeName,
        placeType: placeType,
        comment: comment,
        latitude: latitude,
        longitude: longitude,
      );
    }else{
      success = await LocationApi().updateLocation(
        id: widget.locationData!.documentId!,
        placeName: placeName,
        placeType: placeType,
        comment: comment,
        latitude: latitude,
        longitude: longitude,
      );
    }
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEdit
                ? "Lokasi berhasil diperbarui"
                : "Lokasi berhasil ditambahkan",
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal Menyimpan Lokasi")));
    }
  }
}
