import 'package:checkinlokasi/modules/location/pages/location_form.dart';
import 'package:checkinlokasi/modules/login/pages/login.dart';
import 'package:flutter/material.dart';

class Orang{
  var nama;
  var alamat;
  // Orang(this.nama, this.alamat);
  Orang({this.nama, this.alamat}); //kurung kurawal berarti parameter opsional
}

void main() {
  // new Orang("badu");
  Orang(alamat: "jogja");
  runApp(
    MyApp()
      // new MaterialApp( //mengkonfigurasi di area sebuah aplikasi
      //   theme: ThemeData(
      //     appBarTheme: AppBarTheme(
      //       backgroundColor: Colors.orange,
      //       foregroundColor: Colors.white,
      //     )
      //   ),
      //   home: Scaffold(
      //     appBar: AppBar(
      //       title: Text("Page 1"),
      //     ),
      //     body: Container(),
      //   ), //home adalah default tampilan ketika pertama kali aplikasi dibuka
      // )
  );
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp( //mengkonfigurasi di area sebuah aplikasi
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          )
      ),
      home: LocationFormPage()
      // Scaffold(
      //   appBar: AppBar(
      //     title: Text("Page 1"),
      //   ),
      //   body: Container(),
      // ), //home adalah default tampilan ketika pertama kali aplikasi dibuka
    );
  }

}