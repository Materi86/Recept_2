import 'package:familiens_receptbok/data/models/models.dart';
import 'package:familiens_receptbok/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageCategoriesPage extends ConsumerStatefulWidget {
  const ManageCategoriesPage({super.key});

  @override
  ConsumerState<ManageCategoriesPage> createState() => _ManageCategoriesPageState();
}

class _ManageCategoriesPageState extends ConsumerState<ManageCategoriesPage> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Hantera Kategorier')),
      body: categories.when(
        data: (categories) => ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              title: Text(category.name ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => ref.read(categoryNotifierProvider.notifier).deleteCategory(category.id),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Lägg till Kategori'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: 'Kategorinamn'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Avbryt'),
            ),
            TextButton(
              onPressed: () {
                final category = Category()..name = _textController.text;
                ref.read(categoryNotifierProvider.notifier).addCategory(category);
                _textController.clear();
                Navigator.pop(context);
              },
              child: const Text('Lägg till'),
            ),
          ],
        );
      },
    );
  }
}
