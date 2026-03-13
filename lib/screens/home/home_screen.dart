import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/project_provider.dart';
import '../../widgets/common/custom_button.dart';
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
    AppStrings.home,
    AppStrings.projects,
    AppStrings.tasks,
    AppStrings.profile,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chargerDonnees();
    });
  }

  Future<void> _chargerDonnees() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id;

    if (userId != null) {
      await projectProvider.loadProjects(userId);
    }
  }

  Future<void> _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabs = [
      const DashboardTab(),
      const ProjectsTab(),
      const TasksTab(),
      ProfileTab(onLogout: _handleLogout),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              accountName: Consumer<AuthProvider>(
                builder: (_, auth, __) => Text(auth.currentUser?.name ?? 'Utilisateur'),
              ),
              accountEmail: Consumer<AuthProvider>(
                builder: (_, auth, __) => Text(auth.currentUser?.email ?? ''),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: AppColors.white,
                child: Icon(Icons.person, size: 40, color: AppColors.primary),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.dashboard,
              label: AppStrings.home,
              index: 0,
            ),
            _buildDrawerItem(
              icon: Icons.folder,
              label: AppStrings.projects,
              index: 1,
            ),
            _buildDrawerItem(
              icon: Icons.list_alt,
              label: AppStrings.tasks,
              index: 2,
            ),
            _buildDrawerItem(
              icon: Icons.person,
              label: AppStrings.profile,
              index: 3,
            ),
            const Spacer(),
            const Divider(color: AppColors.border),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text(
                AppStrings.logout,
                style: TextStyle(color: AppColors.error),
              ),
              onTap: _handleLogout,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      body: _tabs[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textDisable,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: AppStrings.home),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: AppStrings.projects),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: AppStrings.tasks),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: AppStrings.profile),
        ],
      ),

      floatingActionButton: Visibility(
        visible: _currentIndex == 0 || _currentIndex == 1,
        child: FloatingActionButton(
          onPressed: () {
            // Navigation vers ProjectFormScreen
          },
          backgroundColor: AppColors.primary,
          tooltip: 'Nouveau projet',
          child: const Icon(Icons.add, color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _currentIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textDisable,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        setState(() => _currentIndex = index);
        Navigator.pop(context);
      },
    );
  }
}