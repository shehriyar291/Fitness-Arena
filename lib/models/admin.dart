import 'package:hive/hive.dart';

part 'admin.g.dart';

@HiveType(typeId: 3)
class Admin extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String password;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  bool isActive;

  Admin({
    required this.name,
    required this.password,
    DateTime? createdAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();
}
