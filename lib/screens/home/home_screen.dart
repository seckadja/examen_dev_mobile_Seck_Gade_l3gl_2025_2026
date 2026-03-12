import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/project_provider.dart';
import '../../widgets/common/custom_button.dart';

// Les 4 onglets dans leurs fichiers separes
import '../auth/login_screen.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/projects_tab.dart';
import 'tabs/tasks_tab.dart';
import 'tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0;

  final List<String> _titles = [
    'Dashboard',
    'Projets',
    'Taches',
    'Profil',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chargerDonnees();
    });
  }

  // Charger les projets de l'utilisateur connecte
  Future<void> _chargerDonnees() async {
    final authProvider    = Provider.of<AuthProvider>(context, listen: false);
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id;
    if (userId != null) {
      await projectProvider.loadProjects(userId);
    }
  }

  // Changer d'onglet
  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    //On Ferme le Drawer s'il est ouvert
    Navigator.of(context).maybePop();
  }

  // Deconnexion
  Future<void> _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider    = context.watch<AuthProvider>();
    final String userName     = authProvider.currentUser?.name  ?? 'Utilisateur';
    final String userEmail    = authProvider.currentUser?.email ?? '';
    final String avatarLetter = userName[0].toUpperCase();

    return Scaffold(

      // AppBar
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
      ),

      // Drawer
      drawer: Drawer(
        child: Column(
          children: [

            // En-tete : avatar, nom, email
            UserAccountsDrawerHeader(
              accountName: Text(
                userName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: Text(userEmail),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  avatarLetter,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              decoration: const BoxDecoration(color: Colors.blue),
            ),

            // Items de navigation
            _buildDrawerItem(icon: Icons.dashboard, label: 'Dashboard', index: 0),
            _buildDrawerItem(icon: Icons.folder,    label: 'Projets',   index: 1),
            _buildDrawerItem(icon: Icons.list_alt,  label: 'Taches',    index: 2),
            _buildDrawerItem(icon: Icons.person,    label: 'Profil',    index: 3),

            const Divider(),

            // Bouton deconnexion
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CustomButton(
                text:       'Deconnexion',
                icon:       Icons.logout,
                isOutlined: true,
                color:      Colors.red,
                onPressed:  _logout,
              ),
            ),

          ],
        ),
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: [
          const DashboardTab(),
          const ProjectsTab(),
          const TasksTab(),
          ProfileTab(onLogout: _logout),
        ],
      ),

      //BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.folder),    label: 'Projets'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt),  label: 'Taches'),
          BottomNavigationBarItem(icon: Icon(Icons.person),    label: 'Profil'),
        ],
      ),


      floatingActionButton: Visibility(
        visible: _currentIndex == 0 || _currentIndex == 1,
        child: FloatingActionButton(
          onPressed: () {
            // TODO: naviguer vers ProjectFormScreen
          },
          backgroundColor: Colors.blue,
          tooltip: 'Nouveau projet',
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),

    );
  }


  Widget _buildDrawerItem({
    required IconData icon,
    required String   label,
    required int      index,
  }) {
    final bool isSelected = _currentIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.grey,
      ),
      title: Text(
        label,
        style: TextStyle(
          color:      isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.blue.withOpacity(0.1),
      onTap: () => _onTabChanged(index),
    );
  }

}