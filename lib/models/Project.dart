
class Project {
  final String id;
  final String name;
  final String? description;
  final String userId;
  final int color;
  final DateTime createdAt;

  /// Constructeur
  Project({
    required this.id,
    required this.name,
    this.description,
    required this.userId,
    required this.color,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Copie avec modification
  /// Ex: final updated = project.copyWith(name: 'Nouveau nom')
  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? ownerId,
    int? color,
    DateTime? createdAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: ownerId ?? this.userId,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convertir en Map pour sauvegarder dans SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ownerId': userId,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Créer un Project depuis un Map (lecture depuis SharedPreferences)
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      userId: map['ownerId'] as String,
      color: map['color'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Project(id: $id, name: $name, ownerId: $userId)';
  }
}