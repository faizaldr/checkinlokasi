import 'package:flutter/material.dart';

class Orang{
  var nama;
  var alamat;
  // Orang(this.nama, this.alamat);
  Orang({this.nama, this.alamat}); //kurung kurawal berarti parameter opsional
}

void main() {
  // new Orang("badu");
  new Orang(alamat: "jogja");
  runApp(
      new MaterialApp( //mengkonfigurasi di area sebuah aplikasi
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          )
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Page 1"),
          ),
          body: Container(),
        ), //home adalah default tampilan ketika pertama kali aplikasi dibuka
      )
  );
}
