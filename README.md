# MindPath - Farkındalık ve Meditasyon Uygulaması

MindPath, farkındalık (mindfulness) pratiğini hayatınıza entegre etmenize yardımcı olan kapsamlı bir mobil uygulamadır.

## 🌟 Özellikler

### 1. Meditasyonlar
- 8 farklı kategori (Güne Başlarken, Günü Bitirirken, Kaygı & Stres, vb.)
- Süre seçenekleri: 3, 5, 10, 20 dakika
- Kadın/Erkek/Sessiz ses seçenekleri
- Rehberli sesli meditasyonlar

### 2. Nefes Egzersizleri
- 4-7-8 Nefes (Kaygı azaltma)
- Box Breathing (Odaklanma)
- Pranayama (Enerji dengeleme)
- Derin Karın Nefesi (Uyku öncesi)
- Görsel rehber ve animasyonlar

### 3. Günlük (Journal)
- Farkındalık soruları
- Duygu takibi
- Ruh hali skorlaması
- AI destekli analiz

### 4. Uyku Hikayeleri
- Rehberli sesli hikayeler
- Doğa ve yolculuk temaları
- Otomatik kapanma zamanlayıcısı

### 5. Eğitim Serileri
- Farkındalık Bilimi
- Duygusal Zeka
- Stres Yönetimi
- Şefkat Pratiği
- Mindful Beslenme

### 6. AI Mind Coach
- Sohbet tabanlı asistan
- Duygu durumuna göre öneriler
- Motivasyon mesajları

### 7. İstatistikler
- Haftalık ilerleme grafikleri
- Duygu eğrisi takibi
- Başarı rozetleri
- Seri takibi

### 8. Topluluk
- Anonim farkındalık paylaşımları
- Günün ilham cümlesi

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK (3.9.0+)
- Firebase hesabı
- Android Studio / VS Code

### Adımlar

1. Repository'yi klonlayın:
```bash
git clone <repository-url>
cd mindpath
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. Firebase'i yapılandırın:
```bash
# FlutterFire CLI'yi kurun
dart pub global activate flutterfire_cli

# Firebase projenizi yapılandırın
flutterfire configure
```

4. Uygulamayı çalıştırın:
```bash
flutter run
```

## 🏗️ Proje Yapısı

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_strings.dart
│   └── theme/
│       └── app_theme.dart
├── models/
│   ├── user_model.dart
│   ├── meditation_model.dart
│   ├── breathing_model.dart
│   ├── journal_model.dart
│   └── course_model.dart
├── services/
│   ├── auth_service.dart
│   ├── audio_player_service.dart
│   ├── meditation_service.dart
│   ├── journal_service.dart
│   └── notification_service.dart
├── screens/
│   ├── onboarding/
│   ├── auth/
│   ├── home/
│   ├── meditation/
│   ├── breathing/
│   ├── journal/
│   ├── ai_coach/
│   ├── sleep/
│   ├── courses/
│   └── profile/
└── main.dart
```

## 🎨 Tasarım Prensipleri

- **Minimalizm**: Sade ve temiz arayüz
- **Doğa Teması**: Pastel renkler, yeşil ve mavi tonlar
- **Sakin Animasyonlar**: Yumuşak geçişler ve nefes animasyonları
- **Accessibility**: Erişilebilir ve kullanıcı dostu

## 🔐 Güvenlik

- Firebase Authentication ile güvenli kimlik doğrulama
- Firestore güvenlik kuralları ile veri koruması
- Kullanıcı verilerinin şifrelenmesi

## 📱 Desteklenen Platformlar

- ✅ Android
- ✅ iOS
- 🔄 Web (yakında)

## 🤝 Katkıda Bulunma

Katkılarınızı bekliyoruz! Lütfen bir pull request gönderin.

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 📧 İletişim

Sorularınız için: info@mindpath.app

---

**MindPath** - Farkındalıkla Yaşa 🧘‍♀️

