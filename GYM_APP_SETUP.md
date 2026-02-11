# Gym Member Manager App

A Flutter app to manage gym members with local data storage using Hive.

## Features

- ✅ Add gym members with name, address, fee amount, and registration month
- ✅ Track fee paid/unpaid status
- ✅ Edit member information
- ✅ Delete members
- ✅ Toggle fee payment status
- ✅ Local data persistence using Hive
- ✅ Clean and intuitive UI

## Getting Started

### Prerequisites
- Flutter SDK installed
- Dart SDK installed

### Installation

1. Navigate to the project directory:
```bash
cd learning2
```

2. Get dependencies:
```bash
flutter pub get
```

3. Generate Hive adapter files:
```bash
flutter pub run build_runner build
```

### Running the App

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── home_screen.dart      # Main members list screen
│   └── add_edit_member_screen.dart  # Add/edit member form
├── models/
│   └── member.dart           # Member data model
└── services/
    └── database_service.dart # Database operations
```

## Usage

### Adding a Member
1. Click the "+" button on the home screen
2. Fill in all details:
   - Member Name
   - Address
   - Fee Amount (in ₹)
   - Registration Month
   - Toggle fee paid/unpaid status
3. Click "Save Member"

### Editing a Member
1. Click on a member's popup menu (three dots)
2. Select "Edit"
3. Modify the details
4. Click "Save Member"

### Toggling Fee Status
1. Click on a member's popup menu
2. Select "Toggle Fee" to mark as paid/unpaid

### Deleting a Member
1. Click on a member's popup menu
2. Select "Delete"
3. Confirm the deletion

## Data Storage

The app uses Hive for local data storage. All member data is stored locally on the device and persists across app sessions.

### Member Data Fields
- **Name**: Member's full name
- **Address**: Member's address
- **Amount**: Monthly fee amount
- **Fee Status**: Paid or Unpaid
- **Registration Month**: Month of registration
- **Registration Date**: Full date of registration

## Technologies Used

- **Flutter**: UI Framework
- **Hive**: Local data persistence
- **Material Design**: UI Components

## Future Enhancements

- Payment history tracking
- Membership expiration reminders
- Export member data to PDF/Excel
- Search and filter members
- Monthly revenue analytics
- Backup and restore functionality

## License

This project is open source and available under the MIT License.
