import 'package:familiens_receptbok/data/models/models.dart';
import 'package:familiens_receptbok/data/repositories/repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RecipeFilter { all, favorites, highRated }
enum RecipeSortBy { newest, oldest, rating, alphabetical }

class RecipeNotifier extends StateNotifier<AsyncValue<List<Recipe>>> {
  RecipeNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadRecipes();
  }

  final RecipeRepository _repository;
  Category? _selectedCategory;
  String _searchQuery = '';
  RecipeFilter _currentFilter = RecipeFilter.all;
  RecipeSortBy _sortBy = RecipeSortBy.newest;

  Future<void> _loadRecipes() async {
    state = const AsyncValue.loading();
    try {
      List<Recipe> recipes;
      
      // Apply filter first
      switch (_currentFilter) {
        case RecipeFilter.favorites:
          recipes = await _repository.getFavoriteRecipes();
          break;
        case RecipeFilter.highRated:
          recipes = await _repository.getRecipesByRating(minRating: 4.0);
          break;
        case RecipeFilter.all:
        default:
          recipes = await _repository.getAllRecipes();
          break;
      }
      
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final searchResults = await _repository.searchRecipes(_searchQuery);
        recipes = recipes.where((recipe) => 
          searchResults.any((searchRecipe) => searchRecipe.id == recipe.id)
        ).toList();
      }
      
      // Apply category filter
      if (_selectedCategory != null) {
        recipes = recipes.where((recipe) => 
          recipe.categories.any((cat) => cat.id == _selectedCategory!.id)
        ).toList();
      }
      
      // Apply sorting
      _sortRecipes(recipes);
      
      state = AsyncValue.data(recipes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  void _sortRecipes(List<Recipe> recipes) {
    switch (_sortBy) {
      case RecipeSortBy.newest:
        recipes.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
        break;
      case RecipeSortBy.oldest:
        recipes.sort((a, b) => (a.createdAt ?? DateTime(0)).compareTo(b.createdAt ?? DateTime(0)));
        break;
      case RecipeSortBy.rating:
        recipes.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case RecipeSortBy.alphabetical:
        recipes.sort((a, b) => (a.title ?? '').compareTo(b.title ?? ''));
        break;
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
  
  Future<void> toggleFavorite(int recipeId) async {
    await _repository.toggleFavorite(recipeId);
    _loadRecipes();
  }
  
  Future<void> updateRating(int recipeId, double rating) async {
    await _repository.updateRating(recipeId, rating);
    _loadRecipes();
  }

  void filterByCategory(Category? category) {
    _selectedCategory = category;
    _loadRecipes();
  }
  
  void search(String query) {
    _searchQuery = query;
    _loadRecipes();
  }
  
  void setFilter(RecipeFilter filter) {
    _currentFilter = filter;
    _loadRecipes();
  }
  
  void setSortBy(RecipeSortBy sortBy) {
    _sortBy = sortBy;
    _loadRecipes();
  }
  
  void clearSearch() {
    _searchQuery = '';
    _loadRecipes();
  }
  
  // Getters for current state
  String get currentSearchQuery => _searchQuery;
  RecipeFilter get currentFilter => _currentFilter;
  RecipeSortBy get currentSortBy => _sortBy;
  Category? get selectedCategory => _selectedCategory;
}
