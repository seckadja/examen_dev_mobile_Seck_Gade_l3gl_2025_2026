import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/Project.dart';

class ProjectFormScreen extends StatefulWidget {
  final Project? projet;
  const ProjectFormScreen({Key? key, this.projet}) : super(key: key);

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projet != null
            ? 'Modifier le projet'
            : 'Nouveau projet'),
      ),
      body: Center(
        child: Text('Formulaire à venir...'),
      ),
    );
  }
}