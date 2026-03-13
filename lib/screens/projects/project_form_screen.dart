import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/Project.dart';
import '../../providers/auth_provider.dart';
import '../../providers/project_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class ProjectFormScreen extends StatefulWidget {
  final Project? project;

  const ProjectFormScreen({super.key, this.project});

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _descController = TextEditingController();

  Color _couleurChoisie = AppColors.primary;

  final List<Color> _mesCouleurs = [
    AppColors.primary,
    AppColors.info,
    AppColors.error,
    AppColors.success,
    AppColors.warning,
    AppColors.secondary,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _nomController.text = widget.project!.name;
      _descController.text = widget.project!.description ?? '';
      _couleurChoisie = Color(widget.project!.color);
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _enregistrer() async {
    if (_formKey.currentState!.validate()) {
      final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Sécurité pour l'ID utilisateur
      final userId = authProvider.currentUser?.id ?? '';

      if (widget.project != null) {
        Project projetModifie = widget.project!.copyWith(
          name: _nomController.text.trim(),
          description: _descController.text.trim(),
          color: _couleurChoisie.value,
        );
        await projectProvider.updateProject(projetModifie);
      } else {
        Project nouveauProjet = Project(
          id: const Uuid().v4(),
          name: _nomController.text.trim(),
          description: _descController.text.trim(),
          userId: userId,
          color: _couleurChoisie.value,
        );

        await projectProvider.createProject(nouveauProjet);
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(

        title: Text(
          widget.project == null ? AppStrings.newProject : AppStrings.editProject,
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: AppStrings.projectName,
                controller: _nomController,
                prefixIcon: Icons.folder,
                validator: (valeur) {
                  if (valeur == null || valeur.isEmpty) return AppStrings.nameRequired;
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: AppStrings.projectDescription,
                controller: _descController,
                prefixIcon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 25),
              const Text(
                AppStrings.projectColor,
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  for (var couleur in _mesCouleurs)
                    GestureDetector(
                      onTap: () => setState(() => _couleurChoisie = couleur),
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: couleur,
                          shape: BoxShape.circle,
                          border: _couleurChoisie == couleur
                              ? Border.all(color: AppColors.textPrimary, width: 3)
                              : null,
                        ),
                        child: _couleurChoisie == couleur
                            ? const Icon(Icons.check, color: AppColors.white)
                            : null,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 40),
              CustomButton(

                text: widget.project == null ? AppStrings.add : AppStrings.edit,
                icon: widget.project == null ? Icons.add : Icons.edit,
                onPressed: _enregistrer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}