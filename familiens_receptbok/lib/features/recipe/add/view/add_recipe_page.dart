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

class _AddRecipePageState extends ConsumerState<AddRecipePage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  final List<Category> _selectedCategories = [];
  File? _imageFile;
  bool _isLoading = false;
  
  late AnimationController _slideAnimationController;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _slideAnimationController.forward();
  }
  
  @override
  void dispose() {
    _slideAnimationController.dispose();
    _titleController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Nytt Recept',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3436),
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF6C5CE7).withOpacity(0.2),
            ),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFF6C5CE7),
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F9FA),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: SlideTransition(
            position: _slideAnimation,
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 20),
                  _buildImagePicker(),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: _titleController,
                    label: 'Titel',
                    icon: Icons.restaurant_menu_rounded,
                    validator: (value) => value?.isEmpty == true ? 'Fyll i en titel' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _ingredientsController,
                    label: 'Ingredienser',
                    icon: Icons.local_grocery_store_rounded,
                    maxLines: 5,
                    hint: 'Skriv ingredienserna här...',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _instructionsController,
                    label: 'Instruktioner',
                    icon: Icons.menu_book_rounded,
                    maxLines: 8,
                    hint: 'Beskriv hur man tillagar rätten...',
                  ),
                  const SizedBox(height: 24),
                  _buildCategorySection(categoriesAsyncValue),
                  const SizedBox(height: 32),
                  _buildSaveButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: _imageFile != null ? null : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6C5CE7).withOpacity(0.1),
              const Color(0xFF74B9FF).withOpacity(0.1),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF6C5CE7).withOpacity(0.2),
            width: 2,
          ),
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C5CE7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 40,
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Lägg till en bild',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6C5CE7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tryck för att välja från galleriet',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: GoogleFonts.inter(
          fontSize: 16,
          color: const Color(0xFF2D3436),
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6C5CE7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6C5CE7),
              size: 20,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
  
  Widget _buildCategorySection(AsyncValue<List<Category>> categoriesAsyncValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.category_rounded,
                color: Color(0xFF6C5CE7),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Kategorier',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        categoriesAsyncValue.when(
          data: (categories) => categories.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Inga kategorier tillgängliga',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF636E72),
                      fontSize: 14,
                    ),
                  ),
                )
              : Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: categories
                      .map(
                        (category) => GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedCategories.contains(category)) {
                                _selectedCategories.remove(category);
                              } else {
                                _selectedCategories.add(category);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _selectedCategories.contains(category)
                                  ? const Color(0xFF6C5CE7)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _selectedCategories.contains(category)
                                    ? const Color(0xFF6C5CE7)
                                    : const Color(0xFF6C5CE7).withOpacity(0.2),
                                width: 2,
                              ),
                              boxShadow: _selectedCategories.contains(category)
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF6C5CE7).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              category.name ?? '',
                              style: GoogleFonts.poppins(
                                color: _selectedCategories.contains(category)
                                    ? Colors.white
                                    : const Color(0xFF6C5CE7),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
          loading: () => Container(
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C5CE7)),
              ),
            ),
          ),
          error: (err, stack) => Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE17055).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Fel vid laddning av kategorier: $err',
              style: GoogleFonts.inter(
                color: const Color(0xFFE17055),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6C5CE7),
            Color(0xFF74B9FF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveRecipe,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.save_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Spara Recept',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        String? imagePath;
        if (_imageFile != null) {
          final appDir = await getApplicationDocumentsDirectory();
          final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
          final newPath = '${appDir.path}/$fileName';
          await _imageFile!.copy(newPath);
          imagePath = newPath;
        }

        final recipe = Recipe()
          ..title = _titleController.text
          ..ingredients = _ingredientsController.text
          ..instructions = _instructionsController.text
          ..imagePath = imagePath
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();
        recipe.categories.addAll(_selectedCategories);
        
        ref.read(recipeNotifierProvider.notifier).addRecipe(recipe);
        
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fel vid sparande: $e'),
              backgroundColor: const Color(0xFFE17055),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
