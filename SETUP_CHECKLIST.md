# Setup Checklist - Car Wash App

Use this checklist to track your setup progress.

## ☑️ Firebase Project Setup

- [ ] Created Firebase project at [console.firebase.google.com](https://console.firebase.google.com/)
- [ ] Enabled Google Analytics
- [ ] Upgraded to Blaze plan (for production)

---

## ☑️ Android Setup

- [ ] Registered Android app in Firebase
  - Package name: `com.yourcompany.car_wash_app`
  - Got SHA-1 certificate using `./gradlew signingReport`
- [ ] Downloaded `google-services.json`
- [ ] Placed file in `android/app/google-services.json`
- [ ] Updated `android/build.gradle` with Google Services plugin
- [ ] Updated `android/app/build.gradle` with dependencies
- [ ] Added permissions to `AndroidManifest.xml`
- [ ] Created Android Maps API key
- [ ] Added Maps API key to `AndroidManifest.xml`
- [ ] Tested: `flutter run -d android`

---

## ☑️ iOS Setup

- [ ] Registered iOS app in Firebase
  - Bundle ID: `com.yourcompany.carWashApp`
- [ ] Downloaded `GoogleService-Info.plist`
- [ ] Added plist to Xcode project (Runner folder)
- [ ] Updated `ios/Podfile` with Firebase pods
- [ ] Ran `pod install` in ios directory
- [ ] Updated `AppDelegate.swift` with Firebase initialization
- [ ] Added location/camera permissions to `Info.plist`
- [ ] Created iOS Maps API key
- [ ] Added Maps API key to `AppDelegate.swift`
- [ ] Tested: `flutter run -d ios`

---

## ☑️ Web Setup

- [ ] Registered Web app in Firebase
- [ ] Copied Firebase config object
- [ ] Created `lib/firebase_options.dart` with config
- [ ] Updated `web/index.html` with Firebase SDKs
- [ ] Added Firebase config to `index.html`
- [ ] Tested: `flutter run -d chrome`

---

## ☑️ Google Maps API Setup

- [ ] Went to [Google Cloud Console](https://console.cloud.google.com/)
- [ ] Enabled these APIs:
  - [ ] Maps SDK for Android
  - [ ] Maps SDK for iOS
  - [ ] Maps JavaScript API
  - [ ] Places API
  - [ ] Geocoding API
  - [ ] Geolocation API
- [ ] Created 3 API keys:
  - [ ] Android Maps API Key (with package restrictions)
  - [ ] iOS Maps API Key (with bundle ID restrictions)
  - [ ] Web Maps API Key (with referrer restrictions)
- [ ] Added API keys to respective files

---

## ☑️ Firebase Services

### Authentication
- [ ] Enabled Authentication in Firebase Console
- [ ] Enabled Phone sign-in method
- [ ] Tested phone authentication

### Firestore Database
- [ ] Created Firestore database
- [ ] Selected region (e.g., asia-south1)
- [ ] Updated Firestore security rules
- [ ] Published rules

### Storage
- [ ] Enabled Firebase Storage
- [ ] Updated Storage security rules
- [ ] Published rules

### Cloud Messaging
- [ ] Enabled Cloud Messaging (FCM)
- [ ] Configured for Android (automatic)
- [ ] Configured for iOS (APNs certificate - optional)

---

## ☑️ Code Updates

- [ ] Updated `lib/main.dart` with Firebase initialization
- [ ] Created/Updated `lib/firebase_options.dart`
- [ ] Replaced all placeholder values:
  - [ ] `YOUR_ANDROID_MAPS_API_KEY`
  - [ ] `YOUR_IOS_MAPS_API_KEY`
  - [ ] `YOUR_WEB_API_KEY`
  - [ ] `com.yourcompany.car_wash_app`
  - [ ] All Firebase config values

---

## ☑️ Testing

- [ ] Android app builds without errors
- [ ] iOS app builds without errors
- [ ] Web app runs in browser
- [ ] Firebase initialized successfully on all platforms
- [ ] Maps display correctly
- [ ] Authentication works
- [ ] Can create/read Firestore documents
- [ ] Can upload images to Storage

---

## ☑️ Initial Data Setup

- [ ] Created admin user in Firestore
  - Collection: `users`
  - Document ID: admin's UID
  - Fields: `userType: 'admin'`
- [ ] Created sample services in Firestore
  - Collection: `services`
- [ ] Tested admin login

---

## ☑️ Additional Setup (Optional)

- [ ] Set up Razorpay payment gateway
- [ ] Configure app icons
- [ ] Configure splash screens
- [ ] Set up Google Sign-In (optional)
- [ ] Configure push notifications

---

## 🚀 Ready to Launch

Once all items are checked:
- [ ] Run final tests on all platforms
- [ ] Test complete user flow (signup → booking → payment)
- [ ] Verify all API keys are production-ready
- [ ] Enable Firebase App Check for security
- [ ] Set up monitoring and analytics

---

## 📝 Notes

**Important Values to Save:**

```
Firebase Project ID: ___________________

Android Package: com.yourcompany.car_wash_app
Android SHA-1: ___________________
Android Maps API Key: ___________________

iOS Bundle ID: com.yourcompany.carWashApp
iOS Maps API Key: ___________________

Web API Key: ___________________

Firebase Web Config:
  apiKey: ___________________
  authDomain: ___________________
  projectId: ___________________
  storageBucket: ___________________
  messagingSenderId: ___________________
  appId: ___________________
  measurementId: ___________________
```

---

**Setup Progress**: ____ / 60 items completed

Good luck with your setup! 🎉
