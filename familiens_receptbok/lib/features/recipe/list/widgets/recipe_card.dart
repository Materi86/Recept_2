import 'dart:io';

import 'package:familiens_receptbok/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({
    super.key, 
    required this.recipe, 
    this.onTap,
    this.onFavoriteToggle,
    this.onRatingChanged,
  });

  final Recipe recipe;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final Function(double)? onRatingChanged;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedOpacity(
            opacity: _opacityAnimation.value,
            duration: const Duration(milliseconds: 150),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C5CE7).withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  onTapCancel: _onTapCancel,
                  onTap: widget.onTap,
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _isHovered = true),
                    onExit: (_) => setState(() => _isHovered = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      transform: Matrix4.identity()
                        ..translate(0.0, _isHovered ? -4.0 : 0.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: widget.recipe.imagePath != null
                                          ? null
                                          : const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFF74B9FF),
                                                Color(0xFF6C5CE7),
                                              ],
                                            ),
                                    ),
                                    child: widget.recipe.imagePath != null
                                        ? Image.file(
                                            File(widget.recipe.imagePath!),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          )
                                        : Center(
                                            child: Icon(
                                              Icons.restaurant_menu_rounded,
                                              size: 48,
                                              color: Colors.white.withOpacity(0.8),
                                            ),
                                          ),
                                  ),
                                  // Favorite button
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: GestureDetector(
                                      onTap: widget.onFavoriteToggle,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 300),
                                          child: Icon(
                                            widget.recipe.isFavorite 
                                                ? Icons.favorite_rounded
                                                : Icons.favorite_border_rounded,
                                            key: ValueKey(widget.recipe.isFavorite),
                                            color: widget.recipe.isFavorite 
                                                ? const Color(0xFFE17055) 
                                                : const Color(0xFF636E72),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Rating display
                                  if (widget.recipe.rating > 0)
                                    Positioned(
                                      top: 12,
                                      left: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              color: Colors.amber,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              widget.recipe.rating.toStringAsFixed(1),
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.7),
                                          ],
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        widget.recipe.title ?? 'Inget namn',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (widget.recipe.categories.isNotEmpty) ...
                                      [
                                        Expanded(
                                          child: Wrap(
                                            spacing: 6,
                                            runSpacing: 6,
                                            children: widget.recipe.categories
                                                .take(2)
                                                .map(
                                                  (category) => Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFF6C5CE7)
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(12),
                                                      border: Border.all(
                                                        color: const Color(0xFF6C5CE7)
                                                            .withOpacity(0.2),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      category.name ?? '',
                                                      style: GoogleFonts.poppins(
                                                        color: const Color(0xFF6C5CE7),
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ]
                                    else
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            'Inga kategorier',
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFFB2BEC3),
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.schedule_rounded,
                                              size: 14,
                                              color: const Color(0xFFB2BEC3),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Nyligen tillagd',
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFFB2BEC3),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (widget.recipe.isFavorite)
                                          Icon(
                                            Icons.favorite_rounded,
                                            size: 14,
                                            color: const Color(0xFFE17055),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
