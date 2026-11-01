/// Model sederhana untuk menyimpan data profil anak
/// selama proses pengisian multi-langkah (Add Profile flow).
class ChildProfile {
  final String name;
  final String gender; // 'laki-laki' | 'perempuan'
  final DateTime dateOfBirth;
  final String? photoPath; // null berarti belum dipilih

  const ChildProfile({
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    this.photoPath,
  });

  ChildProfile copyWith({
    String? name,
    String? gender,
    DateTime? dateOfBirth,
    String? photoPath,
  }) {
    return ChildProfile(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}
