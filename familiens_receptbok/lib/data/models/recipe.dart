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

  DateTime? createdAt;
  DateTime? updatedAt;

  final categories = IsarLinks<Category>();
}
