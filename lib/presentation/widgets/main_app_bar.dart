import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;

  const MainAppBar({super.key, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Usamos el color hexadecimal que nos diste
      backgroundColor: const Color(0xFF074250),
      // El color de los iconos y el texto del AppBar será blanco
      foregroundColor: Colors.white,
      title: Row(
        children: [
          // Asegúrate de que tu icono esté en la carpeta 'assets'
          Image.asset(
            'assets/icono.png', // Revisa que esta ruta sea correcta
            height: 32, // Ajusta el tamaño como prefieras
          ),
          const SizedBox(width: 12),
          const Text('Vota UTEM'),
        ],
      ),
      // Pasamos las acciones (como el botón de perfil) que cada pantalla necesite
      actions: actions,
    );
  }

  // Esto es necesario para que Flutter sepa qué altura tiene nuestro AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}