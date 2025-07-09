import 'package:familiens_receptbok/data/models/models.dart';
import 'package:familiens_receptbok/features/category/manage/view/manage_categories_page.dart';
import 'package:familiens_receptbok/features/recipe/add/view/add_recipe_page.dart';
import 'package:familiens_receptbok/features/recipe/detail/view/recipe_detail_page.dart';
import 'package:familiens_receptbok/features/recipe/list/widgets/recipe_card.dart';
import 'package:familiens_receptbok/features/recipe/list/notifiers/recipe_notifier.dart';
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
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipes = ref.watch(recipeNotifierProvider);
    final categoriesAsyncValue = ref.watch(categoryNotifierProvider);
    final recipeNotifier = ref.read(recipeNotifierProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: _isSearchExpanded ? _buildSearchField() : _buildTitle(),
        actions: [
          _buildSearchToggle(),
          _buildFilterMenu(recipeNotifier),
          categoriesAsyncValue.when(
            data: (categories) => _buildCategoryDropdown(categories, recipeNotifier),
            loading: () => const SizedBox.shrink(),
            error: (err, stack) => const SizedBox.shrink(),
          ),
          _buildCategoryManageButton(),
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
          child: Column(
            children: [
              _buildQuickFilters(recipeNotifier),
              Expanded(
                child: recipes.when(
                  data: (recipes) => recipes.isEmpty
                      ? _buildEmptyState()
                      : _buildRecipeGrid(recipes, recipeNotifier),
                  loading: () => _buildLoadingState(),
                  error: (err, stack) => _buildErrorState(err.toString()),
                ),
              ),
            ],
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

  Widget _buildTitle() {
    return Text(
      'Familiens Recept',
      style: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        foreground: Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF)],
          ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF6C5CE7).withOpacity(0.2),
        ),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: const Color(0xFF2D3436),
        ),
        decoration: InputDecoration(
          hintText: 'Sök recept...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF636E72),
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF6C5CE7),
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: Color(0xFF636E72),
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(recipeNotifierProvider.notifier).clearSearch();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        onChanged: (query) {
          setState(() {});
          ref.read(recipeNotifierProvider.notifier).search(query);
        },
      ),
    );
  }

  Widget _buildSearchToggle() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: _isSearchExpanded 
            ? const Color(0xFF6C5CE7).withOpacity(0.1)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF6C5CE7).withOpacity(0.2),
        ),
      ),
      child: IconButton(
        icon: Icon(
          _isSearchExpanded ? Icons.close_rounded : Icons.search_rounded,
          color: const Color(0xFF6C5CE7),
        ),
        onPressed: () {
          setState(() {
            _isSearchExpanded = !_isSearchExpanded;
            if (!_isSearchExpanded) {
              _searchController.clear();
              ref.read(recipeNotifierProvider.notifier).clearSearch();
            }
          });
        },
      ),
    );
  }

  Widget _buildFilterMenu(RecipeNotifier notifier) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF6C5CE7).withOpacity(0.2),
        ),
      ),
      child: PopupMenuButton<RecipeSortBy>(
        icon: const Icon(
          Icons.sort_rounded,
          color: Color(0xFF6C5CE7),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onSelected: (sortBy) {
          notifier.setSortBy(sortBy);
        },
        itemBuilder: (context) => [
          _buildSortMenuItem(RecipeSortBy.newest, 'Nyaste först', Icons.access_time_rounded),
          _buildSortMenuItem(RecipeSortBy.rating, 'Högst betyg', Icons.star_rounded),
          _buildSortMenuItem(RecipeSortBy.alphabetical, 'Alfabetisk', Icons.sort_by_alpha_rounded),
          _buildSortMenuItem(RecipeSortBy.oldest, 'Äldsta först', Icons.history_rounded),
        ],
      ),
    );
  }

  PopupMenuItem<RecipeSortBy> _buildSortMenuItem(RecipeSortBy sortBy, String title, IconData icon) {
    return PopupMenuItem(
      value: sortBy,
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF6C5CE7)),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown(List<Category> categories, RecipeNotifier notifier) {
    return Container(
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
          'Kategori',
          style: GoogleFonts.poppins(
            color: const Color(0xFF6C5CE7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: _selectedCategory,
        underline: const SizedBox(),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF6C5CE7),
          size: 16,
        ),
        onChanged: (category) {
          setState(() {
            _selectedCategory = category;
          });
          notifier.filterByCategory(category);
        },
        items: [
          DropdownMenuItem(
            value: null,
            child: Text(
              'Alla',
              style: GoogleFonts.poppins(
                color: const Color(0xFF2D3436),
                fontSize: 12,
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
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryManageButton() {
    return Container(
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
    );
  }

  Widget _buildQuickFilters(RecipeNotifier notifier) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildFilterChip(
            'Alla',
            notifier.currentFilter == RecipeFilter.all,
            () => notifier.setFilter(RecipeFilter.all),
            Icons.restaurant_menu_rounded,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'Favoriter',
            notifier.currentFilter == RecipeFilter.favorites,
            () => notifier.setFilter(RecipeFilter.favorites),
            Icons.favorite_rounded,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'Högt betyg',
            notifier.currentFilter == RecipeFilter.highRated,
            () => notifier.setFilter(RecipeFilter.highRated),
            Icons.star_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF6C5CE7) 
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF6C5CE7) 
                : const Color(0xFF6C5CE7).withOpacity(0.2),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF6C5CE7).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF6C5CE7),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF6C5CE7),
              ),
            ),
          ],
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

  Widget _buildRecipeGrid(List<Recipe> recipes, RecipeNotifier notifier) {
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
                    onFavoriteToggle: () {
                      notifier.toggleFavorite(recipe.id);
                    },
                    onRatingChanged: (rating) {
                      notifier.updateRating(recipe.id, rating);
                    },
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
