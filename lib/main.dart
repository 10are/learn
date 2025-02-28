import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/scenario_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İngilizce Öğrenme',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: '.SF Pro Text',
      ),
      home: const OnboardingScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  // Öne çıkan senaryo
  final ScenarioItem featuredScenario = ScenarioItem(
    title: 'Vize Başvurusu',
    description: 'Vize başvuru sürecinde gerekli olan İngilizce diyalogları öğrenin',
    image: 'assets/images/visa.webp',
    dialogData: visaDialogData,
    color: const Color(0xFF5E5CE6),
    isNew: true,
  );
  
  // Popüler senaryolar
  final List<ScenarioItem> popularScenarios = [
    ScenarioItem(
      title: 'İş Sunumu',
      description: 'İş sunumlarında kullanılan yaygın İngilizce diyalogları öğrenin',
      image: 'assets/images/presentation.webp',
      color: const Color(0xFF34C759),
    ),
    ScenarioItem(
      title: 'Mülakat',
      description: 'İş mülakatlarında kullanılan profesyonel İngilizce konuşmaları pratik yapın',
      image: 'assets/images/interview.webp',
      color: const Color(0xFFFF9500),
    ),
    ScenarioItem(
      title: 'İş Görüşmesi',
      description: 'İş ortamında günlük konuşmaları öğrenin',
      image: 'assets/images/meeting.webp',
      color: const Color(0xFFFF2D55),
    ),
  ];
  
  // Yeni eklenen senaryolar
  final List<ScenarioItem> newScenarios = [
    ScenarioItem(
      title: 'Restoranda Sipariş',
      description: 'Restoranda sipariş verirken kullanılan ifadeleri öğrenin',
      image: 'assets/images/visa.webp',
      color: const Color(0xFF007AFF),
      isNew: true,
    ),
    ScenarioItem(
      title: 'Seyahat Planlama',
      description: 'Seyahatlerde kullanılan temel İngilizce ifadeleri pratik yapın',
      image: 'assets/images/presentation.webp',
      color: const Color(0xFFAF52DE),
      isNew: true,
    ),
    ScenarioItem(
      title: 'Alışveriş',
      description: 'Alışveriş yaparken kullanılan ifadeleri öğrenin',
      image: 'assets/images/interview.webp',
      color: const Color(0xFFFF9500),
      isNew: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst kısım - Karşılama metni ve profil
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Merhaba 👋',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Bugün ne öğrenmek istersin?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: '.SF Pro Display',
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Öne çıkan senaryo
              GestureDetector(
                onTap: () {
                  if (featuredScenario.dialogData != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScenarioDetailScreen(scenario: featuredScenario),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 220,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(featuredScenario.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Karartma gradyanı
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // İçerik
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Yeni etiketi
                            if (featuredScenario.isNew)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'YENİ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            Text(
                              featuredScenario.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              featuredScenario.description,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Popüler Senaryolar
              _buildCategorySection(
                title: 'Popüler Senaryolar',
                scenarios: popularScenarios,
              ),
              
              const SizedBox(height: 30),
              
              // Yeni Senaryolar
              _buildCategorySection(
                title: 'Yeni Eklenenler',
                scenarios: newScenarios,
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.5),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Keşfet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              activeIcon: Icon(Icons.bookmark),
              label: 'Kaydedilenler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Ayarlar',
            ),
          ],
        ),
      ),
    );
  }
  
  // Kategori bölümü oluşturan metod
  Widget _buildCategorySection({required String title, required List<ScenarioItem> scenarios}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.3,
              fontFamily: '.SF Pro Display',
            ),
          ),
        ),
        SizedBox(
          height: 170,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 20),
            scrollDirection: Axis.horizontal,
            itemCount: scenarios.length,
            itemBuilder: (context, index) {
              return _buildScenarioCard(scenarios[index]);
            },
          ),
        ),
      ],
    );
  }
  
  // Netflix tarzı kart oluşturan metod
  Widget _buildScenarioCard(ScenarioItem scenario) {
    return GestureDetector(
      onTap: () {
        if (scenario.dialogData != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScenarioDetailScreen(scenario: scenario),
            ),
          );
        }
      },
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withOpacity(0.08),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                image: DecorationImage(
                  image: AssetImage(scenario.image),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.topLeft,
              child: scenario.isNew
                  ? Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'YENİ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : null,
            ),
            // Başlık ve açıklama
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scenario.title,
                    style: TextStyle(
                      color: scenario.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scenario.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScenarioItem {
  final String title;
  final String description;
  final String image;
  final Map<String, dynamic>? dialogData;
  final Color color;
  final bool isNew;

  ScenarioItem({
    required this.title,
    required this.description,
    required this.image,
    this.dialogData,
    Color? color,
    this.isNew = false,
  }) : color = color ?? const Color(0xFF5E5CE6);
}

final Map<String, dynamic> visaDialogData = {
  "title": "Vize Görüşmesi",
  "participants": ["Interviewer", "Applicant"],
  "dialog": [
    {
      "speaker": "Interviewer",
      "text": "Good morning. What is the purpose of your visit to the United States?",
      "translation": "Günaydın. Amerika Birleşik Devletleri'ne seyahat amacınız nedir?"
    },
    {
      "speaker": "Applicant",
      "text": "I am planning to visit for tourism purposes. I want to see New York and California.",
      "translation": "Turizm amaçlı seyahat etmeyi planlıyorum. New York ve California'yı görmek istiyorum."
    },
    {
      "speaker": "Interviewer",
      "text": "How long do you plan to stay?",
      "translation": "Ne kadar kalmayı planlıyorsunuz?"
    },
    {
      "speaker": "Applicant",
      "text": "I plan to stay for two weeks.",
      "translation": "İki hafta kalmayı planlıyorum."
    }
  ],
  "questions": [
    {
      "question": "What is the main purpose of the applicant's visit?",
      "options": ["Business", "Tourism", "Education", "Family visit"],
      "correctAnswer": 1
    },
    {
      "question": "How long does the applicant plan to stay?",
      "options": ["One week", "Two weeks", "One month", "Three months"],
      "correctAnswer": 1
    }
  ]
};
