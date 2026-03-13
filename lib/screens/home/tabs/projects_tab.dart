import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/Project.dart';
import '../../../providers/project_provider.dart';
import '../../../widgets/cards/project_card.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../projects/project_detail_screen.dart';
import '../../projects/project_form_screen.dart';

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        tooltip: 'Nouveau projet',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProjectFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, color: AppColors.white),
      ),

      body: ListenableBuilder(
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
                if (projects.isEmpty)
                  const Expanded(
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
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        final Project p = projects[index];
                        return ProjectCard(
                          nomProjet: p.name,
                          description: p.description ?? '',
                          couleur: Color(p.color),
                          nombreTaches: 0,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProjectDetailScreen(project: p),
                              ),
                            );
                          },
                          onModifier: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProjectFormScreen(project: p),
                              ),
                            );
                          },
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
                                      AppStrings.delete,
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
              ],
            ),
          );
        },
      ),
    );
  }
}