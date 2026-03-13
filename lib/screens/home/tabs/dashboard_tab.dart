import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/Project.dart';
import '../../../models/Task.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/project_provider.dart';
import '../../../providers/task_provider.dart';
import '../../../widgets/cards/project_card.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../projects/project_form_screen.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  String _getGreeting() {
    final int hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour';
    if (hour < 18) return 'Bon apres-midi';
    return 'Bonsoir';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider    = Provider.of<AuthProvider>(context, listen: false);
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    final taskProvider    = Provider.of<TaskProvider>(context, listen: false);

    return ListenableBuilder(
      listenable: Listenable.merge([authProvider, projectProvider, taskProvider]),
      builder: (context, _) {
        if (projectProvider.isLoading) {
          return const LoadingIndicator();
        }

        final String userName = authProvider.currentUser?.name ?? 'Utilisateur';

        final int projectCount    = projectProvider.projectCount;
        final int todoCount       = taskProvider.taskCountByStatus[TaskStatus.todo]       ?? 0;
        final int inProgressCount = taskProvider.taskCountByStatus[TaskStatus.inProgress] ?? 0;
        final int doneCount       = taskProvider.taskCountByStatus[TaskStatus.done]       ?? 0;

        final List<Project> allProjects = projectProvider.projects;
        final List<Project> recentProjects = allProjects.length > 3
            ? allProjects.sublist(allProjects.length - 3)
            : allProjects;

        return RefreshIndicator(
          onRefresh: () async {
            final userId = authProvider.currentUser?.id;
            if (userId != null) {
              await projectProvider.loadProjects(userId);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getGreeting()}, $userName !',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Voici un resume de vos activites',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Statistiques',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary), // AppColors
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: AppStrings.projects,
                        count: projectCount,
                        icon: Icons.folder,
                        color: AppColors.info,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: AppStrings.statusTodo,
                        count: todoCount,
                        icon: Icons.radio_button_unchecked,
                        color: AppColors.priorityMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: AppStrings.statusInProgress,
                        count: inProgressCount,
                        icon: Icons.autorenew,
                        color: AppColors.statusInProgress,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: AppStrings.statusDone,
                        count: doneCount,
                        icon: Icons.check_circle,
                        color: AppColors.statusDone,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  'Projets recents',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                Visibility(
                  visible: recentProjects.isEmpty,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Aucun projet pour le moment.\nAppuyez sur + pour commencer !',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textDisable),
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: recentProjects.isNotEmpty,
                  child: Column(
                    children: recentProjects.map((Project p) {
                      return ProjectCard(
                        nomProjet:    p.name,
                        description:  p.description ?? '',
                        couleur:      Color(p.color),
                        nombreTaches: 0,
                        onTap: () {},
                        onModifier: () {},
                        onSupprimer: () async {
                          await projectProvider.deleteProject(p.id);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String   label;
  final int      count;
  final IconData icon;
  final Color    color;

  const _StatCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}