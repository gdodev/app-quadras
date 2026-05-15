import 'package:flutter/material.dart';

class ComponenteHorario extends StatelessWidget {
  const ComponenteHorario({
    super.key,
    required this.clickContainer,
    this.containerColor,
    required this.textoHorario,
  });

  final void Function() clickContainer;
  final Color? containerColor;
  final String textoHorario;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(),
            color: containerColor,
          ),
          child: Text(textoHorario),
        ),
      ),
    );
  }
}
