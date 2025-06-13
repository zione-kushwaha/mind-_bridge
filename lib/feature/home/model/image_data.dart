import 'review.dart';

class imageData {
  final String name;
  final String urlImage;
  final String? description;
  final String? emoji;
  final int? recommendedAge;
  final List<String>? skills;

  imageData({
    required this.name,
    required this.urlImage,
    this.description,
    this.emoji,
    this.recommendedAge,
    this.skills,
  });
}
