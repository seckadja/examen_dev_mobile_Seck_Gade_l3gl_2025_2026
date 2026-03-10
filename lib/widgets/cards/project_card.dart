import 'package:flutter/material.dart';
import '../../models/project.dart';

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
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Pastille de couleur du projet
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: couleur,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),

              // Nom + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nomProjet,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // On affiche la description seulement si elle n'est pas vide
                    Visibility(
                      visible: description.isNotEmpty,
                      child: Text(
                        description,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$nombreTaches tâche(s)',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),

              // Menu contextuel : modifier / supprimer
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
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Modifier'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'supprimer',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Supprimer', style: TextStyle(color: Colors.red)),
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
