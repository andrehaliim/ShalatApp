class ShalatModel {
  String id;
  String lokasi;
  String daerah;
  KoordinatModel koordinat;
  JadwalModel jadwal;

  ShalatModel({
    required this.id,
    required this.lokasi,
    required this.daerah,
    required this.koordinat,
    required this.jadwal,
  });

  factory ShalatModel.fromJson(Map<String, dynamic> json) {
    return ShalatModel(
      id: json['id'],
      lokasi: json['lokasi'],
      daerah: json['daerah'],
      koordinat: KoordinatModel.fromJson(json['koordinat']),
      jadwal: JadwalModel.fromJson(json['jadwal']),
    );
  }
}

class KoordinatModel {
  double lat;
  double lon;
  String lintang;
  String bujur;

  KoordinatModel({
    required this.lat,
    required this.lon,
    required this.lintang,
    required this.bujur,
  });

  factory KoordinatModel.fromJson(Map<String, dynamic> json) {
    return KoordinatModel(
      lat: json['lat'],
      lon: json['lon'],
      lintang: json['lintang'],
      bujur: json['bujur'],
    );
  }
}

class JadwalModel {
 String tanggal;
 String imsak;
 String subuh;
 String terbit;
 String dhuha;
 String dzuhur;
 String ashar;
 String maghrib;
 String isya;
 String date;

  JadwalModel({
    required this.tanggal,
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dhuha,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
    required this.date,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      tanggal: json['tanggal'],
      imsak: json['imsak'],
      subuh: json['subuh'],
      terbit: json['terbit'],
      dhuha: json['dhuha'],
      dzuhur: json['dzuhur'],
      ashar: json['ashar'],
      maghrib: json['maghrib'],
      isya: json['isya'],
      date: json['date'],
    );
  }
}
