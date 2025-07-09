import 'dart:io';

import 'package:familiens_receptbok/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title ?? '')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (recipe.imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(recipe.imagePath!), fit: BoxFit.cover),
            ),
          const SizedBox(height: 16),
          Text(
            recipe.title ?? '',
            style: GoogleFonts.robotoSlab(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4E342E),
            ),
          ),
          const SizedBox(height: 16),
          if (recipe.categories.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kategorier', style: Theme.of(context).textTheme.headlineSmall),
                Wrap(
                  spacing: 8,
                  children: recipe.categories
                      .map((category) => Chip(label: Text(category.name ?? '')))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          Text('Ingredienser', style: Theme.of(context).textTheme.headlineSmall),
          Text(
            recipe.ingredients ?? '',
            style: GoogleFonts.lato(fontSize: 16, color: const Color(0xFF4E342E)),
          ),
          const SizedBox(height: 16),
          Text('Instruktioner', style: Theme.of(context).textTheme.headlineSmall),
          Text(
            recipe.instructions ?? '',
            style: GoogleFonts.lato(fontSize: 16, color: const Color(0xFF4E342E)),
          ),
        ],
      ),
    );
  }
}
