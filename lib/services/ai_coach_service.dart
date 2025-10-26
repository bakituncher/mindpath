import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindpath/models/user_model.dart';
import 'package:mindpath/models/journal_model.dart';

class AICoachService {
  late final GenerativeModel _model;

  AICoachService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env file');
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.9,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );
  }

  /// Kullanıcı bağlamı oluşturur
  String _buildUserContext(UserModel user, List<JournalEntry> recentEntries) {
    final context = StringBuffer();

    // Kullanıcı hedefleri
    if (user.goals.isNotEmpty) {
      context.writeln('Kullanıcının Hedefleri:');
      for (var goal in user.goals) {
        context.writeln('- $goal');
      }
      context.writeln();
    }

    // Son günlük kayıtları
    if (recentEntries.isNotEmpty) {
      context.writeln('Son 7 Günlük Duygusal Durum:');
      for (var entry in recentEntries) {
        final date = '${entry.createdAt.day}/${entry.createdAt.month}';
        context.writeln('[$date] Ruh Hali: ${entry.moodScore}/10');
        if (entry.emotions.isNotEmpty) {
          context.writeln('Duygular: ${entry.emotions.join(", ")}');
        }
        if (entry.content.isNotEmpty && entry.content.length < 200) {
          context.writeln('Not: ${entry.content}');
        }
        context.writeln();
      }
    }

    // İstatistikler
    context.writeln('Kullanıcı İstatistikleri:');
    context.writeln('- Toplam Meditasyon: ${user.stats.totalMeditationMinutes} dakika');
    context.writeln('- Günlük Girişleri: ${user.stats.totalJournalEntries}');
    context.writeln('- Mevcut Seri: ${user.stats.currentStreak} gün');

    return context.toString();
  }

  /// Sistem talimatını oluşturur
  String _buildSystemPrompt() {
    return '''Sen MindPath, empatik ve profesyonel bir farkındalık koçusun. 

Görevin:
1. Kullanıcının duygusal durumunu anlamak ve onaylamak
2. Geçmiş günlük kayıtlarına ve hedeflerine dayanarak kişiselleştirilmiş öneriler sunmak
3. Farkındalık, meditasyon, nefes egzersizleri ve duygusal düzenleme teknikleri önermek
4. Destekleyici, sevecen ve yargılamayan bir dil kullanmak
5. Kullanıcıyı küçük, uygulanabilir adımlara yönlendirmek

Önemli Kurallar:
- Asla tıbbi tavsiye verme, ciddi durumlarda profesyonel yardım öner
- Kısa, anlaşılır ve Türkçe yanıtlar ver
- Kullanıcının duygularını minimize etme, her duyguyu geçerli kabul et
- Somut teknikler öner (nefes egzersizleri, meditasyon, günlük yazma)
- Umut verici ve cesaretlendirici ol

Yanıt Formatı:
1. Empati ve anlayış göster
2. Gözlemlediğin kalıpları nazikçe belirt
3. Spesifik ve uygulanabilir bir öneri sun
4. Destekleyici bir mesajla bitir
''';
  }

  /// Gemini API ile sohbet
  Future<String> sendMessage(
    String userMessage, {
    required UserModel user,
    List<JournalEntry> recentEntries = const [],
    List<Map<String, String>> chatHistory = const [],
  }) async {
    try {
      // Bağlam oluştur
      final userContext = _buildUserContext(user, recentEntries);
      final systemPrompt = _buildSystemPrompt();

      // Sohbet geçmişini hazırla
      final history = <Content>[];

      // Sistem talimatını ve kullanıcı bağlamını ilk mesaj olarak ekle
      history.add(Content.text(
        '$systemPrompt\n\nKullanıcı Bağlamı:\n$userContext'
      ));

      // Önceki sohbet geçmişini ekle
      for (var message in chatHistory) {
        if (message['role'] == 'user') {
          history.add(Content.text(message['content']!));
        } else {
          history.add(Content.model([TextPart(message['content']!)]));
        }
      }

      // Chat session oluştur
      final chat = _model.startChat(history: history);

      // Mesajı gönder
      final response = await chat.sendMessage(Content.text(userMessage));

      return response.text ?? 'Özür dilerim, şu anda bir yanıt oluşturamıyorum. Lütfen tekrar dener misin?';

    } catch (e) {
      print('AI Coach Service Error: $e');
      return _getFallbackResponse(userMessage);
    }
  }

  /// Hata durumunda fallback yanıt
  String _getFallbackResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('kaygı') || lowerMessage.contains('endişe') || lowerMessage.contains('stres')) {
      return '''Kaygı hissetmek tamamen normaldir ve bunu fark etmen harika bir ilk adım. 

Şu anda sana yardımcı olabilecek bir teknik: 4-7-8 Nefes Egzersizi
• 4 saniye burnundan içeri çek
• 7 saniye tut
• 8 saniye ağzından ver

Bunu 3-4 kez tekrarla. Nefesine odaklanmak zihnini sakinleştirebilir. 

Meditasyon bölümündeki "Kaygıyı Bırakmak" seansını da deneyebilirsin. Buradayım, istediğin zaman konuşabiliriz. 💚''';
    }

    if (lowerMessage.contains('uyku') || lowerMessage.contains('uyuyamıyorum')) {
      return '''Uyku sorunları gerçekten zorlayıcı olabilir. Bedenin ve zihnin dinlenmeyi hak ediyor.

Deneyebileceklerin:
• Yatmadan 30 dk önce ekran kullanmayı bırak
• "Uyku Meditasyonu" seansımızı dinle
• Yatak odanı serin ve karanlık tut
• Uyku hikayelerimizden birini dene

Bedeni gevşetmek için "Beden Taraması" meditasyonu da çok etkili olabilir. 

Bugünlük kendine karşı nazik ol. Her gece yeni bir başlangıçtır. 🌙''';
    }

    if (lowerMessage.contains('odak') || lowerMessage.contains('konsantre') || lowerMessage.contains('dikkat')) {
      return '''Odaklanma zorluğu yaşamak, özellikle yoğun zamanlarda çok yaygın.

Hemen deneyebileceklerin:
• 2 dakikalık "Odak Meditasyonu"
• Pomodoro tekniği: 25 dk çalış, 5 dk ara
• Box Breathing: 4-4-4-4 (çek-tut-ver-tut)

Küçük bir ipucu: Tek bir göreve odaklanmadan önce, 5 derin nefes al. Bu zihnini "hazırlar".

Sen yapabilirsin! Her küçük adım bir ilerleme. 🎯''';
    }

    return '''Seninle burada olmaktan mutluluk duyuyorum. Her duygu geçerlidir ve hissettiğin şey önemlidir.

Sana nasıl yardımcı olabilirim?
• Belirli bir duyguyla mı baş etmek istiyorsun?
• Rahatlamana yardımcı bir teknik mi arıyorsun?
• Sadece dinlenmene mi ihtiyacın var?

Buradan devam edebiliriz. 💚''';
  }

  /// Hızlı öneri al
  Future<String> getQuickSuggestion(UserModel user, List<JournalEntry> recentEntries) async {
    try {
      final userContext = _buildUserContext(user, recentEntries);

      final prompt = '''$_buildSystemPrompt()

Kullanıcı Bağlamı:
$userContext

Son günlük kayıtlarına ve hedeflerine bakarak, bugün için kısa, özel ve motive edici bir öneri sun. Maksimum 3 cümle.''';

      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Bugün kendine karşı nazik ol ve küçük bir adım at. 💚';

    } catch (e) {
      print('Quick suggestion error: $e');
      return 'Bugün kendine birkaç dakika ayır. Nefesine odaklan, duygularını fark et. Her an yeni bir başlangıç. 💚';
    }
  }
}

