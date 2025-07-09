import 'package:isar/isar.dart';
import 'recipe.dart';

part 'category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value, unique: true)
  String? name;

  @Backlink(to: 'categories')
  final recipes = IsarLinks<Recipe>();
}
