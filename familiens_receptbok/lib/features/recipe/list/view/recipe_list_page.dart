import 'package:familiens_receptbok/data/models/models.dart';
import 'package:familiens_receptbok/features/category/manage/view/manage_categories_page.dart';
import 'package:familiens_receptbok/features/recipe/add/view/add_recipe_page.dart';
import 'package:familiens_receptbok/features/recipe/detail/view/recipe_detail_page.dart';
import 'package:familiens_receptbok/features/recipe/list/widgets/recipe_card.dart';
import 'package:familiens_receptbok/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeListPage extends ConsumerStatefulWidget {
  const RecipeListPage({super.key});

  @override
  ConsumerState<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends ConsumerState<RecipeListPage>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fabScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipes = ref.watch(recipeNotifierProvider);
    final categoriesAsyncValue = ref.watch(categoryNotifierProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Familiens Recept',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF)],
              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
          ),
        ),
        actions: [
          categoriesAsyncValue.when(
            data: (categories) => Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF6C5CE7).withOpacity(0.2),
                ),
              ),
              child: DropdownButton<Category>(
                hint: Text(
                  'Filtrera',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF6C5CE7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: _selectedCategory,
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF6C5CE7),
                ),
                onChanged: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                  ref.read(recipeNotifierProvider.notifier).filterByCategory(category);
                },
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(
                      'Visa alla',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF2D3436),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ...categories.map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(
                        category.name ?? '',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF2D3436),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (err, stack) => const SizedBox.shrink(),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF6C5CE7).withOpacity(0.2),
              ),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.category_rounded,
                color: Color(0xFF6C5CE7),
              ),
              onPressed: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const ManageCategoriesPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
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
          child: recipes.when(
            data: (recipes) => recipes.isEmpty
                ? _buildEmptyState()
                : _buildRecipeGrid(recipes),
            loading: () => _buildLoadingState(),
            error: (err, stack) => _buildErrorState(err.toString()),
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const AddRecipePage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  );
                },
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF6C5CE7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              size: 64,
              color: const Color(0xFF6C5CE7).withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Inga recept ännu',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tryck på + för att lägga till ditt första recept',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF636E72),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C5CE7).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C5CE7)),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Laddar recept...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF636E72),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE17055).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: const Color(0xFFE17055),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Något gick fel',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF636E72),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeGrid(List<Recipe> recipes) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final recipe = recipes[index];
                return Hero(
                  tag: 'recipe-${recipe.id}',
                  child: RecipeCard(
                    recipe: recipe,
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            RecipeDetailPage(recipe: recipe),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.3),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              )),
                              child: child,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              childCount: recipes.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100), // Extra space for FAB
        ),
      ],
    );
  }
}
