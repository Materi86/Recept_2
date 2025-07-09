import 'package:familiens_receptbok/data/models/models.dart';
import 'package:familiens_receptbok/data/repositories/repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeNotifier extends StateNotifier<AsyncValue<List<Recipe>>> {
  RecipeNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadRecipes();
  }

  final RecipeRepository _repository;
  Category? _selectedCategory;

  Future<void> _loadRecipes() async {
    state = const AsyncValue.loading();
    try {
      var recipes = await _repository.getAllRecipes();
      if (_selectedCategory != null) {
        recipes = recipes.where((recipe) => recipe.categories.any((cat) => cat.id == _selectedCategory!.id)).toList();
      }
      state = AsyncValue.data(recipes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _repository.saveRecipe(recipe);
    _loadRecipes();
  }

  Future<void> deleteRecipe(int id) async {
    await _repository.deleteRecipe(id);
    _loadRecipes();
  }

  void filterByCategory(Category? category) {
    _selectedCategory = category;
    _loadRecipes();
  }
}
