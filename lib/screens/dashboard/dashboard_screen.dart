import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/user_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  Future<void> _refresh() async {
    await Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child:
            provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                ? Center(child: Text('Error: ${provider.error}'))
                : ListView.builder(
                  itemCount: provider.users.length,
                  itemBuilder: (context, index) {
                    return UserTile(user: provider.users[index]);
                  },
                ),
      ),
    );
  }
}
