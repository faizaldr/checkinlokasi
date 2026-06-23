import 'package:flutter/material.dart';

// deklarasi
String nama = 'Badu';
int usia = 12;

// tidak boleh deklarasi tanpa inisialisasi jika tidak nullable
// String alamat;

// bisa jika variable nullable :
String? alamat;
var a;

// bisa jika variable diassign sebagai late
// (telat meng-inisialisasi nilai):
late int nilai;

void main(){
  alamat="sidoarjo";
  //tidak boleh mengubah usia menjadi null karena bukan nullable
  // usia = null;

  a = 'lulus SD';
  a = 12;
  print(a.runtimeType); //melihat tipe data
  print('Hallo World, $nama ');
  print(alamat);
  nilai = 100;
  print(nilai);
}
