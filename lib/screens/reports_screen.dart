import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/member.dart';
import '../providers/member_provider.dart';
import '../providers/reports_ui_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportsUIProvider(),
      child: Consumer2<MemberProvider, ReportsUIProvider>(
        builder: (context, memberProvider, uiProvider, _) {
          final members = memberProvider.members;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Reports & Analytics'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Report Type Selection
                  Text(
                    'Select Report Type',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildReportTypeChip('All Members', uiProvider),
                        _buildReportTypeChip('Paid Members', uiProvider),
                        _buildReportTypeChip('Unpaid Members', uiProvider),
                        _buildReportTypeChip('By Member Type', uiProvider),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Generate Reports Section
                  _buildReportCard(
                    title: 'Monthly Fee Report',
                    icon: Icons.receipt_long,
                    onTap: () => _showMonthlyReport(context, members),
                  ),
                  const SizedBox(height: 12),
                  _buildReportCard(
                    title: 'Member Summary',
                    icon: Icons.summarize,
                    onTap: () => _showMemberSummary(context, members),
                  ),
                  const SizedBox(height: 12),
                  _buildReportCard(
                    title: 'Revenue Analysis',
                    icon: Icons.bar_chart,
                    onTap: () => _showRevenueAnalysis(context, members),
                  ),
                  const SizedBox(height: 12),
                  _buildReportCard(
                    title: 'Export Data',
                    icon: Icons.download,
                    onTap: () => _showExportOptions(context, members),
                  ),
                  const SizedBox(height: 24),

                  // Quick Stats Box
                  _buildQuickStatsBox(context, members),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportTypeChip(String label, ReportsUIProvider uiProvider) {
    final isSelected = uiProvider.selectedReportType == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => uiProvider.setSelectedReportType(label),
        backgroundColor: isSelected ? Colors.deepPurple : Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.deepPurple,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(color: Colors.deepPurple.withOpacity(0.5)),
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.deepPurple, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Generate and view report',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsBox(BuildContext context, List<Member> members) {
    final totalMembers = members.length;
    final paidCount = members.where((m) => m.isPaid).length;
    final basicCount = members
        .where((m) => m.memberType == 'Basic' || m.memberType == null)
        .length;
    final premiumCount = members.where((m) => m.memberType == 'Premium').length;
    final vipCount = members.where((m) => m.memberType == 'VIP').length;
    final totalRevenue = members.fold<double>(0, (sum, m) => sum + m.amount);
    final collectedRevenue = members.fold<double>(
      0,
      (sum, m) => sum + (m.isPaid ? m.amount : 0),
    );

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Statistics',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatLine(
              'Total Members',
              totalMembers.toString(),
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildStatLine(
              'Active/Paid',
              '$paidCount / $totalMembers',
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildStatLine(
              'Basic Members',
              basicCount.toString(),
              Colors.indigo,
            ),
            const SizedBox(height: 12),
            _buildStatLine(
              'Premium Members',
              premiumCount.toString(),
              Colors.purple,
            ),
            const SizedBox(height: 12),
            _buildStatLine('VIP Members', vipCount.toString(), Colors.amber),
            const SizedBox(height: 12),
            _buildStatLine(
              'Total Potential Revenue',
              '₹${totalRevenue.toStringAsFixed(2)}',
              Colors.teal,
            ),
            const SizedBox(height: 12),
            _buildStatLine(
              'Collected Revenue',
              '₹${collectedRevenue.toStringAsFixed(2)}',
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatLine(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }

  void _showMonthlyReport(BuildContext context, List<Member> members) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Monthly Fee Report'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Member-wise Fee Summary',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...members.map((member) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          member.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        flex: 0,
                        child: Text(
                          'Rs ${member.amount}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        flex: 0,
                        child: Chip(
                          label: Text(
                            member.isPaid ? 'Paid' : 'Unpaid',
                            style: const TextStyle(fontSize: 10),
                          ),
                          backgroundColor: member.isPaid
                              ? Colors.green
                              : Colors.orange,
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMemberSummary(BuildContext context, List<Member> members) {
    final summary = {
      'Total Members': members.length,
      'Paid': members.where((m) => m.isPaid).length,
      'Unpaid': members.where((m) => !m.isPaid).length,
      'Active': members.where((m) => m.isActive).length,
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Member Summary'),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: summary.entries
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(e.key, overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Text(
                              e.value.toString(),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRevenueAnalysis(BuildContext context, List<Member> members) {
    final totalRevenue = members.fold<double>(0, (sum, m) => sum + m.amount);
    final collectedRevenue = members.fold<double>(
      0,
      (sum, m) => sum + (m.isPaid ? m.amount : 0),
    );
    final pendingRevenue = totalRevenue - collectedRevenue;
    final collectionRate = totalRevenue > 0
        ? ((collectedRevenue / totalRevenue) * 100).toStringAsFixed(1)
        : '0';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revenue Analysis'),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRevenueRow(
                  'Total Potential Revenue',
                  'Rs ${totalRevenue.toStringAsFixed(2)}',
                  Colors.blue,
                ),
                const SizedBox(height: 12),
                _buildRevenueRow(
                  'Collected Revenue',
                  'Rs ${collectedRevenue.toStringAsFixed(2)}',
                  Colors.green,
                ),
                const SizedBox(height: 12),
                _buildRevenueRow(
                  'Pending Revenue',
                  'Rs ${pendingRevenue.toStringAsFixed(2)}',
                  Colors.orange,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Collection Rate',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '$collectionRate%',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueRow(String label, String value, Color color) {
    return Row(
      children: [
        Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 12),
        Flexible(
          flex: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
      ],
    );
  }

  void _showExportOptions(BuildContext context, List<Member> members) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export to CSV'),
              subtitle: const Text('Download member data as CSV'),
              onTap: () {
                Navigator.pop(context);
                _exportCSV(context, members);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Print Report'),
              subtitle: const Text('Print current member list'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Print feature coming soon!')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _exportCSV(BuildContext context, List<Member> members) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export feature will be available in next update!'),
      ),
    );
  }
}
