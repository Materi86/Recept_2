import 'package:familiens_receptbok/data/models/models.dart';
import 'package:familiens_receptbok/features/category/manage/view/manage_categories_page.dart';
import 'package:familiens_receptbok/features/recipe/add/view/add_recipe_page.dart';
import 'package:familiens_receptbok/features/recipe/detail/view/recipe_detail_page.dart';
import 'package:familiens_receptbok/features/recipe/list/widgets/recipe_card.dart';
import 'package:familiens_receptbok/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeListPage extends ConsumerWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipeNotifierProvider);
    final categoriesAsyncValue = ref.watch(categoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Familiens Recept'),
        actions: [
          categoriesAsyncValue.when(
            data: (categories) => DropdownButton<Category>(
              hint: const Text('Filtrera'),
              value: null, // Ingen vald kategori initialt
              onChanged: (category) {
                ref.read(recipeNotifierProvider.notifier).filterByCategory(category);
              },
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Visa alla'),
                ),
                ...categories.map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category.name ?? ''),
                  ),
                ),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (err, stack) => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ManageCategoriesPage()),
            ),
          ),
        ],
      ),
      body: recipes.when(
        data: (recipes) => recipes.isEmpty
            ? const Center(child: Text('Inga recept ännu'))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                padding: const EdgeInsets.all(8),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return RecipeCard(
                    recipe: recipe,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddRecipePage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
