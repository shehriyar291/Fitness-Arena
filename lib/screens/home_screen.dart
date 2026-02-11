import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/member.dart';
import '../providers/member_provider.dart';
import '../providers/home_ui_provider.dart';
import '../services/pdf_service.dart';
import 'add_edit_member_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<String> months = [
    'All',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeUIProvider(),
      child: Consumer2<MemberProvider, HomeUIProvider>(
        builder: (context, memberProvider, uiProvider, _) {
          final filteredMembers = memberProvider.filterMembers(
            searchQuery: uiProvider.searchQuery,
            selectedMonth: uiProvider.selectedMonth,
            selectedYear: uiProvider.selectedYear,
          );
          final allMembers = memberProvider.members;

          List<String> availableYears() {
            final years = <String>{'All'};
            for (final member in allMembers) {
              years.add(member.registrationDate.year.toString());
            }
            final list = years.toList()
              ..sort((a, b) {
                if (a == 'All') return -1;
                if (b == 'All') return 1;
                return int.parse(b).compareTo(int.parse(a));
              });
            return list;
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Members'),
              elevation: 0,
              centerTitle: true,
            ),
            body: Column(
              children: [
                // Search Bar
                Container(
                  color: const Color.fromARGB(
                    255,
                    73,
                    146,
                    248,
                  ).withOpacity(0.08),
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: uiProvider.setSearchQuery,
                    decoration: InputDecoration(
                      hintText:
                          'Search by name, reg number, address, or phone...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: uiProvider.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => uiProvider.setSearchQuery(''),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),

                // Year Filter
                Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Text(
                          'Year: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        ...availableYears().map((year) {
                          final isSelected = uiProvider.selectedYear == year;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(year),
                              selected: isSelected,
                              onSelected: (_) =>
                                  uiProvider.setSelectedYear(year),
                              backgroundColor: isSelected
                                  ? Colors.deepPurple
                                  : Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.deepPurple,
                                fontWeight: FontWeight.w600,
                              ),
                              side: BorderSide(
                                color: Colors.deepPurple.withOpacity(0.5),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),

                // Month Filter
                Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Text(
                          'Month: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        ...months.map((month) {
                          final isSelected = uiProvider.selectedMonth == month;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(month),
                              selected: isSelected,
                              onSelected: (_) =>
                                  uiProvider.setSelectedMonth(month),
                              backgroundColor: isSelected
                                  ? Colors.deepPurple
                                  : Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.deepPurple,
                                fontWeight: FontWeight.w600,
                              ),
                              side: BorderSide(
                                color: Colors.deepPurple.withOpacity(0.5),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),

                // Results count
                Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Showing ${filteredMembers.length} of ${allMembers.length} members',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Members List
                Expanded(
                  child: filteredMembers.isEmpty
                      ? SingleChildScrollView(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  uiProvider.searchQuery.isNotEmpty ||
                                          uiProvider.selectedMonth != 'All'
                                      ? 'No members found'
                                      : 'No members yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  uiProvider.searchQuery.isNotEmpty ||
                                          uiProvider.selectedMonth != 'All'
                                      ? 'Try adjusting your filters'
                                      : 'Add a new member to get started',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredMembers.length,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final member = filteredMembers[index];
                            final originalIndex = allMembers.indexWhere(
                              (m) => m.key == member.key,
                            );
                            final id = member.key.toString();
                            final expanded = uiProvider.isExpanded(id);

                            if (!expanded) {
                              // Collapsed (shrink) view: small avatar showing P/U and reg no + menu
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () => uiProvider.toggleExpanded(id),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundColor: member.isPaid
                                              ? Colors.green
                                              : Colors.red,
                                          child: Text(
                                            member.isPaid ? 'P' : 'U',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                member.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Reg #: ${member.registrationNumber}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuButton(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: const Text('View Details'),
                                              onTap: () => _showMemberDetails(
                                                context,
                                                member,
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: const Text('Export PDF'),
                                              onTap: () =>
                                                  PDFService.generateMemberPDF(
                                                    member,
                                                  ),
                                            ),
                                            PopupMenuItem(
                                              child: const Text('Toggle Fee'),
                                              onTap: () => memberProvider
                                                  .toggleFeeStatus(
                                                    originalIndex,
                                                  ),
                                            ),
                                            PopupMenuItem(
                                              child: const Text('Edit'),
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      AddEditMemberScreen(
                                                        member: member,
                                                        index: originalIndex,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onTap: () =>
                                                  _showDeleteConfirmation(
                                                    context,
                                                    originalIndex,
                                                    memberProvider,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            // Expanded view (full details)
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                onTap: () => uiProvider.toggleExpanded(id),
                                leading: CircleAvatar(
                                  backgroundColor: member.isPaid
                                      ? Colors.green
                                      : Colors.red,
                                  child: Text(
                                    member.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  member.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      'Address: ${member.address}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Reg #: ${member.registrationNumber}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    Text(
                                      'Amount: Rs ${member.amount.toStringAsFixed(2)}',
                                    ),
                                    Text('Month: ${member.registrationMonth}'),
                                    if (member.phone != null)
                                      Text('Phone: ${member.phone}'),
                                    const SizedBox(height: 4),
                                    Wrap(
                                      children: [
                                        Chip(
                                          label: Text(
                                            member.isPaid ? 'Paid' : 'Unpaid',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          backgroundColor: member.isPaid
                                              ? Colors.green
                                              : Colors.orange,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Chip(
                                          label: Text(
                                            member.memberType ?? 'Basic',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          backgroundColor: _getMemberTypeColor(
                                            member.memberType ?? 'Basic',
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: const Text('View Details'),
                                      onTap: () =>
                                          _showMemberDetails(context, member),
                                    ),
                                    PopupMenuItem(
                                      child: const Text('Export PDF'),
                                      onTap: () =>
                                          PDFService.generateMemberPDF(member),
                                    ),
                                    PopupMenuItem(
                                      child: const Text('Toggle Fee'),
                                      onTap: () => memberProvider
                                          .toggleFeeStatus(originalIndex),
                                    ),
                                    PopupMenuItem(
                                      child: const Text('Edit'),
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => AddEditMemberScreen(
                                            member: member,
                                            index: originalIndex,
                                          ),
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onTap: () => _showDeleteConfirmation(
                                        context,
                                        originalIndex,
                                        memberProvider,
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
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const AddEditMemberScreen(),
                ),
              ),
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Color _getMemberTypeColor(String type) {
    switch (type) {
      case 'Premium':
        return Colors.purple;
      case 'VIP':
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }

  void _showMemberDetails(BuildContext context, Member member) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      member.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              _buildDetailRow('Address', member.address),
              _buildDetailRow('Phone', member.phone ?? 'N/A'),
              _buildDetailRow('Fee Amount', 'Rs ${member.amount}'),
              _buildDetailRow('Status', member.isPaid ? 'Paid' : 'Unpaid'),
              _buildDetailRow('Member Type', member.memberType ?? 'Basic'),
              _buildDetailRow('Registration Month', member.registrationMonth),
              _buildDetailRow(
                'Registration Date',
                DateFormat('dd MMM yyyy').format(member.registrationDate),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    int index,
    MemberProvider memberProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: const Text('Are you sure you want to delete this member?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              memberProvider.deleteMember(index);
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Member deleted')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
