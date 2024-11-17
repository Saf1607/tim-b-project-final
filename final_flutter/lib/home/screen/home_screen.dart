import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_api/auth/auth.dart';
import 'package:flutter_login_api/home/screen/billing_screen.dart';
import 'package:flutter_login_api/home/screen/change_pass_screen.dart';
import 'package:flutter_login_api/home/screen/edit_profile_screen.dart';
import 'package:flutter_login_api/home/screen/mutation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    EditProfileView(),
    ChangePassView(),
    MutationView(),
    BillingView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Biller Payment'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: _widgetOptions[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            UserAccountsDrawerHeader(
              accountName: Text(
                'Nama', 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text('Username'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://www.example.com/profile.jpg'),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Menu Items
            _buildMenuItem(Icons.home, 'Home', 0),
            _buildMenuItem(Icons.edit, 'Edit Profile', 1),
            _buildMenuItem(Icons.lock, 'Change Password', 2),
            _buildMenuItem(Icons.history, 'Mutation Records', 3),
            _buildMenuItem(Icons.credit_card, 'Billing', 4),
          ],
        ),
      ),
    );
  }

  ListTile _buildMenuItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      selected: _selectedIndex == index,
      selectedTileColor: Colors.blue[50],
      onTap: () {
        _onItemTapped(index);
        Navigator.pop(context); // Close the drawer after selection
      },
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting message
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 20),
              child: Builder(
                builder: (context) {
                  final user = context.select(
                    (AuthCubit auth) => auth.state.user,
                  );
                  return Text(
                    'Hello, ${user?.name ?? 'User'}!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  );
                },
              ),
            ),
    
            // User information card (stretched and moved to top)
            Builder(
              builder: (context) {
                final user = context.select(
                  (AuthCubit auth) => auth.state.user,
                );
                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User ID: ${user?.id ?? 'N/A'}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Name: ${user?.name ?? 'N/A'}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your Balance: Rp. ${user?.balance ?? '0'}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    
            // Logout Button with fresh styling
            ElevatedButton(
              onPressed: () {
                context.read<AuthCubit>().logout();
              },
              child: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                shadowColor: Colors.black.withOpacity(0.15),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}