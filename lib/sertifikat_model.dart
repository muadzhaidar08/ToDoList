class Certificate {
  final String title;
  final String issuer;
  final String date;
  final String? imageUrl; 
  final String? credentialUrl; 

  Certificate({
    required this.title,
    required this.issuer,
    required this.date,
    this.imageUrl,
    this.credentialUrl,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      title: json['title'] ?? 'Tanpa Judul',
      issuer: json['issuer'] ?? 'Penerbit Tidak Diketahui',
      date: json['date'] ?? 'Tanggal Tidak Diketahui',
      imageUrl: json['image_url'], 
      credentialUrl: json['credential_url'], 
    );
  }
}