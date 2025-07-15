import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isFavorite;

  const Movie({
    required this.id,
    required this.title,
    required this.description,
    this.isFavorite = false,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFavorite,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Movie &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        isFavorite.hashCode;
  }

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, description: $description, isFavorite: $isFavorite)';
  }
}