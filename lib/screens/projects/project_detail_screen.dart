import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/Project.dart';
import '../../models/Task.dart';
import '../../providers/project_provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/cards/task_card.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<TaskProvider>(context, listen: false).loadTasks(widget.project.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final listeDesTaches = taskProvider.tasks;
    final stats = taskProvider.taskCountByStatus;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Détails du Projet"),
        actions: [
          // Bouton Supprimer
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.error),
            onPressed: () {
              // On affiche l'alerte de confirmation
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(AppStrings.delete),
                  content: const Text(AppStrings.confirmDelete),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(AppStrings.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<ProjectProvider>(context, listen: false)
                            .deleteProject(widget.project.id);

                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text(AppStrings.delete, style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // L'en-tête avec les infos du projet
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Color(widget.project.color).withOpacity(0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.project.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(widget.project.description ?? "Pas de description"),
                  const SizedBox(height: 10),
                  Text("Créé le : ${widget.project.createdAt.day}/${widget.project.createdAt.month}/${widget.project.createdAt.year}"),
                ],
              ),
            ),

            //  Les Statistiques
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 10,
                children: [
                  Chip(
                    label: Text("À faire: ${stats[TaskStatus.todo]}"),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                  ),
                  Chip(
                    label: Text("En cours: ${stats[TaskStatus.inProgress]}"),
                    backgroundColor: AppColors.statusInProgress.withOpacity(0.1),
                  ),
                  Chip(
                    label: Text("Terminé: ${stats[TaskStatus.done]}"),
                    backgroundColor: AppColors.statusDone.withOpacity(0.1),
                  ),
                ],
              ),
            ),

            // Liste des tâches
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 10),
              child: Text("Tâches du projet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),


            if (taskProvider.isLoading)
              const Center(child: CircularProgressIndicator())


            else if (listeDesTaches.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Aucune tâche pour le moment"),
              ))


            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listeDesTaches.length,
                itemBuilder: (context, index) {
                  final task = listeDesTaches[index];


                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TaskCard(
                      titre: task.title,
                      description: task.description ?? "",
                      statut: task.status.name,
                      priorite: task.priority.name,
                      dateEcheance: task.dueDate,
                      onTap: () {

                      },
                    ),
                  );
                },
              ),

            const SizedBox(height: 50),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}