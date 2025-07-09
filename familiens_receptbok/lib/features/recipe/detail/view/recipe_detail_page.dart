import 'dart:io';

import 'package:familiens_receptbok/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _slideAnimationController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimationController = AnimationController(
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
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimationController.forward();
    _fadeAnimationController.forward();
  }
  
  @override
  void dispose() {
    _slideAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),
                        const SizedBox(height: 20),
                        if (widget.recipe.categories.isNotEmpty) ..[
                          _buildCategoriesSection(),
                          const SizedBox(height: 24),
                        ],
                        _buildIngredientsSection(),
                        const SizedBox(height: 24),
                        _buildInstructionsSection(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF2D3436),
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'recipe-${widget.recipe.id}',
              child: widget.recipe.imagePath != null
                  ? Image.file(
                      File(widget.recipe.imagePath!),
                      fit: BoxFit.cover,
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF74B9FF),
                            Color(0xFF6C5CE7),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.restaurant_menu_rounded,
                          size: 80,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTitle() {
    return Text(
      widget.recipe.title ?? 'Inget namn',
      style: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF2D3436),
        height: 1.2,
      ),
    );
  }
  
  Widget _buildCategoriesSection() {
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
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: widget.recipe.categories
              .map(
                (category) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF6C5CE7).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    category.name ?? '',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF6C5CE7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
  
  Widget _buildIngredientsSection() {
    return _buildSection(
      title: 'Ingredienser',
      icon: Icons.local_grocery_store_rounded,
      content: widget.recipe.ingredients ?? 'Inga ingredienser angivna',
    );
  }
  
  Widget _buildInstructionsSection() {
    return _buildSection(
      title: 'Instruktioner',
      icon: Icons.menu_book_rounded,
      content: widget.recipe.instructions ?? 'Inga instruktioner angivna',
    );
  }
  
  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF6C5CE7).withOpacity(0.1),
        ),
      ),
      child: Column(
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
                child: Icon(
                  icon,
                  color: const Color(0xFF6C5CE7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF636E72),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
