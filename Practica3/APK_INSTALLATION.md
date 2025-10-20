# 📦 APK Installation Guide

## ⚠️ APK Files Not Included in GitHub Repository

The APK files are not included in this repository due to GitHub's file size limitations (>100MB per file).

### 🛠️ How to Generate APK Files

To build the APK files from source code:

```bash
# Navigate to the Flutter project directory
cd practica_3

# Install dependencies
flutter pub get

# Build release APK (recommended for distribution)
flutter build apk --release

# Build debug APK (for development and testing)
flutter build apk --debug

# Generated APK files will be located at:
# build/app/outputs/flutter-apk/app-release.apk
# build/app/outputs/flutter-apk/app-debug.apk
```

### 📋 Build Requirements

- **Flutter SDK**: 3.9.2 or higher
- **Android SDK**: API 24+ (Android 7.0+)
- **Android Studio**: with Flutter and Dart plugins
- **JDK**: 11 or higher
- **Available Storage**: 200MB+ for build process

### 📱 APK Information

| Type | Size | Min API | Target Use |
|------|------|---------|------------|
| Release APK | ~50 MB | API 24 | Production/Distribution |
| Debug APK | ~148 MB | API 24 | Development/Testing |

### 🔗 Alternative Distribution Methods

1. **GitHub Releases** - Upload APK as release assets
2. **Google Drive** - Share via cloud storage
3. **Firebase App Distribution** - For testing distribution
4. **Direct Transfer** - USB/Email for local distribution

### 🏗️ Project Architecture

- **Clean Architecture** implementation
- **Flutter + Kotlin** native integration
- **File Management** with Android storage permissions
- **ESCOM/IPN** institutional themes
- **SQLite** local database for favorites and recent files

---

For complete project documentation, see [README.md](README.md)

**© 2025 - ESCOM, Instituto Politécnico Nacional**