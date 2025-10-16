import 'package:flutter/material.dart';

class EmptyDisplay extends StatelessWidget {
  final String message;

  const EmptyDisplay({super.key, this.message = 'No hay datos disponibles'});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
