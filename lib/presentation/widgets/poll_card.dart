import 'package:flutter/material.dart';
import 'package:flutter_app_nueva/data/models/encuesta_model.dart';
import 'package:flutter_app_nueva/presentation/screens/poll_results_screen.dart';
import 'package:flutter_app_nueva/presentation/screens/vote_detail_screen.dart';

// Define los dos modos en que puede funcionar la tarjeta: para votar o para ver resultados
enum CardMode { vote, results }

// Widget reutilizable para mostrar una encuesta en una lista
class PollCard extends StatelessWidget {
  final Encuesta encuesta;
  final CardMode mode;

  const PollCard({
    super.key,
    required this.encuesta,
    this.mode = CardMode.vote, // El modo por defecto es 'votar'
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
          if (mode == CardMode.vote) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VoteDetailScreen(pollToken: encuesta.token),
              ),
            );
          } else {
            // Si el modo es 'results', va a la pantalla de resultados
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PollResultsScreen(pollToken: encuesta.token),
              ),
            );
          }
        },
      ),
    );
  }
}