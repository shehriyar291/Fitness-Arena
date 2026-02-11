import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/member.dart';
import '../providers/member_provider.dart';
import '../services/pdf_service.dart';
import '../providers/dashboard_ui_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardUIProvider(),
      child: Consumer2<MemberProvider, DashboardUIProvider>(
        builder: (context, memberProvider, uiProvider, _) {
          final members = memberProvider.members;

          final selectedMonth = uiProvider.selectedMonth;

          // Filter members by selected month/year
          final currentMonthMembers = members
              .where(
                (m) =>
                    m.registrationDate.month == selectedMonth.month &&
                    m.registrationDate.year == selectedMonth.year,
              )
              .toList();

          // Paid members in current month
          final paidMembers = currentMonthMembers
              .where((m) => m.isPaid)
              .toList();

          // Pending (unpaid) members in current month
          final pendingMembers = currentMonthMembers
              .where((m) => !m.isPaid)
              .toList();

          final totalMembers = members.length;
          final monthlyRevenue = paidMembers.fold<double>(
            0,
            (sum, m) => sum + m.amount,
          );
          final totalPotentialRevenue = currentMonthMembers.fold<double>(
            0,
            (sum, m) => sum + m.amount,
          );

          return Scaffold(
            appBar: AppBar(
              title: const Text('Dashboard'),
              centerTitle: true,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Fitness Arena',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(selectedMonth),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Month Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: uiProvider.prevMonth,
                      ),
                      Text(
                        DateFormat('MMM yyyy').format(selectedMonth),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: uiProvider.nextMonth,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Key Metrics Row 1
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showMemberListDialog(
                            context,
                            'All Members',
                            members,
                          ),
                          child: _buildStatCard(
                            'Total Members',
                            totalMembers.toString(),
                            Icons.people,
                            Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showMemberListDialog(
                            context,
                            'Paid This Month',
                            paidMembers,
                          ),
                          child: _buildStatCard(
                            'Paid This Month',
                            paidMembers.length.toString(),
                            Icons.check_circle,
                            Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Key Metrics Row 2
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showMemberListDialog(
                            context,
                            'Pending Payment',
                            pendingMembers,
                          ),
                          child: _buildStatCard(
                            'Pending Payment',
                            pendingMembers.length.toString(),
                            Icons.pending_actions,
                            Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showMemberListDialog(
                            context,
                            'Members This Month',
                            currentMonthMembers,
                          ),
                          child: _buildStatCard(
                            'Members This Month',
                            currentMonthMembers.length.toString(),
                            Icons.trending_up,
                            Colors.purple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Revenue Section
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Revenue Overview',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Monthly Collected',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Rs ${monthlyRevenue.toStringAsFixed(0)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Potential Revenue',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Rs ${totalPotentialRevenue.toStringAsFixed(0)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: totalPotentialRevenue > 0
                                  ? monthlyRevenue / totalPotentialRevenue
                                  : 0,
                              minHeight: 8,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Collection Rate: ${totalPotentialRevenue > 0 ? ((monthlyRevenue / totalPotentialRevenue) * 100).toStringAsFixed(1) : 0}%',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Member Types Distribution
                  _buildMemberTypeDistribution(context, members),
                  const SizedBox(height: 24),

                  // Quick Stats
                  Text(
                    'Quick Stats',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildStatRow(
                            'Average Fee Per Member',
                            totalMembers > 0
                                ? 'Rs ${(totalPotentialRevenue / totalMembers).toStringAsFixed(0)}'
                                : 'Rs 0',
                            Colors.indigo,
                          ),
                          const Divider(),
                          _buildStatRow(
                            'Collection Efficiency',
                            totalPotentialRevenue > 0
                                ? '${((monthlyRevenue / totalPotentialRevenue) * 100).toStringAsFixed(1)}%'
                                : '0%',
                            Colors.teal,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // PDF Export Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      await PDFService.generateMonthlyReportPDF(
                        currentMonthMembers,
                        selectedMonth,
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Export Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B5DFF),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
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

  Widget _buildMemberTypeDistribution(
    BuildContext context,
    List<Member> members,
  ) {
    final basicCount = members
        .where((m) => m.memberType == 'Basic' || m.memberType == null)
        .length;
    final premiumCount = members.where((m) => m.memberType == 'Premium').length;
    final vipCount = members.where((m) => m.memberType == 'VIP').length;
    final total = members.length;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Member Distribution',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (basicCount > 0)
              _buildDistributionBar('Basic', basicCount, total, Colors.blue),
            if (premiumCount > 0)
              _buildDistributionBar(
                'Premium',
                premiumCount,
                total,
                Colors.purple,
              ),
            if (vipCount > 0)
              _buildDistributionBar('VIP', vipCount, total, Colors.amber),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionBar(String type, int count, int total, Color color) {
    final percentage = total > 0 ? (count / total) * 100 : 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(type, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                '$count ($percentage%)',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  void _showMemberListDialog(
    BuildContext context,
    String title,
    List<Member> members,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                member.name,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  member.isPaid ? 'Paid' : 'Pending',
                                  style: TextStyle(
                                    color: member.isPaid
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            member.phone ?? 'N/A',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rs ${member.amount}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
