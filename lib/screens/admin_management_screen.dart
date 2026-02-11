import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/admin_ui_provider.dart';

class AdminManagementScreen extends StatelessWidget {
  const AdminManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminUIProvider(),
      child: Consumer<AdminUIProvider>(
        builder: (context, ui, _) {
          final admins = ui.admins;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Manage Admins'),
              backgroundColor: Colors.deepPurple,
              centerTitle: true,
            ),
            body: admins.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.admin_panel_settings,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No admins found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: admins.length,
                    itemBuilder: (context, index) {
                      final admin = admins[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Icon(
                              admin.isActive
                                  ? Icons.admin_panel_settings
                                  : Icons.block,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            admin.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Created: ${DateFormat('dd MMM yyyy').format(admin.createdAt)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Status: ${admin.isActive ? 'Active' : 'Inactive'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: admin.isActive
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'delete') {
                                _showDeleteConfirmation(
                                  context,
                                  index,
                                  admin.name,
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    int index,
    String adminName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Admin'),
        content: Text(
          'Are you sure you want to delete admin "$adminName"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = context.read<AdminUIProvider>();
              final ok = await provider.deleteAdmin(index);
              if (!context.mounted) return;
              final messenger = ScaffoldMessenger.of(context);
              if (ok) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Admin "$adminName" deleted')),
                );
              } else {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Failed to delete admin')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
