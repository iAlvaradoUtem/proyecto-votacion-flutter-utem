import 'package:flutter/material.dart';
import 'package:flutter_app_nueva/presentation/screens/main_scaffold.dart'; // <-- Nuevo import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Este widget ahora actúa como el punto de entrada a nuestro layout principal
    // con la barra de navegación inferior.
    return const MainScaffold();
  }
}