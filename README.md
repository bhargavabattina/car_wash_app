# YourCarWash - Car Wash Application

A comprehensive on-demand car wash application built with Flutter and Firebase.

## 🚀 **NEW USER? [START HERE](START_HERE.md)**

If this is your first time setting up the project, please read **[START_HERE.md](START_HERE.md)** for step-by-step setup instructions.

## Features

### Customer App
- 📱 OTP-based authentication
- 🚗 Multiple car management
- 🧼 Browse and book car wash services
- 📅 Schedule bookings with date and time selection
- 📍 Location-based service
- 💳 Multiple payment options (UPI, Card, Cash)
- 📊 Booking history and tracking
- 🎫 Subscription plans

### Technician App
- 👨‍🔧 Job management dashboard
- 📋 View assigned bookings
- 📸 Upload before/after photos
- 💰 Earnings tracking
- ⭐ Performance metrics

### Admin Panel
- 📊 Analytics dashboard
- 📋 Manage all bookings
- 👥 Technician management
- 🔧 Service management
- 💵 Payment reports
- 👤 Customer management

## Tech Stack

- **Framework**: Flutter
- **State Management**: Provider
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **Maps**: Google Maps Flutter
- **Payment**: Razorpay
- **Notifications**: Firebase Cloud Messaging

## Project Structure

```
car_wash_app/
├── android/                      ← Android platform (add with platform setup)
├── ios/                          ← iOS platform (add with platform setup)
├── web/                          ← Web platform (add with platform setup)
├── lib/
│   ├── main.dart                 ← Platform detection & routing
│   ├── admin_web/                ← Web admin dashboard
│   │   ├── admin_app.dart
│   │   ├── screens/
│   │   └── widgets/
│   ├── customer_app/             ← Customer mobile app
│   │   ├── customer_app.dart
│   │   └── screens/
│   ├── technician_app/           ← Technician mobile app
│   │   ├── technician_app.dart
│   │   └── screens/
│   └── shared/                   ← Shared code
│       ├── models/
│       ├── providers/
│       ├── services/
│       ├── utils/
│       └── widgets/
├── START_HERE.md                 ← Setup guide (start here!)
├── PLATFORM_SETUP.md             ← Add Android/iOS/Web folders
├── SETUP_GUIDE.md                ← Firebase & Maps configuration
└── SETUP_CHECKLIST.md            ← Track setup progress
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Firebase account
- Google Cloud account (for Maps API)
- Android Studio / VS Code

### Quick Setup

**⚠️ Important: Follow steps in this order!**

1. **Clone the repository**
```bash
git clone <repository-url>
cd car_wash_app
```

2. **Add platform support** (Android, iOS, Web folders)
```bash
# Windows
add_platforms.bat

# macOS/Linux
./add_platforms.sh

# Or manually
flutter create --platforms=android,ios,web .
```

3. **Install dependencies**
```bash
flutter pub get
```

4. **Configure Firebase & Google Maps**
   - Follow **[SETUP_GUIDE.md](SETUP_GUIDE.md)** for detailed configuration
   - Use **[SETUP_CHECKLIST.md](SETUP_CHECKLIST.md)** to track progress

5. **Run the app**
```bash
# Android
flutter run -d android

# iOS (macOS only)
flutter run -d ios

# Web
flutter run -d chrome
```

### 📚 Setup Documentation

- **[START_HERE.md](START_HERE.md)** - Overview and setup order
- **[PLATFORM_SETUP.md](PLATFORM_SETUP.md)** - Add Android/iOS/Web folders
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Complete Firebase & Maps setup
- **[SETUP_CHECKLIST.md](SETUP_CHECKLIST.md)** - Track your progress
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Project architecture details

## Firebase Setup

### Firestore Collections

1. **users**
   - id (string)
   - name (string)
   - phone (string)
   - email (string)
   - userType (string: 'customer' | 'technician' | 'admin')
   - createdAt (timestamp)

2. **cars**
   - id (string)
   - userId (string)
   - brand (string)
   - model (string)
   - numberPlate (string)
   - carType (string)
   - createdAt (timestamp)

3. **services**
   - id (string)
   - name (string)
   - description (string)
   - basePrice (number)
   - estimatedMinutes (number)
   - category (string)
   - includes (array)
   - isActive (boolean)

4. **bookings**
   - id (string)
   - customerId (string)
   - serviceId (string)
   - carId (string)
   - scheduledDate (timestamp)
   - scheduledTime (string)
   - location (string)
   - latitude (number)
   - longitude (number)
   - totalPrice (number)
   - paymentMethod (string)
   - paymentStatus (string)
   - bookingStatus (string)
   - technicianId (string, optional)
   - beforePhotos (array)
   - afterPhotos (array)
   - createdAt (timestamp)

### Cloud Functions

The following cloud functions need to be implemented:

1. **assignTechnician** - Auto-assign nearest available technician
2. **sendNotification** - Send push notifications for booking updates
3. **processPayment** - Handle payment webhooks
4. **renewSubscription** - Auto-renew subscription plans

## Features to Implement

- [ ] Google Maps integration for location selection
- [ ] Razorpay payment gateway integration
- [ ] Push notifications
- [ ] Real-time technician tracking
- [ ] Rating and review system
- [ ] Chat support
- [ ] Promotional offers and coupons

## License

This project is licensed under the MIT License.

## Support

For support, email support@yourcarwash.com
