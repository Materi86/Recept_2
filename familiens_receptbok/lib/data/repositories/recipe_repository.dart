import 'package:familiens_receptbok/data/models/models.dart';
import 'package:isar/isar.dart';

class RecipeRepository {
  RecipeRepository(this._isar);

  final Isar _isar;

  Future<List<Recipe>> getAllRecipes() => _isar.recipes.where().findAll();

  Future<void> saveRecipe(Recipe recipe) => _isar.writeTxn(() => _isar.recipes.put(recipe));

  Future<void> deleteRecipe(int id) => _isar.writeTxn(() => _isar.recipes.delete(id));
}
