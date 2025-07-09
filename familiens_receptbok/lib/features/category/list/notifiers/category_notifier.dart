import 'package:familiens_receptbok/data/models/models.dart';
import 'package:familiens_receptbok/data/repositories/repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryNotifier extends StateNotifier<AsyncValue<List<Category>>> {
  CategoryNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadCategories();
  }

  final CategoryRepository _repository;

  Future<void> _loadCategories() async {
    state = const AsyncValue.loading();
    try {
      final categories = await _repository.getAllCategories();
      state = AsyncValue.data(categories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addCategory(Category category) async {
    await _repository.saveCategory(category);
    _loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await _repository.deleteCategory(id);
    _loadCategories();
  }
}
