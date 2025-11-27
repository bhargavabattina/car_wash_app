# Platform Setup - Adding Android, iOS, and Web Support

Your Flutter project currently doesn't have the `android/`, `ios/`, and `web/` folders. This guide will help you add them.

---

## Why Are These Folders Missing?

The project was likely created with `flutter create --no-platforms` or the platform folders were removed. We need to add them back.

---

## Prerequisites

Before proceeding, ensure you have:

- ✅ Flutter SDK installed
- ✅ Flutter is in your system PATH
- ✅ Run `flutter doctor` and fix any issues

### Install Flutter (if not installed):

**Windows**: https://docs.flutter.dev/get-started/install/windows
**macOS**: https://docs.flutter.dev/get-started/install/macos
**Linux**: https://docs.flutter.dev/get-started/install/linux

---

## Method 1: Automated Setup (Recommended)

### For Windows:

1. **Double-click** `add_platforms.bat`
   - Or open Command Prompt in project folder and run:
   ```cmd
   add_platforms.bat
   ```

### For macOS/Linux:

1. Open Terminal in project folder
2. Run:
   ```bash
   ./add_platforms.sh
   ```

---

## Method 2: Manual Setup

### Step 1: Open Terminal/Command Prompt

Navigate to your project folder:

```bash
cd /path/to/car_wash_app
```

### Step 2: Verify Flutter Installation

```bash
flutter doctor
```

**Fix any issues** that appear before proceeding.

### Step 3: Add Platform Support

Run this single command:

```bash
flutter create --platforms=android,ios,web .
```

**What this does:**
- Creates `android/` folder with Gradle configuration
- Creates `ios/` folder with Xcode project
- Creates `web/` folder with HTML entry point
- Preserves your existing `lib/` folder and code

### Step 4: Verify Folders Were Created

```bash
ls -la
```

You should now see:
```
android/
ios/
web/
lib/
pubspec.yaml
```

---

## What Gets Created?

### Android Folder Structure:
```
android/
├── app/
│   ├── build.gradle           ← Configure dependencies here
│   └── src/main/
│       ├── AndroidManifest.xml  ← Add permissions & API keys
│       ├── kotlin/
│       └── res/
├── build.gradle                ← Add Google Services plugin
└── gradle.properties
```

### iOS Folder Structure:
```
ios/
├── Runner/
│   ├── AppDelegate.swift       ← Initialize Firebase & Maps
│   ├── Info.plist              ← Add permissions
│   └── GoogleService-Info.plist  ← Add this file from Firebase
├── Runner.xcodeproj/
└── Podfile                     ← Configure dependencies
```

### Web Folder Structure:
```
web/
├── index.html                  ← Add Firebase SDK scripts
├── manifest.json
└── favicon.png
```

---

## Common Issues & Solutions

### Issue 1: "flutter: command not found"

**Solution:**
- Flutter is not installed or not in PATH
- Install Flutter: https://flutter.dev/docs/get-started/install
- Add Flutter to PATH:

  **Windows:**
  ```
  Add to System Environment Variables:
  C:\flutter\bin
  ```

  **macOS/Linux:**
  ```bash
  export PATH="$PATH:/path/to/flutter/bin"
  # Add to ~/.bashrc or ~/.zshrc for permanent
  ```

### Issue 2: "Platform already exists" error

**Solution:**
- Some platform folders already exist
- Delete them and run the command again:
  ```bash
  rm -rf android ios web
  flutter create --platforms=android,ios,web .
  ```

### Issue 3: Permission denied on script

**macOS/Linux:**
```bash
chmod +x add_platforms.sh
./add_platforms.sh
```

### Issue 4: Flutter doctor shows errors

**Common fixes:**
- Install Android Studio (for Android development)
- Install Xcode (for iOS development - macOS only)
- Install Chrome (for web development)
- Accept Android licenses: `flutter doctor --android-licenses`

---

## After Creating Platform Folders

### Next Steps:

1. **Run Flutter Doctor**
   ```bash
   flutter doctor -v
   ```
   Fix any remaining issues.

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Each Platform**

   Follow **SETUP_GUIDE.md** for detailed configuration:

   - **Section 2**: Android configuration
   - **Section 3**: iOS configuration
   - **Section 4**: Web configuration

4. **Test Each Platform**

   **Android:**
   ```bash
   flutter run -d android
   ```

   **iOS (macOS only):**
   ```bash
   flutter run -d ios
   ```

   **Web:**
   ```bash
   flutter run -d chrome
   ```

---

## Platform-Specific Requirements

### For Android Development:
- ✅ Android Studio installed
- ✅ Android SDK installed
- ✅ Android emulator or physical device
- ✅ Accept licenses: `flutter doctor --android-licenses`

### For iOS Development (macOS only):
- ✅ Xcode installed (from Mac App Store)
- ✅ Xcode Command Line Tools
- ✅ CocoaPods: `sudo gem install cocoapods`
- ✅ iOS Simulator or physical iPhone

### For Web Development:
- ✅ Chrome browser installed
- ✅ Enable web support: `flutter config --enable-web`

---

## Verify Everything Works

After adding platforms, run:

```bash
# Check Flutter setup
flutter doctor -v

# List available devices
flutter devices

# Test build (doesn't run, just compiles)
flutter build apk --debug      # Android
flutter build ios --debug      # iOS (macOS only)
flutter build web              # Web
```

---

## What to Do Next

1. ✅ **Platform folders created**
2. ⏭️ **Open SETUP_GUIDE.md**
3. ⏭️ **Follow Section 2 (Android)** - Configure Firebase
4. ⏭️ **Follow Section 3 (iOS)** - Configure Firebase
5. ⏭️ **Follow Section 4 (Web)** - Configure Firebase
6. ⏭️ **Follow Section 5** - Configure Google Maps
7. ⏭️ **Test on each platform**

---

## Quick Commands Reference

```bash
# Add platform support
flutter create --platforms=android,ios,web .

# Check Flutter installation
flutter doctor

# Install dependencies
flutter pub get

# Run on Android
flutter run -d android

# Run on iOS (macOS only)
flutter run -d ios

# Run on Web
flutter run -d chrome

# List available devices
flutter devices

# Clean build files
flutter clean

# Rebuild everything
flutter clean && flutter pub get
```

---

## Need Help?

If you encounter issues:

1. Check **Flutter doctor**: `flutter doctor -v`
2. Check **Flutter version**: `flutter --version`
3. Update Flutter: `flutter upgrade`
4. Clean project: `flutter clean`
5. Reinstall dependencies: `flutter pub get`

---

## Summary

**Run this command in your project folder:**

```bash
flutter create --platforms=android,ios,web .
```

**Or use the provided scripts:**
- Windows: `add_platforms.bat`
- macOS/Linux: `./add_platforms.sh`

**Then follow SETUP_GUIDE.md for complete Firebase and Google Maps configuration!**

---

✅ **Ready to proceed once platforms are added!**
