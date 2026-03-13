import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
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
                      Icon(Icons.folder_open, size: 80, color: AppColors.textDisable),
                      SizedBox(height: 16),
                      Text(
                        AppStrings.noProjects,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        AppStrings.noProjectsDesc,
                        style: TextStyle(color: AppColors.textDisable),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

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
                        onTap: () {},
                        onModifier: () {},
                        onSupprimer: () async {
                          final bool? confirmer = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text(AppStrings.deleteProject),
                              content: Text(
                                '${AppStrings.confirmDelete} "${p.name}" ?\n'
                                    'Toutes ses taches seront aussi supprimees.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text(AppStrings.cancel),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    AppStrings.delete, // AppStrings
                                    style: TextStyle(color: AppColors.error),
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