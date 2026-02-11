import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/member.dart';
import '../providers/member_provider.dart';

import '../providers/add_edit_member_ui_provider.dart';

class AddEditMemberScreen extends StatelessWidget {
  final Member? member;
  final int? index;

  const AddEditMemberScreen({super.key, this.member, this.index});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddEditMemberUIProvider(
        member: member,
        memberProvider: context.read<MemberProvider>(),
      ),
      child: Consumer2<MemberProvider, AddEditMemberUIProvider>(
        builder: (context, memberProvider, uiProvider, _) {
          void _saveMember() {
            // Debug prints
            print('DEBUG - Name: "${uiProvider.nameController.text}"');
            print('DEBUG - Address: "${uiProvider.addressController.text}"');
            print('DEBUG - Amount: "${uiProvider.amountController.text}"');
            print('DEBUG - Month: "${uiProvider.monthController.text}"');

            if (uiProvider.nameController.text.trim().isEmpty ||
                uiProvider.addressController.text.trim().isEmpty ||
                uiProvider.amountController.text.trim().isEmpty ||
                uiProvider.monthController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill all required fields'),
                ),
              );
              return;
            }

            try {
              final amount = double.parse(
                uiProvider.amountController.text.trim(),
              );

              final memberModel = Member(
                name: uiProvider.nameController.text.trim(),
                address: uiProvider.addressController.text.trim(),
                phone: uiProvider.phoneController.text.trim(),
                amount: amount,
                isPaid: uiProvider.isPaid,
                registrationMonth: uiProvider.monthController.text.trim(),
                registrationDate: uiProvider.selectedDate,
                memberType: uiProvider.selectedMemberType,
                idCardNumber: uiProvider.idCardController.text.isEmpty
                    ? null
                    : uiProvider.idCardController.text.trim(),
                registrationNumber: uiProvider.registrationNumberController.text
                    .trim(),
                fatherName: uiProvider.fatherNameController.text.isEmpty
                    ? null
                    : uiProvider.fatherNameController.text.trim(),
              );

              if (member != null && index != null) {
                memberProvider.updateMember(index!, memberModel);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Member updated successfully')),
                );
              } else {
                memberProvider.addMember(memberModel);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Member added successfully')),
                );
              }

              Navigator.pop(context, true);
            } catch (e) {
              print('Error saving member: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Error: Invalid amount. Please enter a valid number',
                  ),
                ),
              );
            }
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(member != null ? 'Edit Member' : 'Add Member'),
              backgroundColor: Colors.deepPurple,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title
                  Text(
                    'Member Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name Field
                  TextField(
                    controller: uiProvider.nameController,
                    decoration: InputDecoration(
                      labelText: 'Member Name *',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Father Name Field
                  TextField(
                    controller: uiProvider.fatherNameController,
                    decoration: InputDecoration(
                      labelText: 'Father Name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone Field
                  TextField(
                    controller: uiProvider.phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  // Address Field
                  TextField(
                    controller: uiProvider.addressController,
                    decoration: InputDecoration(
                      labelText: 'Address *',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // ID Card Number Field
                  TextField(
                    controller: uiProvider.idCardController,
                    decoration: InputDecoration(
                      labelText: 'ID Card Number (Optional)',
                      prefixIcon: const Icon(Icons.credit_card),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Registration Number Field (Auto-generated, Read-only)
                  TextField(
                    controller: uiProvider.registrationNumberController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Registration Number',
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      helperText: 'Auto-generated',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Member Type
                  DropdownButtonFormField<String>(
                    value: uiProvider.selectedMemberType,
                    decoration: InputDecoration(
                      labelText: 'Member Type',
                      prefixIcon: const Icon(Icons.card_membership),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    items: uiProvider.memberTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        uiProvider.setMemberType(value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Section Title - Fees
                  Text(
                    'Fee Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Amount Field
                  TextField(
                    controller: uiProvider.amountController,
                    decoration: InputDecoration(
                      labelText: 'Monthly Fee Amount *',
                      prefixIcon: const Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Registration Month
                  DropdownButtonFormField<String>(
                    value: uiProvider.monthController.text.isEmpty
                        ? uiProvider.months[0]
                        : uiProvider.monthController.text,
                    decoration: InputDecoration(
                      labelText: 'Registration Month *',
                      prefixIcon: const Icon(Icons.calendar_month),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    items: uiProvider.months.map((month) {
                      return DropdownMenuItem(value: month, child: Text(month));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        uiProvider.setMonth(value, memberProvider);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Fee Status
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CheckboxListTile(
                      title: const Text('Fee Paid'),
                      subtitle: Text(
                        uiProvider.isPaid
                            ? 'Payment received'
                            : 'Payment pending',
                      ),
                      value: uiProvider.isPaid,
                      onChanged: (value) {
                        uiProvider.setIsPaid(value ?? false);
                      },
                      activeColor: Colors.green,
                      tileColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Member Type Info Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Member Types:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• Basic: Standard membership',
                          style: TextStyle(fontSize: 12),
                        ),
                        const Text(
                          '• Premium: Extended facilities',
                          style: TextStyle(fontSize: 12),
                        ),
                        const Text(
                          '• VIP: All facilities included',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveMember,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Save Member',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
