import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/Project.dart';
import '../../models/Task.dart';
import '../../providers/auth_provider.dart';
import '../../providers/project_provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class TaskFormScreen extends StatefulWidget {

  final String? projectId;
  final Task? task;

  const TaskFormScreen({super.key, this.projectId, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  TaskStatus _status = TaskStatus.todo;
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _selectedDate;


  String? _selectedProjectId;

  @override
  void initState() {
    super.initState();

    // Si un projectId est passé
    _selectedProjectId = widget.projectId?.isNotEmpty == true ? widget.projectId : null;

    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description ?? '';
      _status = widget.task!.status;
      _priority = widget.task!.priority;
      _selectedDate = widget.task!.dueDate;
      _selectedProjectId = widget.task!.projectId;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _enregistrer() async {
    if (_formKey.currentState!.validate()) {

      if (_selectedProjectId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez choisir un projet'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final taskData = Task(
        id: widget.task?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        projectId: _selectedProjectId!,
        createdBy: authProvider.currentUser?.id ?? '',
        status: _status,
        priority: _priority,
        dueDate: _selectedDate,
      );

      if (widget.task == null) {
        await taskProvider.createTask(taskData);
      } else {
        await taskProvider.updateTask(taskData);
      }
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // on récupére la liste des projets
    final projects = Provider.of<ProjectProvider>(context, listen: false).projects;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.task == null ? AppStrings.newTask : AppStrings.editTask,
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          if (widget.task != null)
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.white),
              onPressed: () => _confirmerSuppression(),
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              const Text(
                'Projet',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Choisir un projet'),
                    value: _selectedProjectId,
                    items: projects.map((Project p) {
                      return DropdownMenuItem<String>(
                        value: p.id,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Color(p.color),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(p.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedProjectId = value),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              CustomTextField(
                label: AppStrings.taskTitle,
                controller: _titleController,
                validator: (v) => (v == null || v.isEmpty) ? AppStrings.requiredField : null,
              ),
              const SizedBox(height: 20),

              CustomTextField(
                label: AppStrings.taskDescription,
                controller: _descController,
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              const Text(
                AppStrings.taskStatus,
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _badgeSelector(TaskStatus.todo, AppStrings.statusTodo, true),
                  _badgeSelector(TaskStatus.inProgress, AppStrings.statusInProgress, true),
                  _badgeSelector(TaskStatus.done, AppStrings.statusDone, true),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                AppStrings.taskPriority,
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _badgeSelector(TaskPriority.low, AppStrings.priorityLow, false),
                  _badgeSelector(TaskPriority.medium, AppStrings.priorityMedium, false),
                  _badgeSelector(TaskPriority.high, AppStrings.priorityHigh, false),
                ],
              ),
              const SizedBox(height: 25),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  AppStrings.taskDueDate,
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                subtitle: Text(
                  _selectedDate == null
                      ? 'Aucune date choisie'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
                trailing: const Icon(Icons.calendar_month, color: AppColors.primary),
                onTap: _choisirDate,
              ),

              const SizedBox(height: 40),
              CustomButton(
                text: widget.task == null ? AppStrings.add : AppStrings.save,
                onPressed: _enregistrer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badgeSelector(dynamic value, String label, bool isStatus) {
    bool selected = isStatus ? (_status == value) : (_priority == value);

    Color activeColor = AppColors.primary;
    if (!isStatus) {
      if (value == TaskPriority.high) activeColor = AppColors.priorityHigh;
      if (value == TaskPriority.medium) activeColor = AppColors.priorityMedium;
      if (value == TaskPriority.low) activeColor = AppColors.priorityLow;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          if (isStatus) _status = value;
          else _priority = value;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? activeColor : AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? activeColor : AppColors.border),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmerSuppression() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteTask),
        content: const Text(AppStrings.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              await Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(widget.task!.id);
              if (mounted) {
                Navigator.pop(ctx);
                Navigator.pop(context);
              }
            },
            child: const Text(AppStrings.delete, style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}