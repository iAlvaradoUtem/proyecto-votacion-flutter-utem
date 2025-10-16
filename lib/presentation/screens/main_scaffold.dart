import 'package:flutter/material.dart';
import 'package:flutter_app_nueva/presentation/screens/profile_screen.dart';
import 'package:flutter_app_nueva/presentation/screens/vote_list_screen.dart';
import 'package:flutter_app_nueva/presentation/widgets/main_app_bar.dart';
import 'package:flutter_app_nueva/presentation/screens/results_list_screen.dart';

// Contiene la navegacion inferior de la app
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  // Lista de las pantallas que se mostraran en cada pestana
  static const List<Widget> _widgetOptions = <Widget>[
    VoteListScreen(),
    ResultsListScreen(),
    ProfileScreen(),
  ];

  // Se ejecuta cuando el usuario toca una pestana
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      // Muestra la pantalla correspondiente al indice seleccionado
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // Barra de navegacion inferior
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
            BottomNavigationBarItem(
              icon: Icon(Icons.how_to_vote),
              label: 'Votar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Resultados',
            ),
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
    );
  }
}