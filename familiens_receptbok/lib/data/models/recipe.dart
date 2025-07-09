import 'package:isar/isar.dart';
import 'category.dart';

part 'recipe.g.dart';

@collection
class Recipe {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  String? title;

  String? ingredients;
  String? instructions;
  String? imagePath;

  @Index()
  bool isFavorite = false;
  
  @Index()
  double rating = 0.0; // 0-5 stars
  
  int ratingCount = 0; // Number of ratings given

  DateTime? createdAt;
  DateTime? updatedAt;

  final categories = IsarLinks<Category>();
}
