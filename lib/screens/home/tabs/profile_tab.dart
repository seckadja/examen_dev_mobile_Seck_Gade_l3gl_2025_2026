import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/Task.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/project_provider.dart';
import '../../../providers/task_provider.dart';
import '../../../widgets/common/custom_button.dart';

class ProfileTab extends StatelessWidget {

  final Future<void> Function() onLogout;

  const ProfileTab({super.key, required this.onLogout});


  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider    = Provider.of<AuthProvider>(context, listen: false);
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    final taskProvider    = Provider.of<TaskProvider>(context, listen: false);
    return ListenableBuilder(
      listenable: Listenable.merge([authProvider, projectProvider, taskProvider]),
      builder: (context, _) {

        // Donnees de l'utilisateur connecte
        final String userName     = authProvider.currentUser?.name  ?? 'Utilisateur';
        final String userEmail    = authProvider.currentUser?.email ?? '';
        final String avatarLetter = userName[0].toUpperCase();

        // Date d'inscription
        final String dateInscription = authProvider.currentUser != null
            ? _formatDate(authProvider.currentUser!.createdAt)
            : '';

        // Statistiques
        final int projectCount = projectProvider.projectCount;
        final int taskCount =
            (taskProvider.taskCountByStatus[TaskStatus.todo]       ?? 0) +
                (taskProvider.taskCountByStatus[TaskStatus.inProgress] ?? 0) +
                (taskProvider.taskCountByStatus[TaskStatus.done]       ?? 0);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Avatar avec la 1ere lettre du nom
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Text(
                  avatarLetter,
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),


              Text(
                userEmail,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 8),


              Visibility(
                visible: dateInscription.isNotEmpty,
                child: Text(
                  'Inscrite depuis le $dateInscription',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              //Titre statistiques
              const Text(
                'Mes statistiques',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              //Cartes de statistiques
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ProfileStat(
                    label: 'Projets',
                    count: projectCount,
                    icon: Icons.folder,
                  ),
                  _ProfileStat(
                    label: 'Taches',
                    count: taskCount,
                    icon: Icons.checklist,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              //Bouton deconnexion
              CustomButton(
                text:       'Se deconnecter',
                icon:       Icons.logout,
                isOutlined: true,
                color:      Colors.red,
                onPressed:  onLogout,
              ),

            ],
          ),
        );
      },
    );
  }
}

//Carte de statistique du profil
class _ProfileStat extends StatelessWidget {
  final String   label;
  final int      count;
  final IconData icon;

  const _ProfileStat({
    required this.label,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 36, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}