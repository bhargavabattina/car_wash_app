# Complete Setup Guide - Car Wash App
## Google Services & Firebase Configuration for iOS, Android & Web

This guide will walk you through setting up all Google services from scratch for your Car Wash application.

---

## Table of Contents
1. [Firebase Project Setup](#1-firebase-project-setup)
2. [Android Configuration](#2-android-configuration)
3. [iOS Configuration](#3-ios-configuration)
4. [Web Configuration](#4-web-configuration)
5. [Google Maps API Setup](#5-google-maps-api-setup)
6. [Firebase Services Configuration](#6-firebase-services-configuration)
7. [Testing Your Setup](#7-testing-your-setup)

---

## 1. Firebase Project Setup

### Step 1.1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** or **"Create a project"**
3. Enter project name: `car-wash-app` (or your preferred name)
4. Click **Continue**
5. **Google Analytics**: Toggle ON (recommended for tracking)
6. Select or create a Google Analytics account
7. Click **Create project**
8. Wait for project creation (takes 30-60 seconds)
9. Click **Continue** when ready

### Step 1.2: Upgrade to Blaze Plan (Required for Production)

1. In Firebase Console, click **Upgrade** in the bottom left
2. Select **Blaze (Pay as you go)** plan
3. Add billing information
4. **Note**: Free tier is generous; you likely won't be charged for development

---

## 2. Android Configuration

### Step 2.1: Register Android App in Firebase

1. In Firebase Console, click the **Android icon** (⚙️)
2. **Android package name**: `com.yourcompany.car_wash_app`
   - Must match your app's package name
   - Find it in: `android/app/build.gradle` → `applicationId`
3. **App nickname** (optional): `Car Wash Android`
4. **Debug signing certificate SHA-1** (optional but recommended):

   Get it by running:
   ```bash
   cd android
   ./gradlew signingReport
   ```

   Copy the SHA-1 from the output (under `Task :app:signingReport`)

5. Click **Register app**

### Step 2.2: Download google-services.json

1. Click **Download google-services.json**
2. Move the file to: `android/app/google-services.json`

   ```bash
   # From project root
   mv ~/Downloads/google-services.json android/app/
   ```

### Step 2.3: Configure Android Build Files

#### File 1: `android/build.gradle`

```gradle
buildscript {
    ext.kotlin_version = '1.8.22'
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        // Add Google Services plugin
        classpath 'com.google.gms:google-services:4.4.0'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

#### File 2: `android/app/build.gradle`

```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}

android {
    namespace "com.yourcompany.car_wash_app"
    compileSdk 34
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        applicationId "com.yourcompany.car_wash_app"
        minSdkVersion 23
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-auth'
    implementation 'com.google.firebase:firebase-firestore'
    implementation 'com.google.firebase:firebase-storage'
    implementation 'com.google.firebase:firebase-messaging'
    implementation 'com.google.android.gms:play-services-maps:18.2.0'
    implementation 'com.google.android.gms:play-services-location:21.0.1'
}

// Add at the bottom
apply plugin: 'com.google.gms.google-services'
```

#### File 3: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

    <application
        android:label="Car Wash"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">

        <!-- Google Maps API Key -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_ANDROID_MAPS_API_KEY"/>

        <!-- Firebase Cloud Messaging -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="high_importance_channel"/>

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">

            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"/>

            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

---

## 3. iOS Configuration

### Step 3.1: Register iOS App in Firebase

1. In Firebase Console, click the **iOS icon** (🍎)
2. **iOS bundle ID**: `com.yourcompany.carWashApp`
   - Must match your iOS bundle identifier
   - Find it in Xcode: Open `ios/Runner.xcworkspace` → Runner → General → Bundle Identifier
3. **App nickname** (optional): `Car Wash iOS`
4. **App Store ID** (optional): Leave empty for now
5. Click **Register app**

### Step 3.2: Download GoogleService-Info.plist

1. Click **Download GoogleService-Info.plist**
2. Open Xcode:
   ```bash
   cd ios
   open Runner.xcworkspace
   ```
3. In Xcode, drag `GoogleService-Info.plist` into the `Runner` folder
4. ✅ Check **"Copy items if needed"**
5. ✅ Select **"Runner" target**
6. Click **Finish**

### Step 3.3: Configure iOS Project

#### File 1: `ios/Podfile`

```ruby
# Uncomment this line to define a global platform for your project
platform :ios, '13.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

  # Firebase pods
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'

  # Google Maps
  pod 'GoogleMaps'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```

#### Install Pods

```bash
cd ios
pod install
cd ..
```

#### File 2: `ios/Runner/AppDelegate.swift`

```swift
import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase
    FirebaseApp.configure()

    // Initialize Google Maps
    GMSServices.provideAPIKey("YOUR_IOS_MAPS_API_KEY")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

#### File 3: `ios/Runner/Info.plist`

Add these entries inside `<dict>`:

```xml
<!-- Google Maps -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby car wash services</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to provide car wash services at your doorstep</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We need your location to track technician arrival</string>

<!-- Camera -->
<key>NSCameraUsageDescription</key>
<string>We need camera access to take before/after photos of the car wash</string>

<!-- Photo Library -->
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to upload car photos</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need permission to save photos to your library</string>
```

---

## 4. Web Configuration

### Step 4.1: Register Web App in Firebase

1. In Firebase Console, click the **Web icon** (</>)
2. **App nickname**: `Car Wash Admin Web`
3. ✅ Check **"Also set up Firebase Hosting"**
4. Click **Register app**

### Step 4.2: Get Firebase Config

You'll see a config object like this:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  authDomain: "car-wash-app.firebaseapp.com",
  projectId: "car-wash-app",
  storageBucket: "car-wash-app.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef1234567890",
  measurementId: "G-XXXXXXXXXX"
};
```

### Step 4.3: Create Firebase Options File

Create `lib/firebase_options.dart`:

```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    measurementId: 'YOUR_MEASUREMENT_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.yourcompany.carWashApp',
  );
}
```

### Step 4.4: Configure Web Index

Edit `web/index.html`:

```html
<!DOCTYPE html>
<html>
<head>
  <base href="$FLUTTER_BASE_HREF">
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="Car Wash Admin Dashboard">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="Car Wash Admin">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">
  <link rel="icon" type="image/png" href="favicon.png"/>
  <title>Car Wash Admin</title>
  <link rel="manifest" href="manifest.json">

  <style>
    body {
      margin: 0;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }
  </style>
</head>
<body>
  <!-- Firebase SDKs -->
  <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-auth-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-storage-compat.js"></script>

  <script>
    // Your web app's Firebase configuration
    const firebaseConfig = {
      apiKey: "YOUR_WEB_API_KEY",
      authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
      projectId: "YOUR_PROJECT_ID",
      storageBucket: "YOUR_PROJECT_ID.appspot.com",
      messagingSenderId: "YOUR_SENDER_ID",
      appId: "YOUR_WEB_APP_ID",
      measurementId: "YOUR_MEASUREMENT_ID"
    };

    // Initialize Firebase
    firebase.initializeApp(firebaseConfig);
  </script>

  <script>
    window.addEventListener('load', function(ev) {
      _flutter.loader.loadEntrypoint({
        serviceWorker: {
          serviceWorkerVersion: serviceWorkerVersion,
        },
        onEntrypointLoaded: function(engineInitializer) {
          engineInitializer.initializeEngine().then(function(appRunner) {
            appRunner.runApp();
          });
        }
      });
    });
  </script>
  <script src="flutter.js" defer></script>
</body>
</html>
```

---

## 5. Google Maps API Setup

### Step 5.1: Enable Google Maps API

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project (or create new)
3. Click **APIs & Services** → **Library**
4. Search and enable these APIs:
   - ✅ **Maps SDK for Android**
   - ✅ **Maps SDK for iOS**
   - ✅ **Maps JavaScript API**
   - ✅ **Places API**
   - ✅ **Geocoding API**
   - ✅ **Geolocation API**

### Step 5.2: Create API Keys

1. Go to **APIs & Services** → **Credentials**
2. Click **+ CREATE CREDENTIALS** → **API key**

#### Android API Key:
1. Click **Restrict Key**
2. **Name**: `Android Maps API Key`
3. **Application restrictions**: Select **Android apps**
4. Click **+ Add an item**
5. Enter:
   - **Package name**: `com.yourcompany.car_wash_app`
   - **SHA-1**: (from `./gradlew signingReport`)
6. **API restrictions**: Select **Restrict key**
7. Select:
   - Maps SDK for Android
   - Places API
   - Geocoding API
8. Click **Save**
9. Copy the API key → Update in `android/app/src/main/AndroidManifest.xml`

#### iOS API Key:
1. Click **+ CREATE CREDENTIALS** → **API key**
2. Click **Restrict Key**
3. **Name**: `iOS Maps API Key`
4. **Application restrictions**: Select **iOS apps**
5. Click **+ Add an item**
6. Enter **Bundle ID**: `com.yourcompany.carWashApp`
7. **API restrictions**: Select **Restrict key**
8. Select:
   - Maps SDK for iOS
   - Places API
   - Geocoding API
9. Click **Save**
10. Copy the API key → Update in `ios/Runner/AppDelegate.swift`

#### Web API Key (Optional for maps on web):
1. Click **+ CREATE CREDENTIALS** → **API key**
2. Click **Restrict Key**
3. **Name**: `Web Maps API Key`
4. **Application restrictions**: Select **HTTP referrers**
5. Add referrers:
   - `localhost:*`
   - `*.web.app/*`
   - `*.firebaseapp.com/*`
   - Your domain: `yourdomain.com/*`
6. **API restrictions**: Select **Restrict key**
7. Select:
   - Maps JavaScript API
   - Places API
   - Geocoding API
8. Click **Save**

---

## 6. Firebase Services Configuration

### Step 6.1: Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get started**
3. Go to **Sign-in method** tab
4. Enable **Phone** authentication:
   - Click **Phone**
   - Toggle **Enable**
   - Click **Save**

### Step 6.2: Configure Firestore Database

1. Go to **Firestore Database**
2. Click **Create database**
3. Select **Start in production mode**
4. Choose location: `asia-south1` (India) or closest to you
5. Click **Enable**

#### Set Firestore Rules:

Click **Rules** tab and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
      allow create: if request.auth != null;
    }

    // Cars collection
    match /cars/{carId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null &&
                     resource.data.userId == request.auth.uid;
      allow create: if request.auth != null;
    }

    // Services collection
    match /services/{serviceId} {
      allow read: if true; // Public read
      allow write: if request.auth != null &&
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'admin';
    }

    // Bookings collection
    match /bookings/{bookingId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null &&
                       (resource.data.customerId == request.auth.uid ||
                        resource.data.technicianId == request.auth.uid ||
                        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'admin');
    }

    // Allow admin full access
    match /{document=**} {
      allow read, write: if request.auth != null &&
                            get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'admin';
    }
  }
}
```

Click **Publish**

### Step 6.3: Configure Storage

1. Go to **Storage**
2. Click **Get started**
3. Select **Start in production mode**
4. Use same location as Firestore
5. Click **Done**

#### Set Storage Rules:

Click **Rules** tab:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {

    // Profile images
    match /profile_images/{userId}/{imageId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    // Car images
    match /car_images/{userId}/{carId}/{imageId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    // Booking photos (before/after)
    match /booking_photos/{bookingId}/{imageId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }

    // Service images (admin only)
    match /service_images/{imageId} {
      allow read: if true;
      allow write: if request.auth != null &&
                      firestore.get(/databases/(default)/documents/users/$(request.auth.uid)).data.userType == 'admin';
    }
  }
}
```

Click **Publish**

### Step 6.4: Enable Cloud Messaging (FCM)

1. Go to **Cloud Messaging**
2. Click **Get started**
3. For **Android**:
   - Server key is automatically configured in `google-services.json`
4. For **iOS**:
   - Upload APNs certificate (optional for development)

---

## 7. Testing Your Setup

### Step 7.1: Update main.dart

Edit `lib/main.dart`:

```dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'admin_web/admin_app.dart';
import 'customer_app/customer_app.dart';
import 'technician_app/technician_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Platform detection - Route to web admin or mobile app selector
    if (kIsWeb) {
      return const AdminWebApp();
    } else {
      return const AppSelector();
    }
  }
}

// ... rest of your code
```

### Step 7.2: Test Android

```bash
flutter run -d android
```

**Check Console for**:
- ✅ `[FirebaseApp] Successfully initialized Firebase`
- ✅ No errors about `google-services.json`

### Step 7.3: Test iOS

```bash
flutter run -d ios
```

**Check Console for**:
- ✅ `[FirebaseApp] Successfully initialized Firebase`
- ✅ No errors about `GoogleService-Info.plist`

### Step 7.4: Test Web

```bash
flutter run -d chrome
```

**Check Browser Console for**:
- ✅ Firebase initialized successfully
- ✅ No CORS errors

---

## 8. Quick Reference - All API Keys Location

### Android:
- **google-services.json**: `android/app/google-services.json`
- **Maps API Key**: `android/app/src/main/AndroidManifest.xml`

### iOS:
- **GoogleService-Info.plist**: `ios/Runner/GoogleService-Info.plist`
- **Maps API Key**: `ios/Runner/AppDelegate.swift`

### Web:
- **Firebase Config**: `lib/firebase_options.dart` & `web/index.html`

---

## 9. Troubleshooting

### Common Issues:

**1. "google-services.json not found"**
- Ensure file is in `android/app/` directory
- Check file name is exactly `google-services.json`

**2. "GoogleService-Info.plist not found"**
- Ensure file is added to Xcode project
- Check it's in Runner target

**3. "Failed to initialize Firebase"**
- Check internet connection
- Verify API keys match your Firebase project
- Ensure Firebase is initialized before runApp()

**4. Maps not showing**
- Verify Maps API is enabled in Google Cloud Console
- Check API key restrictions
- Ensure billing is enabled for Google Cloud project

**5. Authentication not working**
- Enable Phone auth in Firebase Console
- For iOS, add URL schemes in Info.plist
- Check Firestore rules allow user creation

---

## 10. Next Steps

After completing this setup:

1. ✅ Create initial admin user in Firestore
2. ✅ Add sample services to database
3. ✅ Test authentication flow
4. ✅ Test booking creation
5. ✅ Configure Razorpay for payments

---

## Support

If you encounter issues:
- Check [Firebase Documentation](https://firebase.google.com/docs)
- Review [Google Maps Documentation](https://developers.google.com/maps)
- Verify all API keys are correctly copied

**Important**: Replace all placeholder values:
- `YOUR_ANDROID_MAPS_API_KEY`
- `YOUR_IOS_MAPS_API_KEY`
- `YOUR_WEB_API_KEY`
- `com.yourcompany.car_wash_app`
- Firebase config values

---

**Setup Complete!** 🎉

Your Car Wash app is now configured for iOS, Android, and Web with all Google services!
