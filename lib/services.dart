import 'package:flowery_tts/flowery_tts.dart';
import 'dart:html' as html;

class TtsService {
  final Flowery floweryTts = Flowery();

  // Kullanılabilir sesler - Genişletilmiş liste
  static const Map<String, Map<String, String>> availableVoices = {
    'Türkçe': {
      'tr-TR-Standard-A': 'Kadın 1',
      'tr-TR-Standard-B': 'Erkek 1',
      'tr-TR-Standard-C': 'Kadın 2',
      'tr-TR-Standard-D': 'Erkek 2',
      'tr-TR-Wavenet-A': 'Kadın (Wavenet)',
      'tr-TR-Wavenet-B': 'Erkek (Wavenet)',
    },
    'English': {
      'en-US-Standard-A': 'Female 1',
      'en-US-Standard-B': 'Male 1',
      'en-US-Wavenet-A': 'Female (Wavenet)',
      'en-US-Wavenet-B': 'Male (Wavenet)',
    },
    'Deutsch': {
      'de-DE-Standard-A': 'Weiblich 1',
      'de-DE-Standard-B': 'Männlich 1',
      'de-DE-Wavenet-A': 'Weiblich (Wavenet)',
      'de-DE-Wavenet-B': 'Männlich (Wavenet)',
    },
  };

  // Ses efektleri
  static const Map<String, double> audioEffects = {
    'Normal': 1.0,
    'Çocuk Sesi': 1.5,
    'Yetişkin': 0.9,
    'Robot': 0.7,
    'Dev': 0.5,
  };

  Future<void> speak(String text, {
    String voice = 'tr-TR-Standard-A',
    double speed = 1.0,
    double pitch = 1.0,
    String effect = 'Normal',
  }) async {
    if (text.isEmpty) return;
    try {
      html.window.speechSynthesis?.cancel();
      
      final utterance = html.SpeechSynthesisUtterance(text)
        ..lang = voice.substring(0, 5)
        ..rate = speed
        ..pitch = pitch * (audioEffects[effect] ?? 1.0);

      final voices = html.window.speechSynthesis?.getVoices();
      if (voices != null) {
        final selectedVoice = voices.firstWhere(
          (v) => v.lang?.contains(voice.substring(0, 5)) ?? false,
          orElse: () => voices.first,
        );
        utterance.voice = selectedVoice;
      }

      html.window.speechSynthesis?.speak(utterance);
    } catch (e) {
      print('Konuşma sırasında hata: $e');
    }
  }

  Future<void> stop() async {
    try {
      html.window.speechSynthesis?.cancel();
    } catch (e) {
      print('Durdurma sırasında hata: $e');
    }
  }

  Future<void> preview(String text, {
    required String voice,
    double speed = 1.0,
    double pitch = 0.0,
    String effect = 'Normal',
  }) async {
    await speak(text, voice: voice, speed: speed, pitch: pitch, effect: effect);
  }

  Future<void> saveToFileWeb(String text, {
    required String voice,
    double speed = 1.0,
    double pitch = 0.0,
    String effect = 'Normal',
    String? fileName,
    bool isMP3 = true,
  }) async {
    if (text.isEmpty) return;
    try {
      final response = await floweryTts.tts(
        text: text,
        voice: voice,
        speed: speed * (audioEffects[effect] ?? 1.0),
        audioFormat: isMP3 ? AudioFormat.mp3 : AudioFormat.wav,
      );
      
      final mimeType = isMP3 ? 'audio/mpeg' : 'audio/wav';
      final extension = isMP3 ? 'mp3' : 'wav';
      
      final blob = html.Blob([response], mimeType);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..download = fileName ?? 'tts_kayit_${DateTime.now().millisecondsSinceEpoch}.$extension'
        ..click();
      
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('Web\'de ses dosyası oluşturma hatası: $e');
    }
  }
}
