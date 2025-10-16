import 'package:flutter/material.dart';


class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Lista de widgets para las acciones como el boton de perfil
  final List<Widget>? actions;

  const MainAppBar({super.key, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF074250),
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset(
            'assets/icono.png',
            height: 32,
          ),
          const SizedBox(width: 12),
          const Text('Vota UTEM'),
        ],
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}