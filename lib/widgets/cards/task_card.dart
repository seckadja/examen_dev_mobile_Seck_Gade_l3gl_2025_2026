import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String titre;
  final String description;
  final String statut; // 'todo', 'inProgress', 'done'
  final String priorite; // 'low', 'medium', 'high'
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

  //On  Retourne la couleur selon le statut
  Color _couleurStatut() {
    if (statut == 'inProgress') return Colors.orange;
    if (statut == 'done') return Colors.green;
    return Colors.blue; // todo
  }

  //On Retourne le texte lisible du statut
  String _texteStatut() {
    if (statut == 'inProgress') return 'En cours';
    if (statut == 'done') return 'Terminée';
    return 'À faire';
  }

  //On Retourne la couleur selon la priorité
  Color _couleurPriorite() {
    if (priorite == 'high') return Colors.red;
    if (priorite == 'medium') return Colors.orange;
    return Colors.grey; // low
  }

  //On Retourne l'icône selon la priorité
  IconData _iconePriorite() {
    if (priorite == 'high') return Icons.arrow_upward;
    if (priorite == 'medium') return Icons.remove;
    return Icons.arrow_downward;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ligne du haut : titre + badge statut
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      titre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  // Badge de statut
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _couleurStatut().withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _couleurStatut()),
                    ),
                    child: Text(
                      _texteStatut(),
                      style: TextStyle(
                        color: _couleurStatut(),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Description (visible seulement si non vide)
              Visibility(
                visible: description.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Ligne du bas : priorité + date d'échéance
              Row(
                children: [
                  // Indicateur de priorité
                  Icon(
                    _iconePriorite(),
                    size: 16,
                    color: _couleurPriorite(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    priorite == 'high'
                        ? 'Haute'
                        : priorite == 'medium'
                        ? 'Moyenne'
                        : 'Basse',
                    style: TextStyle(
                      color: _couleurPriorite(),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  // Date d'échéance (visible seulement si définie)
                  Visibility(
                    visible: dateEcheance != null,
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text(
                          dateEcheance != null
                              ? '${dateEcheance!.day}/${dateEcheance!.month}/${dateEcheance!.year}'
                              : '',
                          style:
                          const TextStyle(fontSize: 12, color: Colors.grey),
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