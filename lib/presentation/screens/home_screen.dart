import 'package:flutter/material.dart';
import 'package:flutter_app_nueva/presentation/screens/main_scaffold.dart';

// Punto de entrada despues de iniciar sesion
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirige a la navegacion principal
    return const MainScaffold();
  }
}