import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math'; // Matematik fonksiyonları için gerekli import
import '../main.dart';
import 'package:audioplayers/audioplayers.dart'; // Değiştirildi
// Just audio paketini geçici olarak kaldırıyoruz

class ScenarioDetailScreen extends StatefulWidget {
  final ScenarioItem scenario;

  const ScenarioDetailScreen({super.key, required this.scenario});

  @override
  State<ScenarioDetailScreen> createState() => _ScenarioDetailScreenState();
}

class _ScenarioDetailScreenState extends State<ScenarioDetailScreen>
    with SingleTickerProviderStateMixin {  // AnimationController için ekledik
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _dialogPlayer = AudioPlayer();
  
  // Animation Controller - Arka plan zoom efekti için
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  // Ses kontrolü için geçici değişkenler
  bool _isPlaying = false;
  bool _isDiaglogCompleted = false;
  int _currentDialogIndex = 0;
  List<DialogLine> _dialogLines = [];
  Timer? _dialogTimer;
  bool _showTranslation = false;
  
  // Test bölümü için değişkenler
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _isAnswerChecked = false;
  
  // Sınıf değişkenlerine controller ekleme
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _loadScenarioData();
    _setupBackgroundAudio();
    
    // Zoom animasyonu kurulumu
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // Çok yavaş zoom efekti
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // İleri geri sürekli animasyon
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    
    _animationController.forward();
  }
  
  void _loadScenarioData() {
    if (widget.scenario.dialogData != null) {
      final dialogData = widget.scenario.dialogData!;
      
      // Diyalog verilerini dönüştür
      if (dialogData.containsKey('dialog')) {
        final dialogList = dialogData['dialog'] as List;
        
        // Diyalogları dönüştür ve sadece ilk 4 konuşmayı al
        _dialogLines = dialogList
            .map((item) => DialogLine.fromMap(item))
            .toList()
            .take(4)  // En fazla 4 diyalog göster
            .toList();
      }
    }
  }
  
  Future<void> _setupBackgroundAudio() async {
    try {
      // Arka plan müziğini ayarla (sesi düşük)
      await _backgroundPlayer.play(AssetSource('music/arkaplan.mp3'));
      await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundPlayer.setVolume(0.7); // Arka plan sesini kısık tut
    } catch (e) {
      debugPrint('Arka plan sesi yüklenemedi: $e');
    }
  }
  
  Future<void> _playCurrentDialog() async {
    try {
      // Mevcut diyalog satırına göre ses dosyasını seç
      String audioFile = '';
      
      // Örnek ses dosyaları
      if (_currentDialogIndex == 0) {
        audioFile = 'music/4.mp3';
      } else if (_currentDialogIndex == 1) {
        audioFile = 'music/3.mp3';
      } else if (_currentDialogIndex == 2) {
        audioFile = 'music/2.mp3';
      } else if (_currentDialogIndex == 3) {
        audioFile = 'music/1.mp3';
      }
      
      // Ses dosyasını yükle ve oynat (daha yüksek ses)
      if (audioFile.isNotEmpty) {
        await _dialogPlayer.play(AssetSource(audioFile));
        await _dialogPlayer.setVolume(1.0); // Diyalog sesini tam seviyede tut
      }
    } catch (e) {
      debugPrint('Diyalog sesi yüklenemedi: $e');
    }
  }
  
  void _startDialogPlayback() {
    setState(() {
      _isPlaying = true;
    });
    
    // İlk diyalogu hemen göster ve sesini çal
    setState(() {
      _currentDialogIndex = 0;
    });
    _playCurrentDialog();
    
    // Diyalogları zamanlamalı olarak göster
    _dialogTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentDialogIndex < _dialogLines.length - 1) {
        setState(() {
          _currentDialogIndex++;
        });
        _playCurrentDialog(); // Yeni diyaloğun sesini çal
        
        // Otomatik kaydırma
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      } else {
        timer.cancel();
        
        // Son diyaloğu gösterdikten sonra test bölümüne geç
        Future.delayed(const Duration(seconds: 3), () {
          // Tüm sesleri durdur
          _backgroundPlayer.stop();
          _dialogPlayer.stop();
          
          setState(() {
            _isDiaglogCompleted = true;
          });
        });
      }
    });
  }
  
  @override
  void dispose() {
    _dialogTimer?.cancel();
    _scrollController.dispose();
    _backgroundPlayer.dispose();
    _dialogPlayer.dispose();
    _animationController.dispose();  // Animation Controller temizliği
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Animasyonlu arka plan resmi
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Image.asset(
                      widget.scenario.image,
                      fit: BoxFit.cover,
                      opacity: const AlwaysStoppedAnimation(0.6),
                    ),
                  );
                }
              ),
            ),
            
            // Ana içerik
            Positioned.fill(
              child: _isDiaglogCompleted 
                  ? _buildTestSection() 
                  : _buildDialogSection(),
            ),
            
            // Üst kısım kontrolleri
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Geri butonu
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  
                  // Senaryo başlığı
                  Text(
                    widget.scenario.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: '.SF Pro Display',
                    ),
                  ),
                  
                  // Çeviri düğmesi
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showTranslation = !_showTranslation;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _showTranslation ? Icons.g_translate : Icons.translate_outlined,
                        color: _showTranslation ? Colors.blue : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Diyalog bölümü
  Widget _buildDialogSection() {
    if (_currentDialogIndex == 0 && _dialogTimer == null) {
      // Diyalog başlamadan önce bilgi ekranı
      return _buildStartInfoScreen();
    }
    
    return Stack(
      children: [
        // Arka plan hafif karartma
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
        
        // Diyalog konuşmaları - scroll controller eklendi
        SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 80, bottom: 100),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Diyalog içeriği
              if (_dialogLines.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      for (int i = 0; i <= _currentDialogIndex; i++) 
                        _buildDialogBubble(_dialogLines[i], i == _currentDialogIndex),
                    ],
                  ),
                ),
            ],
          ),
        ),
        
        // Ses durumu - daha görünür ve bilgilendirici hale getirildi
        if (_isPlaying)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Konuşmacı simgesi
                        Icon(
                          _currentDialogIndex % 2 == 0 ? Icons.record_voice_over : Icons.voice_chat,
                          color: widget.scenario.color,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        // Konuşmacı bilgisi
                        Text(
                          _dialogLines[_currentDialogIndex].speaker,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Ses indikatörü
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: _AudioWaveIndicator(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Ses bilgisi mesajı
                    Text(
                      "Ses paketi yüklenmediği için sesler çalınamıyor",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // İlerleme durumu
                    Text(
                      "İlerleme: ${_currentDialogIndex + 1}/${_dialogLines.length}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
  
  // Netflix tarzı başlangıç bilgi ekranı - daha kompakt
  Widget _buildStartInfoScreen() {
    final dialogCount = _dialogLines.length;
    final estimatedMinutes = (dialogCount * 5) ~/ 60 + 1; 
    final questionCount = (widget.scenario.dialogData!['questions'] as List).length;
    
    // Ekran boyutunu al
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight - 80; // SafeArea'dan sonraki kullanılabilir alan
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          // Senaryo görseli - daha küçük
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: availableHeight * 0.45, // Daha küçük görsel
            child: Stack(
              children: [
                // Görsel
                Positioned.fill(
                  child: Image.asset(
                    widget.scenario.image,
                    fit: BoxFit.cover,
                  ),
                ),
                // Kademeli karartma
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.9),
                          Colors.black,
                        ],
                        stops: const [0.4, 0.75, 0.9, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // İçerik - sabit yerleşim (daha kompakt)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Üst boşluk
                  SizedBox(height: availableHeight * 0.38),
                  
                  // Senaryo rengi çizgi
                  Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: widget.scenario.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  const SizedBox(height: 12), // Daha küçük boşluk
                  
                  // Senaryo başlığı
                  Text(
                    widget.scenario.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28, // Daha küçük font
                      fontWeight: FontWeight.bold,
                      fontFamily: '.SF Pro Display',
                    ),
                  ),
                  
                  const SizedBox(height: 8), // Daha küçük boşluk
                  
                  // Bilgi çipleri - yatay sırada, daha kompakt
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildInfoChipWithIcon('$estimatedMinutes dk', Icons.timer_outlined),
                        const SizedBox(width: 8),
                        _buildInfoChipWithIcon('$dialogCount diyalog', Icons.chat_bubble_outline),
                        const SizedBox(width: 8),
                        _buildInfoChipWithIcon('$questionCount test', Icons.quiz_outlined),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 12), // Daha küçük boşluk
                  
                  // Senaryo açıklaması
                  Text(
                    widget.scenario.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14, // Daha küçük font
                      height: 1.3,
                      fontFamily: '.SF Pro Text',
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 2, // Sınırlı satır
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 16), // Daha küçük boşluk
                  
                  // Kısa ipuçları - daha kompakt
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: widget.scenario.color,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'İngilizce diyalogları dinle ve sonrasında teste katıl.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(), // Kalan alanı doldur
                  
                  // Başlat butonu
                  ElevatedButton(
                    onPressed: _startDialogPlayback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.scenario.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow_rounded, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Diyaloğu Başlat',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20), // Alt boşluk
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Daha kompakt bilgi çipi
  Widget _buildInfoChipWithIcon(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: widget.scenario.color,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
  
  // Bilgi çipi - daha modern
  Widget _buildInfoPill(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: widget.scenario.color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
  
  // Modern adım açıklaması
  Widget _buildInstructionStepModern(String stepNumber, String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Adım numarası ve icon
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.scenario.color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                color: widget.scenario.color,
                size: 24,
              ),
            ),
          ),
          
          // Adım açıklaması
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Üst kısım: numara ve başlık
                Row(
                  children: [
                    Text(
                      stepNumber,
                      style: TextStyle(
                        color: widget.scenario.color,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Açıklama
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Diyalog balonu
  Widget _buildDialogBubble(DialogLine line, bool isActive) {
    final bool isFirstSpeaker = line.speaker == widget.scenario.dialogData!['participants'][0];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isFirstSpeaker ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFirstSpeaker) const Spacer(),
          
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isFirstSpeaker ? Colors.blue : widget.scenario.color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                line.speaker[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 10),
          
          // Konuşma balonu
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(18),
                border: isActive ? Border.all(
                  color: isFirstSpeaker ? Colors.blue : widget.scenario.color,
                  width: 1.5,
                ) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // İngilizce metin
                  Text(
                    line.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: isActive ? FontWeight.w500 : FontWeight.w300,
                    ),
                  ),
                  
                  // Çeviri (eğer etkinse)
                  if (_showTranslation)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        line.translation,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          if (isFirstSpeaker) const Spacer(),
        ],
      ),
    );
  }
  
  // Yeniden tasarlanmış test bölümü - kaydırılabilir
  Widget _buildTestSection() {
    final questions = widget.scenario.dialogData!['questions'] as List;
    if (_currentQuestionIndex >= questions.length) {
      // Tüm testler tamamlandı
      return _buildCompletionScreen();
    }
    
    final questionData = questions[_currentQuestionIndex];
    final options = questionData['options'] as List;
    final correctAnswerIndex = questionData['correctAnswer'] as int;
    
    // İlerleme hesapla
    final progress = (_currentQuestionIndex + 1) / questions.length;
    
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              // İlerleme göstergesi - sabit boyut
              Row(
                children: [
                  // İlerleme metni
                  Text(
                    'Soru ${_currentQuestionIndex + 1}/${questions.length}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  // Puan göstergesi (opsiyonel)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.scenario.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: widget.scenario.color,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(_currentQuestionIndex * 10)}',
                          style: TextStyle(
                            color: widget.scenario.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // İlerleme çubuğu
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(widget.scenario.color),
                  minHeight: 6,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Kaydırılabilir içerik
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    
                    // Test başlığı
                    const Text(
                      'Öğrendiğini Test Et',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: '.SF Pro Display',
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Soru kartı - daha kompakt
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Soru Numarası
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.scenario.color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Soru ${_currentQuestionIndex + 1}',
                              style: TextStyle(
                                color: widget.scenario.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Soru metni
                          Text(
                            questionData['question'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Seçenekler - daha kompakt
                    ...List.generate(options.length, (index) {
                      final bool isSelected = _selectedAnswerIndex == index;
                      final bool isCorrect = index == correctAnswerIndex;
                      
                      // Sonuç renkleri
                      Color borderColor = Colors.white.withOpacity(0.2);
                      Color bgColor = Colors.black.withOpacity(0.3);
                      
                      if (_isAnswerChecked && isSelected) {
                        borderColor = isCorrect ? Colors.green : Colors.red;
                        bgColor = isCorrect 
                            ? Colors.green.withOpacity(0.1) 
                            : Colors.red.withOpacity(0.1);
                      } else if (_isAnswerChecked && isCorrect) {
                        borderColor = Colors.green;
                        bgColor = Colors.green.withOpacity(0.05);
                      } else if (isSelected) {
                        borderColor = widget.scenario.color;
                        bgColor = widget.scenario.color.withOpacity(0.1);
                      }
                      
                      return GestureDetector(
                        onTap: _isAnswerChecked 
                            ? null 
                            : () {
                                setState(() {
                                  _selectedAnswerIndex = index;
                                });
                              },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              // Seçenek belirteci (A, B, C, D gibi)
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected 
                                      ? (_isAnswerChecked 
                                          ? (isCorrect ? Colors.green : Colors.red) 
                                          : widget.scenario.color)
                                      : Colors.white.withOpacity(0.1),
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + index), // A, B, C, D...
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(width: 10),
                              
                              // Seçenek metni
                              Expanded(
                                child: Text(
                                  options[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w300,
                                  ),
                                ),
                              ),
                              
                              // Doğru/yanlış ikonu
                              if (_isAnswerChecked)
                                Icon(
                                  isCorrect 
                                      ? Icons.check_circle_rounded 
                                      : (isSelected ? Icons.cancel_rounded : null),
                                  color: isCorrect ? Colors.green : Colors.red,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              
              // Sabit buton alanı
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 12, bottom: 16),
                child: ElevatedButton(
                  onPressed: _selectedAnswerIndex == null 
                      ? null 
                      : () {
                          if (_isAnswerChecked) {
                            // Sonraki soruya geç
                            setState(() {
                              _currentQuestionIndex++;
                              _selectedAnswerIndex = null;
                              _isAnswerChecked = false;
                            });
                          } else {
                            // Cevabı kontrol et
                            setState(() {
                              _isAnswerChecked = true;
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAnswerChecked 
                        ? (_selectedAnswerIndex == correctAnswerIndex ? Colors.green : widget.scenario.color) 
                        : widget.scenario.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isAnswerChecked ? Icons.arrow_forward_rounded : Icons.check_circle_outline_rounded,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isAnswerChecked ? 'Sonraki Soru' : 'Cevabı Kontrol Et',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Yeni tamamlama ekranı
  Widget _buildCompletionScreen() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Konfeti efekti veya benzeri animasyon eklenebilir
            
            // Tamamlama İkonu
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.scenario.color.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: widget.scenario.color.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.emoji_events_rounded,
                color: widget.scenario.color,
                size: 80,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Tebrik metni
            const Text(
              'Tebrikler!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: '.SF Pro Display',
              ),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Bu senaryoyu başarıyla tamamladın.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 18,
              ),
            ),
            
            const SizedBox(height: 14),
            
            // Puan bilgisi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: widget.scenario.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.scenario.color.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: widget.scenario.color,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '+100 Puan',
                    style: TextStyle(
                      color: widget.scenario.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 50),
            
            // Butonlar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tekrar dene butonu
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentQuestionIndex = 0;
                      _selectedAnswerIndex = null;
                      _isAnswerChecked = false;
                      _isDiaglogCompleted = false;
                    });
                  },
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Tekrar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Ana sayfaya dön butonu
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Ana Sayfa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.scenario.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                    shadowColor: widget.scenario.color.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Diyalog satırı model sınıfı
class DialogLine {
  final String speaker;
  final String text;
  final String translation;
  final String audioFile;
  
  DialogLine({
    required this.speaker,
    required this.text,
    required this.translation,
    this.audioFile = '',  // Gerçek implementasyonda ses dosyası yolu buraya gelecek
  });
  
  factory DialogLine.fromMap(Map<String, dynamic> map) {
    return DialogLine(
      speaker: map['speaker'],
      text: map['text'],
      translation: map['translation'],
      audioFile: map['audioFile'] ?? '',
    );
  }
}

// Ses dalgası animasyonu için widget
class _AudioWaveIndicator extends StatefulWidget {
  const _AudioWaveIndicator();

  @override
  State<_AudioWaveIndicator> createState() => _AudioWaveIndicatorState();
}

class _AudioWaveIndicatorState extends State<_AudioWaveIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            // Animasyonu faz olarak kaydırma
            final delay = index * 0.2;
            final value = sin((_controller.value * 2 * 3.14159 + delay) % (2 * 3.14159));
            
            // Açıkça double'a dönüştürme
            final double height = 4.0 + (value + 1.0) * 5.0;
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              height: height,
              width: 3,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(1),
              ),
            );
          }),
        );
      }
    );
  }
} 