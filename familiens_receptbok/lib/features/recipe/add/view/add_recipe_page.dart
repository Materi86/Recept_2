import 'dart:io';

import 'package:familiens_receptbok/data/models/models.dart';
import 'package:familiens_receptbok/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddRecipePage extends ConsumerStatefulWidget {
  const AddRecipePage({super.key});

  @override
  ConsumerState<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends ConsumerState<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _ingredients;
  String? _instructions;
  final List<Category> _selectedCategories = [];
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsyncValue = ref.watch(categoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nytt Recept')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_imageFile!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                          Text(
                            'Välj en bild',
                            style: GoogleFonts.lato(color: Colors.grey[700]),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Titel'),
              validator: (value) => value!.isEmpty ? 'Fyll i en titel' : null,
              onSaved: (value) => _title = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Ingredienser'),
              maxLines: null,
              onSaved: (value) => _ingredients = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Instruktioner'),
              maxLines: null,
              onSaved: (value) => _instructions = value,
            ),
            const SizedBox(height: 16),
            Text('Kategorier', style: Theme.of(context).textTheme.titleMedium),
            categoriesAsyncValue.when(
              data: (categories) => Wrap(
                spacing: 8,
                children: categories
                    .map(
                      (category) => FilterChip(
                        label: Text(category.name ?? ''),
                        selected: _selectedCategories.contains(category),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedCategories.add(category);
                            } else {
                              _selectedCategories.remove(category);
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  String? imagePath;
                  if (_imageFile != null) {
                    final appDir = await getApplicationDocumentsDirectory();
                    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
                    final newPath = '${appDir.path}/$fileName';
                    await _imageFile!.copy(newPath);
                    imagePath = newPath;
                  }

                  final recipe = Recipe()
                    ..title = _title
                    ..ingredients = _ingredients
                    ..instructions = _instructions
                    ..imagePath = imagePath
                    ..createdAt = DateTime.now()
                    ..updatedAt = DateTime.now();
                  recipe.categories.addAll(_selectedCategories);
                  ref.read(recipeNotifierProvider.notifier).addRecipe(recipe);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE57373),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text('Spara Recept', style: GoogleFonts.robotoSlab(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
