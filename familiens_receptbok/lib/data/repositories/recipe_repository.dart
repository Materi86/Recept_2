import 'package:familiens_receptbok/data/models/models.dart';
import 'package:isar/isar.dart';

class RecipeRepository {
  RecipeRepository(this._isar);

  final Isar _isar;

  Future<List<Recipe>> getAllRecipes() => _isar.recipes.where().findAll();
  
  Future<List<Recipe>> getFavoriteRecipes() => _isar.recipes.where().isFavoriteEqualTo(true).findAll();
  
  Future<List<Recipe>> searchRecipes(String query) {
    final lowerQuery = query.toLowerCase();
    return _isar.recipes.where().filter()
        .titleContains(lowerQuery, caseSensitive: false)
        .or()
        .ingredientsContains(lowerQuery, caseSensitive: false)
        .or()
        .instructionsContains(lowerQuery, caseSensitive: false)
        .findAll();
  }
  
  Future<List<Recipe>> getRecipesByRating({double minRating = 0.0}) => 
      _isar.recipes.where().ratingGreaterThan(minRating - 0.1).sortByRatingDesc().findAll();

  Future<void> saveRecipe(Recipe recipe) => _isar.writeTxn(() => _isar.recipes.put(recipe));
  
  Future<void> toggleFavorite(int recipeId) async {
    await _isar.writeTxn(() async {
      final recipe = await _isar.recipes.get(recipeId);
      if (recipe != null) {
        recipe.isFavorite = !recipe.isFavorite;
        recipe.updatedAt = DateTime.now();
        await _isar.recipes.put(recipe);
      }
    });
  }
  
  Future<void> updateRating(int recipeId, double newRating) async {
    await _isar.writeTxn(() async {
      final recipe = await _isar.recipes.get(recipeId);
      if (recipe != null) {
        // Simple rating system - replace current rating
        recipe.rating = newRating;
        recipe.ratingCount = 1; // For simplicity, just track that it's been rated
        recipe.updatedAt = DateTime.now();
        await _isar.recipes.put(recipe);
      }
    });
  }

  Future<void> deleteRecipe(int id) => _isar.writeTxn(() => _isar.recipes.delete(id));
}
