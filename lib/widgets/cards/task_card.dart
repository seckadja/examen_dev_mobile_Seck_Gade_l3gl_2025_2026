import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';


class TaskCard extends StatelessWidget {
  final String titre;
  final String description;
  final String statut;
  final String priorite;
  final DateTime? dateEcheance;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.titre,
    required this.description,
    required this.statut,
    required this.priorite,
    this.dateEcheance,
    this.onTap,
  });

  Color _couleurStatut() {
    if (statut == 'inProgress') return AppColors.statusInProgress;
    if (statut == 'done') return AppColors.statusDone;
    return AppColors.primary;
  }

  String _texteStatut() {
    if (statut == 'inProgress') return AppStrings.statusInProgress;
    if (statut == 'done') return AppStrings.statusDone;
    return AppStrings.statusTodo;
  }

  Color _couleurPriorite() {
    if (priorite == 'high') return AppColors.priorityHigh;
    if (priorite == 'medium') return AppColors.priorityMedium;
    return AppColors.priorityLow;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: AppColors.border.withOpacity(0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      titre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _couleurStatut().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _texteStatut(),
                      style: TextStyle(
                        color: _couleurStatut(),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.flag, size: 16, color: _couleurPriorite()),
                  const SizedBox(width: 4),
                  Text(
                    priorite == 'high'
                        ? AppStrings.priorityHigh
                        : priorite == 'medium'
                        ? AppStrings.priorityMedium
                        : AppStrings.priorityLow,
                    style: TextStyle(color: _couleurPriorite(), fontSize: 12),
                  ),
                  const Spacer(),
                  Visibility(
                    visible: dateEcheance != null,
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 13, color: AppColors.textDisable),
                        const SizedBox(width: 3),
                        Text(
                          dateEcheance != null
                              ? '${dateEcheance!.day}/${dateEcheance!.month}/${dateEcheance!.year}'
                              : '',
                          style: const TextStyle(fontSize: 12, color: AppColors.textDisable),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}