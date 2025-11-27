#!/bin/bash

# Script to add Android, iOS, and Web platform support to your Flutter project
# Run this in your project root directory

echo "🚀 Adding Platform Support to Car Wash App..."
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null
then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter first: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"
echo ""

# Navigate to project directory (adjust if needed)
cd "$(dirname "$0")"

echo "📁 Current directory: $(pwd)"
echo ""

# Add Android, iOS, and Web platforms
echo "➕ Adding Android, iOS, and Web platforms..."
flutter create --platforms=android,ios,web .

echo ""
echo "✅ Platform folders created!"
echo ""

# List created folders
echo "📂 Created folders:"
ls -d android ios web 2>/dev/null || echo "⚠️  Some folders may not have been created"

echo ""
echo "🎉 Platform setup complete!"
echo ""
echo "Next steps:"
echo "1. Open SETUP_GUIDE.md and follow the configuration steps"
echo "2. Configure Android: android/app/build.gradle, AndroidManifest.xml"
echo "3. Configure iOS: ios/Podfile, AppDelegate.swift"
echo "4. Configure Web: web/index.html"
echo "5. Add Firebase configuration files"
echo ""
echo "Run 'flutter doctor' to check your Flutter installation"
