class Project {
  final String judul;
  final String deskripsi;
  final String linkProject;
  final String namaIcon;

  Project({
    required this.judul,
    required this.deskripsi,
    required this.linkProject,
    required this.namaIcon,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      judul: json['title'] ?? 'tanpa judul',
      deskripsi: json['description'] ?? 'tanpa deskripsi',
      linkProject: json['project_url'] ?? 'github.com',
      namaIcon: json['icon_name'] ?? 'default',
    );
  }
}