import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  // Message de bienvenue selon l'heure de la journee
  String _getGreeting() {
    final int hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour';
    if (hour < 18) return 'Bon apres-midi';
    return 'Bonsoir';
  }

  @override
  Widget build(BuildContext context) {
    // On recupere les providers
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

        // Statistiques depuis les providers
        final int projectCount    = projectProvider.projectCount;
        final int todoCount       = taskProvider.taskCountByStatus[TaskStatus.todo]       ?? 0;
        final int inProgressCount = taskProvider.taskCountByStatus[TaskStatus.inProgress] ?? 0;
        final int doneCount       = taskProvider.taskCountByStatus[TaskStatus.done]       ?? 0;

        //  les 3 derniers projets
        final List<Project> allProjects = projectProvider.projects;
        final List<Project> recentProjects = allProjects.length > 3
            ? allProjects.sublist(allProjects.length - 3)
            : allProjects;

        return RefreshIndicator(
          // L'utilisateur tire vers le bas pour recharger
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
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Voici un resume de vos activites',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),

                //Titre section statistiques
                const Text(
                  'Statistiques',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                //Ligne 1 : Projets + A faire
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Projets',
                        count: projectCount,
                        icon: Icons.folder,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'A faire',
                        count: todoCount,
                        icon: Icons.radio_button_unchecked,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Ligne 2 : En cours + Terminees
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'En cours',
                        count: inProgressCount,
                        icon: Icons.autorenew,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Terminees',
                        count: doneCount,
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                //Titre projets recents
                const Text(
                  'Projets recents',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                // Liste des projets recents avec ProjectCard
                Visibility(
                  visible: recentProjects.isNotEmpty,
                  child: Column(
                    children: recentProjects.map((Project p) {
                      return ProjectCard(
                        nomProjet:    p.name,
                        description:  p.description ?? '',
                        couleur:      Color(p.color),
                        nombreTaches: 0,
                        onTap: () {
                          // TODO:On naviguer vers ProjectDetailScreen
                        },
                        onModifier: () {
                          // TODO:On  naviguer vers ProjectFormScreen
                        },
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

// Carte de statistique
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
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}