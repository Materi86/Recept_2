import 'dart:io';

import 'package:familiens_receptbok/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe, this.onTap});

  final Recipe recipe;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  if (recipe.imagePath != null)
                    Image.file(
                      File(recipe.imagePath!),
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ) 
                  else
                    Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                    ),
                  Container(
                    width: double.infinity,
                    color: Colors.black54,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      recipe.title ?? '',
                      style: GoogleFonts.robotoSlab(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                children: recipe.categories
                    .map(
                      (category) => Chip(
                        label: Text(category.name ?? ''),
                        backgroundColor: const Color(0xFFA5D6A7),
                        labelStyle: GoogleFonts.lato(
                          color: const Color(0xFF4E342E),
                          fontSize: 12,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
