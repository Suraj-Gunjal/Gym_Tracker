# Gym Tracker - Deployment Guide

## Pre-Deployment Checklist

### 1. Code Preparation
- [x] All compile errors fixed
- [x] ProGuard rules configured for Android
- [x] App permissions configured (Android & iOS)
- [x] Production app ID set (`com.gymboyyy.tracker`)
- [x] Privacy descriptions added for iOS

### 2. App Configuration

#### Update Version Number
Edit `pubspec.yaml`:
```yaml
version: 1.0.0+1  # Format: major.minor.patch+buildNumber
```

For subsequent releases, increment:
- **Patch** (1.0.1): Bug fixes
- **Minor** (1.1.0): New features
- **Major** (2.0.0): Breaking changes
- **Build number**: Always increment for each store upload

---

## Android Deployment

### Step 1: Generate Signing Key
```powershell
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Move `upload-keystore.jks` to `android/` folder.

### Step 2: Configure Signing
1. Copy `android/key.properties.example` to `android/key.properties`
2. Fill in your keystore credentials:
```properties
storePassword=your_actual_password
keyPassword=your_actual_password
keyAlias=upload
storeFile=../upload-keystore.jks
```

> ⚠️ **Never commit `key.properties` or `upload-keystore.jks` to version control!**

### Step 3: Build Release APK
```powershell
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Step 4: Build Release App Bundle (for Play Store)
```powershell
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### Step 5: Upload to Google Play Console
1. Go to [Google Play Console](https://play.google.com/console)
2. Create a new app or select existing
3. Navigate to **Release** > **Production**
4. Upload the `.aab` file
5. Complete store listing, content rating, and pricing

---

## iOS Deployment

### Step 1: Configure Xcode Project
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the **Runner** target
3. Set **Bundle Identifier**: `com.gymboyyy.tracker`
4. Select your **Team** for signing
5. Set **Deployment Target**: iOS 12.0+

### Step 2: Update iOS Bundle ID
Edit `ios/Runner.xcodeproj/project.pbxproj`:
- Find `PRODUCT_BUNDLE_IDENTIFIER` and set to `com.gymboyyy.tracker`

Or via Xcode:
1. Runner > Targets > Runner > Signing & Capabilities
2. Update Bundle Identifier

### Step 3: Build Archive
```powershell
flutter build ipa --release
```

Or via Xcode:
1. Select **Any iOS Device** as build target
2. **Product** > **Archive**
3. In Organizer, click **Distribute App**

### Step 4: Upload to App Store Connect
1. Use **Transporter** app or Xcode Organizer
2. Go to [App Store Connect](https://appstoreconnect.apple.com)
3. Create new app version
4. Complete app information and submit for review

---

## Environment Configuration

### Supabase Setup (Production)
1. Create a production Supabase project
2. Update environment variables:

Create `lib/core/config/env_config.dart`:
```dart
class EnvConfig {
  static const String supabaseUrl = 'YOUR_PRODUCTION_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_PRODUCTION_ANON_KEY';
}
```

### API Configuration
If using a backend, update `lib/core/config/api_config.dart`:
```dart
class ApiConfig {
  static const String baseUrl = 'https://api.yourdomain.com';
}
```

---

## Store Listing Assets

### Required Assets

#### Android (Google Play)
- **App Icon**: 512x512 PNG
- **Feature Graphic**: 1024x500 PNG
- **Screenshots**: 
  - Phone: 16:9 or 9:16 (min 320px, max 3840px)
  - Tablet 7": 16:9 or 9:16
  - Tablet 10": 16:9 or 9:16
- **Short Description**: Max 80 characters
- **Full Description**: Max 4000 characters

#### iOS (App Store)
- **App Icon**: 1024x1024 PNG (no alpha)
- **Screenshots**:
  - iPhone 6.7" (1290x2796)
  - iPhone 6.5" (1284x2778)
  - iPhone 5.5" (1242x2208)
  - iPad Pro 12.9" (2048x2732)
- **Promotional Text**: Max 170 characters
- **Description**: Max 4000 characters
- **Keywords**: Max 100 characters

### Suggested App Store Description
```
Gym Tracker - Your Ultimate Workout Companion

Track your gym workouts with ease! Gym Tracker offers:

🏋️ WORKOUT TRACKING
- Log exercises, sets, reps, and weights
- Track personal records (PRs)
- Customizable workout templates

📊 PROGRESS ANALYTICS
- Visualize your gains with charts
- Track volume per muscle group
- Monitor workout streaks

🎯 SMART FEATURES
- AI-powered workout suggestions
- Warm-up generator
- RPE/RIR tracking
- Tempo training

💪 GAMIFICATION
- Earn XP and level up
- Complete daily/weekly missions
- Compete on leaderboards

☁️ SYNC & BACKUP
- Cloud sync across devices
- Offline-first - works without internet
- Never lose your workout data

🎵 INTEGRATIONS
- Music service integration
- Wearable device support
- Voice commands

Download now and start your fitness journey!
```

---

## Post-Deployment

### Monitor & Maintain
1. Set up crash reporting (Firebase Crashlytics)
2. Monitor app reviews and ratings
3. Track analytics (Firebase Analytics)
4. Plan regular updates

### Version Increment Script
```powershell
# Increment build number for next release
$content = Get-Content pubspec.yaml -Raw
$content -match 'version: (\d+)\.(\d+)\.(\d+)\+(\d+)'
$newBuild = [int]$Matches[4] + 1
$newVersion = "version: $($Matches[1]).$($Matches[2]).$($Matches[3])+$newBuild"
$content -replace 'version: \d+\.\d+\.\d+\+\d+', $newVersion | Set-Content pubspec.yaml
```

---

## Troubleshooting

### Android Build Issues
```powershell
# Clean and rebuild
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build appbundle --release
```

### iOS Build Issues
```powershell
# Clean CocoaPods
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
flutter clean
flutter build ipa
```

### Signing Issues
- Ensure keystore passwords are correct
- Check keystore file path is relative to `android/app/`
- For iOS, ensure you have a valid Apple Developer account and certificates

---

## Security Checklist

- [ ] API keys are not hardcoded (use environment variables)
- [ ] `key.properties` is in `.gitignore`
- [ ] `upload-keystore.jks` is in `.gitignore`
- [ ] Debug logging is disabled in release builds
- [ ] Network security config prevents cleartext traffic
- [ ] ProGuard is enabled for release builds
