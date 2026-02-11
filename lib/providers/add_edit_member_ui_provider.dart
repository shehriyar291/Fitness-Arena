import 'package:flutter/material.dart';
import '../models/member.dart';
import '../services/auth_service.dart';
import 'member_provider.dart';

class AddEditMemberUIProvider extends ChangeNotifier {
  late TextEditingController nameController;
  late TextEditingController fatherNameController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController amountController;
  late TextEditingController monthController;
  late TextEditingController idCardController;
  late TextEditingController registrationNumberController;

  bool isPaid = false;
  DateTime selectedDate = DateTime.now();
  String selectedMemberType = 'Basic';

  final List<String> months = [
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

  final List<String> memberTypes = ['Basic', 'Premium', 'VIP'];

  AddEditMemberUIProvider({
    Member? member,
    required MemberProvider memberProvider,
  }) {
    if (member != null) {
      nameController = TextEditingController(text: member.name);
      fatherNameController = TextEditingController(
        text: member.fatherName ?? '',
      );
      addressController = TextEditingController(text: member.address);
      phoneController = TextEditingController(text: member.phone ?? '');
      amountController = TextEditingController(text: member.amount.toString());
      monthController = TextEditingController(text: member.registrationMonth);
      idCardController = TextEditingController(text: member.idCardNumber ?? '');
      registrationNumberController = TextEditingController(
        text: member.registrationNumber,
      );
      isPaid = member.isPaid;
      selectedDate = member.registrationDate;
      selectedMemberType = member.memberType ?? 'Basic';
    } else {
      nameController = TextEditingController();
      fatherNameController = TextEditingController();
      addressController = TextEditingController();
      phoneController = TextEditingController();
      amountController = TextEditingController();
      monthController = TextEditingController(
        text: months[DateTime.now().month - 1],
      );
      idCardController = TextEditingController();
      registrationNumberController = TextEditingController();
      isPaid = false;
      selectedMemberType = 'Basic';

      _generateRegistrationNumber(memberProvider);
    }
  }

  void _generateRegistrationNumber(MemberProvider memberProvider) {
    final currentMonth = monthController.text;
    final currentYear = DateTime.now().year.toString().substring(2);

    int monthYearCount = 0;
    for (final member in memberProvider.members) {
      final memberYear = member.registrationDate.year.toString().substring(2);
      if (member.registrationMonth == currentMonth &&
          memberYear == currentYear) {
        monthYearCount++;
      }
    }

    final regNumber = AuthService.generateRegistrationNumber(
      currentMonth,
      monthYearCount,
    );
    registrationNumberController.text = regNumber;
    notifyListeners();
  }

  void setMemberType(String value) {
    selectedMemberType = value;
    notifyListeners();
  }

  void setMonth(String value, MemberProvider memberProvider) {
    monthController.text = value;
    _generateRegistrationNumber(memberProvider);
    notifyListeners();
  }

  void setIsPaid(bool value) {
    isPaid = value;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    fatherNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    amountController.dispose();
    monthController.dispose();
    idCardController.dispose();
    registrationNumberController.dispose();
    super.dispose();
  }
}
