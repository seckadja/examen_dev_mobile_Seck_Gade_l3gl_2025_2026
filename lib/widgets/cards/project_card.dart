import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';


class ProjectCard extends StatelessWidget {
  final String nomProjet;
  final String description;
  final Color couleur;
  final int nombreTaches;
  final VoidCallback? onTap;
  final VoidCallback? onModifier;
  final VoidCallback? onSupprimer;

  const ProjectCard({
    super.key,
    required this.nomProjet,
    required this.description,
    required this.couleur,
    required this.nombreTaches,
    this.onTap,
    this.onModifier,
    this.onSupprimer,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        color: AppColors.surface,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: couleur,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nomProjet,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (description.isNotEmpty)
                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      '$nombreTaches tâche(s)',
                      style: const TextStyle(color: AppColors.textDisable, fontSize: 12),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (valeur) {
                  if (valeur == 'modifier') {
                    onModifier?.call();
                  } else if (valeur == 'supprimer') {
                    onSupprimer?.call();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'modifier',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18, color: AppColors.textPrimary),
                        SizedBox(width: 8),
                        Text(AppStrings.edit),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'supprimer',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: AppColors.error),
                        SizedBox(width: 8),
                        Text(AppStrings.delete, style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}