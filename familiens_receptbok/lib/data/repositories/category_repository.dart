import 'package:familiens_receptbok/data/models/models.dart';
import 'package:isar/isar.dart';

class CategoryRepository {
  CategoryRepository(this._isar);

  final Isar _isar;

  Future<List<Category>> getAllCategories() => _isar.categorys.where().findAll();

  Future<void> saveCategory(Category category) => _isar.writeTxn(() => _isar.categorys.put(category));

  Future<void> deleteCategory(int id) => _isar.writeTxn(() => _isar.categorys.delete(id));
}
