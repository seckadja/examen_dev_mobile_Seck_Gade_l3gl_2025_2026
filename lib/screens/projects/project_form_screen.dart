import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/Project.dart';
import '../../providers/auth_provider.dart';
import '../../providers/project_provider.dart';
import '../../widgets/cards/project_card.dart';
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

  final _nomController         = TextEditingController();
  final _descriptionController = TextEditingController();


  final List<Color> _couleursPredefinies = [
    AppColors.info,
    AppColors.error,
    AppColors.success,
    AppColors.warning,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.brown,
  ];

  Color _couleurSelectionnee = AppColors.primary;

  bool get _estModification => widget.project != null;

  @override
  void initState() {
    super.initState();
    if (_estModification) {
      _nomController.text         = widget.project!.name;
      _descriptionController.text = widget.project!.description ?? '';
      _couleurSelectionnee        = Color(widget.project!.color);
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _sauvegarder() async {
    if (!_formKey.currentState!.validate()) return;

    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    final authProvider    = Provider.of<AuthProvider>(context, listen: false);

    if (_estModification) {
      final projectModifie = widget.project!.copyWith(
        name:        _nomController.text.trim(),
        description: _descriptionController.text.trim(),
        color:       _couleurSelectionnee.value,
      );
      await projectProvider.updateProject(projectModifie);
    } else {
      final nouveauProjet = Project(
        id:          const Uuid().v4(),
        name:        _nomController.text.trim(),
        description: _descriptionController.text.trim(),
        userId:      authProvider.currentUser!.id,
        color:       _couleurSelectionnee.value,
      );
      await projectProvider.createProject(nouveauProjet);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
            _estModification ? AppStrings.editProject : AppStrings.createProject,
            style: const TextStyle(color: AppColors.white)
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomTextField(
                label:      'Nom du projet',
                controller: _nomController,
                prefixIcon: Icons.folder,
                hint:       'Ex: Application Mobile',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.nameRequired;
                  }
                  if (value.trim().length < 3) {
                    return 'Minimum 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label:      'Description',
                controller: _descriptionController,
                prefixIcon: Icons.description,
                hint:       'Decrivez votre projet (optionnel)',
                maxLines:   3,
              ),
              const SizedBox(height: 24),

              const Text(
                'Couleur du projet',
                style: TextStyle(
                  fontSize:   16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _couleursPredefinies.map((Color couleur) {

                  final bool estSelectionnee = _couleurSelectionnee == couleur;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _couleurSelectionnee = couleur;
                      });
                    },
                    child: Container(
                      width:  40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:  couleur,
                        shape:  BoxShape.circle,
                        border: estSelectionnee
                            ? Border.all(color: AppColors.white, width: 3)
                            : null,
                        boxShadow: estSelectionnee
                            ? [BoxShadow(
                          color:      couleur.withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )]
                            : null,
                      ),
                      child: Visibility(
                        visible: estSelectionnee,
                        child: const Icon(
                          Icons.check,
                          color: AppColors.white,
                          size:  20,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              const Text(
                'Apercu',
                style: TextStyle(
                  fontSize:   16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              ListenableBuilder(
                listenable: Listenable.merge([
                  _nomController,
                  _descriptionController,
                ]),
                builder: (context, _) {
                  return ProjectCard(
                    nomProjet:    _nomController.text.isEmpty
                        ? 'Nom du projet'
                        : _nomController.text,
                    description:  _descriptionController.text,
                    couleur:      _couleurSelectionnee,
                    nombreTaches: 0,
                    onTap:       null,
                    onModifier:  null,
                    onSupprimer: null,
                  );
                },
              ),
              const SizedBox(height: 32),

              Consumer<ProjectProvider>(
                builder: (context, projectProvider, _) {
                  return CustomButton(
                    text:      _estModification ? AppStrings.edit : AppStrings.add,
                    icon:      _estModification ? Icons.edit : Icons.add,
                    isLoading: projectProvider.isLoading,
                    onPressed: _sauvegarder,
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}