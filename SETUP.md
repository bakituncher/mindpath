# MindPath Kurulum Rehberi

Bu rehber, MindPath uygulamasını yerel olarak çalıştırmak için gerekli adımları içerir.

## Ön Gereksinimler

- Flutter SDK 3.9.0 veya üzeri
- Android Studio veya VS Code
- Firebase hesabı
- Dart SDK

## Kurulum Adımları

### 1. Flutter SDK Kurulumu

Flutter SDK'nın kurulu olduğunu doğrulayın:
```bash
flutter --version
flutter doctor
```

### 2. Projeyi Klonlama

```bash
git clone <repository-url>
cd mindpath
```

### 3. Bağımlılıkları Yükleme

```bash
flutter pub get
```

### 4. Firebase Kurulumu

#### 4.1. Firebase Projesi Oluşturma

1. [Firebase Console](https://console.firebase.google.com/) üzerinden yeni bir proje oluşturun
2. Proje adını "MindPath" olarak girin

#### 4.2. Android Uygulaması Ekleme

1. Firebase Console'da Android ikonu tıklayın
2. Package name: `com.mindpath.app` (veya kendi package name'inizi girin)
3. `google-services.json` dosyasını indirin
4. Dosyayı `android/app/` klasörüne kopyalayın

#### 4.3. iOS Uygulaması Ekleme

1. Firebase Console'da iOS ikonu tıklayın
2. Bundle ID: `com.mindpath.app` (veya kendi bundle ID'nizi girin)
3. `GoogleService-Info.plist` dosyasını indirin
4. Dosyayı `ios/Runner/` klasörüne kopyalayın

#### 4.4. FlutterFire CLI ile Yapılandırma

```bash
# FlutterFire CLI'yi global olarak yükleyin
dart pub global activate flutterfire_cli

# Firebase projenizi yapılandırın
flutterfire configure
```

Bu komut otomatik olarak `lib/firebase_options.dart` dosyasını oluşturacaktır.

#### 4.5. Firebase Servislerini Etkinleştirme

Firebase Console'da şu servisleri etkinleştirin:

**Authentication:**
- Email/Password provider'ı etkinleştirin

**Firestore Database:**
1. Database oluşturun (Test mode'da başlayın)
2. `firestore.rules` dosyasını deploy edin:
   ```bash
   firebase deploy --only firestore:rules
   ```

**Storage:**
1. Storage'ı etkinleştirin
2. `storage.rules` dosyasını deploy edin:
   ```bash
   firebase deploy --only storage
   ```

### 5. Android Yapılandırması

#### 5.1. `android/app/build.gradle.kts` güncelleyin:

Dosyanın sonuna şunu ekleyin:
```kotlin
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
}
```

#### 5.2. `android/build.gradle.kts` güncelleyin:

```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

#### 5.3. Minimum SDK versiyonunu ayarlayın:

`android/app/build.gradle.kts` dosyasında:
```kotlin
minSdk = 21
```

### 6. iOS Yapılandırması

`ios/Podfile` dosyasını güncelleyin:
```ruby
platform :ios, '12.0'
```

Ardından:
```bash
cd ios
pod install
cd ..
```

### 7. Permissions Ekleme

#### Android (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

#### iOS (`ios/Runner/Info.plist`):
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Sesli günlük kayıtları için mikrofon erişimi gerekiyor</string>
<key>NSLocalNetworkUsageDescription</key>
<string>Uygulama içeriğini yüklemek için ağ erişimi gerekiyor</string>
```

### 8. Uygulamayı Çalıştırma

```bash
# Android için
flutter run

# iOS için (macOS gerekli)
flutter run -d ios

# Belirli bir cihaz için
flutter devices
flutter run -d <device-id>
```

### 9. Test Verisi Ekleme

Firestore'a örnek meditasyon verisi eklemek için:

1. Firebase Console > Firestore Database açın
2. `meditations` koleksiyonu oluşturun
3. Örnek bir belge ekleyin:

```json
{
  "title": "Sabah Meditasyonu",
  "description": "Güne huzurla başlayın",
  "category": "morning",
  "durationMinutes": 5,
  "voiceType": "female",
  "audioUrl": "",
  "imageUrl": "",
  "tags": ["sabah", "enerji", "başlangıç"],
  "playCount": 0,
  "rating": 4.5,
  "isPremium": false
}
```

## Sorun Giderme

### Firebase bağlantı hatası
```bash
flutter clean
flutter pub get
```

### Build hatası
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### iOS Pod hatası
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
```

### Cache temizleme
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

## Geliştirme İpuçları

### Hot Reload
Kod değişikliklerini hızlıca görmek için:
- VS Code: `Ctrl + S` veya `Cmd + S`
- Terminal: `r` tuşuna basın

### Hot Restart
Tam yeniden başlatma için:
- Terminal: `R` tuşuna basın

### Debug Mode'dan Release Mode'a geçiş
```bash
flutter run --release
```

### APK Oluşturma
```bash
flutter build apk --release
```

### iOS IPA Oluşturma
```bash
flutter build ios --release
```

## Ek Kaynaklar

- [Flutter Dokümantasyonu](https://flutter.dev/docs)
- [Firebase Flutter Dokümantasyonu](https://firebase.flutter.dev/)
- [FlutterFire GitHub](https://github.com/firebase/flutterfire)

## Destek

Sorunlar için GitHub Issues kullanın veya info@mindpath.app adresine e-posta gönderin.

