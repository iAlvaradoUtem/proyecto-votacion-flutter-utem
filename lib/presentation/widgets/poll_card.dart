import 'package:flutter/material.dart';
import 'package:flutter_app_nueva/data/models/encuesta_model.dart';
import 'package:flutter_app_nueva/presentation/screens/poll_results_screen.dart';
import 'package:flutter_app_nueva/presentation/screens/vote_detail_screen.dart';

// Definimos los dos posibles comportamientos de la tarjeta
enum CardMode { vote, results }

class PollCard extends StatelessWidget {
  final Encuesta encuesta;
  final CardMode mode; // Añadimos el nuevo parámetro

  const PollCard({
    super.key,
    required this.encuesta,
    this.mode = CardMode.vote, // Por defecto, el modo es 'votar'
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(encuesta.name),
        subtitle: Text('${encuesta.options.length} opciones'),
        trailing: Icon(
          encuesta.active ? Icons.check_circle : Icons.cancel,
          color: encuesta.active ? Colors.green : Colors.red,
        ),
        onTap: () {
          // --- LÓGICA DE NAVEGACIÓN ACTUALIZADA ---
          // Verificamos en qué modo está la tarjeta
          if (mode == CardMode.vote) {
            // Si el modo es 'votar', navegamos a la pantalla de detalle para votar
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VoteDetailScreen(pollToken: encuesta.token),
              ),
            );
          } else {
            // Si el modo es 'resultados', navegamos a la pantalla de resultados
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PollResultsScreen(pollToken: encuesta.token),
              ),
            );
          }
          // ------------------------------------------
        },
      ),
    );
  }
}