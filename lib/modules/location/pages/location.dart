import 'package:checkinlokasi/modules/location/data/location_api.dart';
import 'package:checkinlokasi/modules/location/models/location_response_model.dart';
import 'package:checkinlokasi/modules/location/pages/location_form.dart';
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => LocationFormPage()));
        },
      ),
      body: _locationResponse == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _locationResponse!.data!.length,
              itemBuilder: (context, index) {
                var data = _locationResponse!.data![index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            LocationFormPage(locationData: data),
                      ),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Hapus ${data.placeName} ?"),
                        actions: [
                          TextButton(
                            child: Text("Ya"),
                            onPressed: () async {
                              bool success = await LocationApi().deleteLocation(
                                data.documentId!,
                              );
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Lokasi berhasil dihapus"),
                                  ),
                                );
                                Navigator.of(context).pop(true);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Gagal hapus Lokasi")),
                                );
                              }
                            },
                          ),
                          TextButton(
                            child: Text("Tidak"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Card(
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
                  ),
                );
              },
            ),
    );
  }
}
