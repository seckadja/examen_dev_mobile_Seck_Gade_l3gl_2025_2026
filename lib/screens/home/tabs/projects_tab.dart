import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/Project.dart';
import '../../../providers/project_provider.dart';
import '../../../widgets/cards/project_card.dart';
import '../../../widgets/common/loading_indicator.dart';

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    return ListenableBuilder(
      listenable: projectProvider,
      builder: (context, _) {
        // Chargement en cours
        if (projectProvider.isLoading) {
          return const LoadingIndicator();
        }

        final List<Project> projects = projectProvider.projects;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Visibility(
                visible: projects.isEmpty,
                child: const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Aucun projet pour le moment',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Appuyez sur + pour creer votre premier projet',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Liste des projets
              Visibility(
                visible: projects.isNotEmpty,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final Project p = projects[index];
                      return ProjectCard(
                        nomProjet:    p.name,
                        description:  p.description ?? '',
                        couleur:      Color(p.color),
                        nombreTaches: 0,
                        onTap: () {
                          // TODO:On naviguer vers ProjectDetailScreen
                        },
                        onModifier: () {
                          // TODO:On naviguer vers ProjectFormScreen
                        },
                        onSupprimer: () async {
                          final bool? confirmer = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Supprimer le projet ?'),
                              content: Text(
                                'Voulez-vous vraiment le supprimer "${p.name}" ?\n'
                                    'Toutes ses taches seront aussi supprimees.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Supprimer',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirmer == true) {
                            await projectProvider.deleteProject(p.id);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),

            ],
          ),
        );
      },
    );
  }
}