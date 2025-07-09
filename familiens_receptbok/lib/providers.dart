import 'package:familiens_receptbok/data/models/models.dart';
import 'package:familiens_receptbok/data/repositories/repositories.dart';
import 'package:familiens_receptbok/features/recipe/list/notifiers/recipe_notifier.dart';
import 'package:familiens_receptbok/features/category/list/notifiers/category_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [RecipeSchema, CategorySchema],
    directory: dir.path,
  );
});

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final isar = ref.watch(isarProvider).value!;
  return RecipeRepository(isar);
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final isar = ref.watch(isarProvider).value!;
  return CategoryRepository(isar);
});

final recipeNotifierProvider = StateNotifierProvider<RecipeNotifier, AsyncValue<List<Recipe>>>((ref) {
  final repository = ref.watch(recipeRepositoryProvider);
  return RecipeNotifier(repository);
});

final categoryNotifierProvider = StateNotifierProvider<CategoryNotifier, AsyncValue<List<Category>>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryNotifier(repository);
});
