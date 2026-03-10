import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double taille;
  final Color? couleur;

  const LoadingIndicator({
    super.key,
    this.taille = 40,
    this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: taille,
        height: taille,
        child: CircularProgressIndicator(
          color: couleur ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}