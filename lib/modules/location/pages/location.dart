import 'package:checkinlokasi/modules/location/data/location_api.dart';
import 'package:checkinlokasi/modules/location/models/location_response_model.dart';
import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationPageState();
  }
}

class _LocationPageState extends State<LocationPage> {
  LocationResponse? _locationResponse;

  @override
  void initState() {
    super.initState();
    _initLocationResponse();
  }

  _initLocationResponse() async {
    _locationResponse = await LocationApi().getLocations();
    setState(() {
      _locationResponse = _locationResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lokasi")),
      body: _locationResponse == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _locationResponse!.data!.length,
              itemBuilder: (context, index) {
                var data = _locationResponse!.data![index];
                return Card(
                  child: Column(
                    children: [
                      Text(
                        "${data.placeName!} (${data.placeType!})",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(data.comment!),
                      Text(
                        "${data.latitude!} , ${data.longitude!}",
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
