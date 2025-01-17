import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tts_paketim/services.dart';
import 'package:tts_paketim/themecontroller.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  TextEditingController adcontroller = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  final TtsService ttsService = TtsService();
  final ThemeController themeController = Get.put(ThemeController());

  // Ses ayarları
  String selectedLanguage = 'Türkçe';
  String selectedVoice = 'tr-TR-Standard-A';
  double speed = 1.0;
  double pitch = 0.0;
  String selectedEffect = 'Normal';
  bool isMP3 = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.record_voice_over, color: Colors.blue),
            ),
            SizedBox(width: 12),
            Text(
              'VoiceCraft',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              ),
            ),
          ],
        ),
        actions: [
          // Sadece tema değiştirici
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: themeController.toggleTheme,
              icon: Obx(() => Icon(
                themeController.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
                color: Colors.blue,
              )),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Metin Girişi
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Metin', 
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: adcontroller,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Metninizi buraya yazın...',
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Ses Ayarları
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ses Ayarları', 
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      SizedBox(height: 16),
                      
                      // Dil Seçimi
                      DropdownButtonFormField<String>(
                        value: selectedLanguage,
                        decoration: InputDecoration(
                          labelText: 'Dil',
                          border: OutlineInputBorder(),
                        ),
                        items: TtsService.availableVoices.keys.map((lang) {
                          return DropdownMenuItem(
                            value: lang,
                            child: Text(lang),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLanguage = value!;
                            selectedVoice = TtsService.availableVoices[value]!.keys.first;
                          });
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Ses Seçimi
                      DropdownButtonFormField<String>(
                        value: selectedVoice,
                        decoration: InputDecoration(
                          labelText: 'Ses',
                          border: OutlineInputBorder(),
                        ),
                        items: TtsService.availableVoices[selectedLanguage]!
                          .entries.map((e) {
                          return DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedVoice = value!);
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Efekt Seçimi
                      DropdownButtonFormField<String>(
                        value: selectedEffect,
                        decoration: InputDecoration(
                          labelText: 'Ses Efekti',
                          border: OutlineInputBorder(),
                        ),
                        items: TtsService.audioEffects.keys.map((effect) {
                          return DropdownMenuItem(
                            value: effect,
                            child: Text(effect),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedEffect = value!);
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Hız Ayarı
                      Text('Hız: ${speed.toStringAsFixed(1)}x'),
                      Slider(
                        value: speed,
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        label: '${speed.toStringAsFixed(1)}x',
                        onChanged: (value) {
                          setState(() => speed = value);
                        },
                      ),
                      
                      SizedBox(height: 8),
                      
                      // Ton Ayarı
                      Text('Ton: ${pitch.toStringAsFixed(1)}'),
                      Slider(
                        value: pitch,
                        min: -10.0,
                        max: 10.0,
                        divisions: 20,
                        label: pitch.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() => pitch = value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Dosya Ayarları
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dosya Ayarları', 
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      SizedBox(height: 16),
                      
                      // Dosya Adı
                      TextFormField(
                        controller: fileNameController,
                        decoration: InputDecoration(
                          labelText: 'Dosya Adı (opsiyonel)',
                          border: OutlineInputBorder(),
                          hintText: 'örn: benim_sesim',
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Format Seçimi
                      Row(
                        children: [
                          Text('Format: ', style: TextStyle(fontSize: 16)),
                          Radio<bool>(
                            value: true,
                            groupValue: isMP3,
                            onChanged: (value) {
                              setState(() => isMP3 = value!);
                            },
                          ),
                          Text('MP3'),
                          SizedBox(width: 16),
                          Radio<bool>(
                            value: false,
                            groupValue: isMP3,
                            onChanged: (value) {
                              setState(() => isMP3 = value!);
                            },
                          ),
                          Text('WAV'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Butonlar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => ttsService.preview(
                      adcontroller.text,
                      voice: selectedVoice,
                      speed: speed,
                      pitch: pitch,
                      effect: selectedEffect,
                    ),
                    icon: Icon(Icons.play_arrow),
                    label: Text("Önizle"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => ttsService.stop(),
                    icon: Icon(Icons.stop),
                    label: Text("Durdur"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ses dosyası oluşturuluyor...')),
                      );
                      await ttsService.saveToFileWeb(
                        adcontroller.text,
                        voice: selectedVoice,
                        speed: speed,
                        pitch: pitch,
                        effect: selectedEffect,
                        fileName: fileNameController.text.isNotEmpty 
                          ? fileNameController.text 
                          : null,
                        isMP3: isMP3,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ses dosyası başarıyla kaydedildi')),
                      );
                    },
                    icon: Icon(Icons.download),
                    label: Text("İndir"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
