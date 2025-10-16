import 'package:flutter/material.dart';
import 'package:flutter_app_nueva/presentation/screens/profile_screen.dart';
import 'package:flutter_app_nueva/presentation/screens/vote_list_screen.dart';
import 'package:flutter_app_nueva/presentation/widgets/main_app_bar.dart';

// Necesitaremos crear esta nueva pantalla en el siguiente paso.
// De momento la importamos para que no dé error.
import 'results_list_screen.dart'; 

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  // Actualizamos la lista de pantallas para incluir la de resultados
  static const List<Widget> _widgetOptions = <Widget>[
    VoteListScreen(),      // Índice 0: Votar
    ResultsListScreen(),   // Índice 1: Resultados
    ProfileScreen(),       // Índice 2: Perfil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El AppBar se mantiene igual, se mostrará en todas las pestañas
      appBar: const MainAppBar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // --- BARRA DE NAVEGACIÓN INFERIOR ACTUALIZADA ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            // Botón "Votar"
            BottomNavigationBarItem(
              icon: Icon(Icons.how_to_vote), // Icono más representativo
              label: 'Votar',
            ),
            // Botón "Resultados"
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Resultados',
            ),
            // Botón "Perfil"
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      // ------------------------------------------
    );
  }
}