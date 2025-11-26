# YourCarWash - Car Wash Application

A comprehensive on-demand car wash application built with Flutter and Firebase.

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
lib/
├── main.dart
├── models/
│   ├── user_model.dart
│   ├── booking_model.dart
│   ├── service_model.dart
│   └── car_model.dart
├── providers/
│   ├── auth_provider.dart
│   ├── booking_provider.dart
│   └── technician_provider.dart
├── services/
│   ├── firebase_auth_service.dart
│   ├── firestore_service.dart
│   ├── storage_service.dart
│   └── notification_service.dart
├── screens/
│   ├── customer/
│   ├── technician/
│   └── admin/
├── widgets/
│   ├── custom_button.dart
│   ├── custom_input.dart
│   ├── service_card.dart
│   ├── car_card.dart
│   └── booking_card.dart
└── utils/
    ├── constants.dart
    ├── helpers.dart
    └── routes.dart
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Firebase account
- Android Studio / VS Code

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd car_wash_app
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
- Create a new Firebase project
- Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
- Place them in the respective platform directories

4. Run the app
```bash
flutter run
```

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
