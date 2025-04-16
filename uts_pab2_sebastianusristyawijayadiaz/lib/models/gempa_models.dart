class Gempa {
  final String tanggal;
  final String jam;
  final String dateTime;
  final String coordinates;
  final String lintang;
  final String bujur;
  final String magnitude;
  final String kedalaman;
  final String wilayah;
  final String potensi;
  final String dirasakan;
  final String shakemap;

  Gempa({
    required this.tanggal,
    required this.jam,
    required this.dateTime,
    required this.coordinates,
    required this.lintang,
    required this.bujur,
    required this.magnitude,
    required this.kedalaman,
    required this.wilayah,
    required this.potensi,
    required this.dirasakan,
    required this.shakemap,
  });

  factory Gempa.fromJson(Map<String, dynamic> json) {
    final gempa = json['Infogempa']['gempa'];
    return Gempa(
      tanggal: gempa['Tanggal'],
      jam: gempa['Jam'],
      dateTime: gempa['DateTime'],
      coordinates: gempa['Coordinates'],
      lintang: gempa['Lintang'],
      bujur: gempa['Bujur'],
      magnitude: gempa['Magnitude'],
      kedalaman: gempa['Kedalaman'],
      wilayah: gempa['Wilayah'],
      potensi: gempa['Potensi'],
      dirasakan: gempa['Dirasakan'],
      shakemap: gempa['Shakemap'],
    );
  }
}
