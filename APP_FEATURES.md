# 🏋️ Professional Gym Management System

A comprehensive Flutter application for managing gym members, tracking fees, and analyzing business metrics with local data persistence.

## ✨ Features

### 📋 Member Management
- ✅ Add, edit, and delete gym members
- ✅ Store member details: Name, Phone, Address, Email
- ✅ Track member types: Basic, Premium, VIP with different pricing
- ✅ Registration month and date tracking
- ✅ Payment status tracking (Paid/Unpaid)
- ✅ Member activation/deactivation status

### 🔍 Search & Filtering
- ✅ Real-time search by name, address, or phone
- ✅ Filter members by registration month
- ✅ Quick month-based record filtering
- ✅ View specific month registrations

### 📊 Dashboard Analytics
- ✅ Total members count
- ✅ Active vs Inactive members
- ✅ Paid vs Unpaid fee status
- ✅ Monthly revenue tracking
- ✅ Collection efficiency metrics
- ✅ Member type distribution (Basic/Premium/VIP)
- ✅ Revenue overview with progress indicators

### 📈 Reports & Analytics
- ✅ Monthly fee reports
- ✅ Member summary statistics
- ✅ Revenue analysis
- ✅ Collection rate calculations
- ✅ Export data options (CSV ready)
- ✅ Print functionality

### 💾 Data Management
- ✅ Local data persistence using Hive
- ✅ No internet required
- ✅ Offline-first approach
- ✅ Automatic data backup

### 🎨 UI/UX
- ✅ Professional Material Design
- ✅ Responsive layout
- ✅ Dark/Light theme support
- ✅ Intuitive navigation
- ✅ Status indicators (color-coded)

## 📱 Screenshots

### Main Screens
1. **Members Screen** - List all gym members with search and filtering
2. **Dashboard** - View key metrics and business insights
3. **Reports** - Generate various reports and export data

## 🛠️ Technologies Used

- **Flutter** - UI Framework
- **Hive** - Local database with NoSQL
- **Intl** - Date and number formatting
- **PDF** - PDF generation capabilities
- **Path Provider** - File system access

## 📦 Project Structure

```
lib/
├── main.dart                    # App entry point
├── main_app.dart               # Bottom navigation wrapper
├── models/
│   └── member.dart             # Member, PaymentRecord, AttendanceRecord
├── screens/
│   ├── home_screen.dart        # Members list with search/filter
│   ├── dashboard_screen.dart   # Analytics & metrics
│   ├── add_edit_member_screen.dart # Add/Edit form
│   └── reports_screen.dart     # Reports & exports
└── services/
    └── database_service.dart   # Database operations
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.10.7 or higher)
- Dart SDK

### Installation

```bash
# Navigate to project
cd d:\projects\learning2

# Get dependencies
flutter pub get

# Generate Hive adapters
flutter pub run build_runner build

# Run the app
flutter run
```

## 📖 Usage Guide

### Adding a Member
1. Go to **Members** tab
2. Click the **+** button
3. Fill in member details:
   - Name (required)
   - Phone number
   - Address (required)
   - Member Type (Basic/Premium/VIP)
   - Monthly fee amount (required)
   - Registration month (required)
   - Mark fee as paid/unpaid
4. Click **Save Member**

### Searching Members
1. In **Members** tab, use the search bar at top
2. Type name, address, or phone number
3. Results update in real-time

### Filtering by Month
1. Use the month chips below search bar
2. Select a specific month or "All"
3. View filtered member list

### Viewing Dashboard
1. Go to **Dashboard** tab
2. View key metrics:
   - Total members
   - Payment status breakdown
   - Monthly revenue
   - Collection efficiency
   - Member type distribution

### Generating Reports
1. Go to **Reports** tab
2. Select report type
3. View detailed analytics:
   - Monthly fee report
   - Member summary
   - Revenue analysis
   - Export options

## 🎯 Member Types

| Type | Purpose | Features |
|------|---------|----------|
| **Basic** | Standard membership | Access to gym facilities |
| **Premium** | Extended access | All basic + extra hours |
| **VIP** | Premium membership | All facilities + trainer access |

## 💡 Key Features Explained

### Payment Tracking
- Track individual member payments
- Mark fees as Paid/Unpaid
- Quick toggle on member card
- Payment history records (ready for v2)

### Month-Based Records
- Filter members by registration month
- View new members each month
- Track monthly trends
- Generate month-wise reports

### Business Analytics
- Real-time revenue calculations
- Collection rate monitoring
- Member type analysis
- Growth metrics

## 📊 Data Stored

Per member:
- Name, Phone, Address
- Member Type & Status
- Fee Amount & Payment Status
- Registration Date & Month
- Payment History (expandable)
- Attendance Records (expandable)
- Membership Expiry Date

## 🔐 Data Security

- All data stored locally on device
- No cloud dependency
- No internet required
- User data never leaves device
- Hive encryption ready (upgradeable)

## 🎮 Navigation

- **Bottom Navigation Bar**
  - Members - Manage member data
  - Dashboard - View analytics
  - Reports - Generate reports

- **Member Actions**
  - View Details
  - Toggle Fee Status
  - Edit Member
  - Delete Member

## 🚀 Future Enhancements

- [ ] Attendance tracking with check-in/check-out
- [ ] Payment history per member
- [ ] SMS/Email notifications
- [ ] Membership renewal reminders
- [ ] Monthly auto-billing
- [ ] PDF report generation
- [ ] Multi-language support
- [ ] Cloud backup option
- [ ] Expense tracking
- [ ] Staff management
- [ ] Trainer assignment

## 📈 App Size

Target: 20-30 MB (as requested)
- Lightweight dependencies
- Optimized asset management
- No heavy graphics or animations

## 🐛 Known Limitations

- Version 1.0 (MVP)
- PDF export pending
- Print feature pending
- Email integration pending

## 📞 Support

For issues or feature requests, please check the app functionality:
1. **Members Screen** - Core CRUD operations
2. **Dashboard** - Analytics view
3. **Reports** - Data export and analysis

## 📄 License

This project is private and for internal use only.

## 👨‍💻 Development

### Build Commands

```bash
# Clean build
flutter clean

# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Run with verbose output
flutter run -v
```

### Troubleshooting

- **Build issues**: `flutter clean && flutter pub get`
- **Hive errors**: `flutter pub run build_runner build --delete-conflicting-outputs`
- **Android issues**: Update Android SDK/NDK in Android Studio

## 🎉 Version History

- **v1.0** - Initial release with core features
  - Member management
  - Dashboard analytics
  - Reports screen
  - Search & filtering

---

**Happy Gym Managing! 💪**
