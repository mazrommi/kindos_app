class Catatan {
  final int? id;
  final String judul;
  final String deskripsi;
  final String tanggal;
  final String kategori; // ✅ tambah ini

  Catatan({
    this.id,
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
    required this.kategori, // ✅
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': tanggal,
      'kategori': kategori, // ✅
    };
  }

  factory Catatan.fromMap(Map<String, dynamic> map) {
    return Catatan(
      id: map['id'],
      judul: map['judul'],
      deskripsi: map['deskripsi'],
      tanggal: map['tanggal'],
      kategori: map['kategori'], // ✅
    );
  }
}
