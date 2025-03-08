import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Örnek istatistik verileri
  final Map<String, Map<String, dynamic>> _statistics = {
    'Vize Görüşmesi': {
      'icon': Icons.card_membership,
      'color': const Color(0xFF5E5CE6),
      'completedTimes': 8,
      'totalTests': 12,
      'successRate': 0.85,
      'lastStudied': DateTime.now().subtract(const Duration(days: 2)),
    },
    'İş Sunumu': {
      'icon': Icons.business_center,
      'color': const Color(0xFF34C759),
      'completedTimes': 5,
      'totalTests': 7,
      'successRate': 0.72,
      'lastStudied': DateTime.now().subtract(const Duration(days: 5)),
    },
    'Mülakat': {
      'icon': Icons.person_search,
      'color': const Color(0xFFFF9500),
      'completedTimes': 10,
      'totalTests': 14,
      'successRate': 0.91,
      'lastStudied': DateTime.now().subtract(const Duration(days: 1)),
    },
    'İş Görüşmesi': {
      'icon': Icons.meeting_room,
      'color': const Color(0xFFFF2D55),
      'completedTimes': 6,
      'totalTests': 9,
      'successRate': 0.78,
      'lastStudied': DateTime.now().subtract(const Duration(days: 7)),
    },
  };

  // Kullanıcı bilgisi
  final Map<String, dynamic> _userInfo = {
    'name': 'Ali Yılmaz',
    'email': 'ali@example.com',
    'level': 'B1 Orta Seviye',
    'totalPoints': 3240,
    'memberSince': DateTime.now().subtract(const Duration(days: 90)),
    'streakDays': 14,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profil başlık ve kullanıcı bilgileri
              _buildProfileHeader(),
              
              const SizedBox(height: 20),
              
              // İlerleme özeti
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'İlerleme Durumu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // İlerleme kartları
              ...(_statistics.entries.map((entry) {
                final scenarioName = entry.key;
                final data = entry.value;
                return _buildScenarioProgressCard(
                  scenarioName, 
                  data['icon'] as IconData,
                  data['color'] as Color,
                  data['completedTimes'] as int,
                  data['totalTests'] as int,
                  data['successRate'] as double,
                  data['lastStudied'] as DateTime,
                );
              }).toList()),
              
              const SizedBox(height: 20),
              
              // İletişim kartı
              _buildContactCard(),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Profil başlık kısmı
  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profil resmi - avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF5E5CE6).withOpacity(0.7),
                      const Color(0xFF34C759).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Kullanıcı bilgileri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userInfo['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _userInfo['email'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Seviye göstergesi
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF5E5CE6),
                            const Color(0xFF34C759),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _userInfo['level'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          // İstatistikler
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  Icons.emoji_events,
                  '${_userInfo['totalPoints']}',
                  'Toplam Puan',
                ),
                _buildVerticalDivider(),
                _buildStatItem(
                  Icons.local_fire_department,
                  '${_userInfo['streakDays']}',
                  'Gün Serisi',
                ),
                _buildVerticalDivider(),
                _buildStatItem(
                  Icons.calendar_today,
                  '${_formatDate(_userInfo['memberSince'])}',
                  'Üyelik',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Senaryo ilerleme kartı
  Widget _buildScenarioProgressCard(
    String scenarioName,
    IconData icon,
    Color color,
    int completedTimes,
    int totalTests,
    double successRate,
    DateTime lastStudied,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
          Row(
            children: [
              // Senaryo ikonu
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Senaryo başlığı
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scenarioName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Son çalışma: ${_formatDate(lastStudied)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              // Başarı oranı
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color: _getSuccessRateColor(successRate),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${(successRate * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getSuccessRateColor(successRate),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // İlerleme detayları
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressItem(
                'Tamamlama',
                '$completedTimes kez',
                Icons.replay,
                color,
              ),
              _buildProgressItem(
                'Test Sayısı',
                '$totalTests adet',
                Icons.quiz,
                color,
              ),
              _buildProgressItem(
                'Başarı',
                '${(successRate * 100).toInt()}%',
                Icons.check_circle,
                _getSuccessRateColor(successRate),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // İletişim kartı
  Widget _buildContactCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.purple.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.support_agent, 
                color: Colors.blue.withOpacity(0.8),
                size: 24,
              ),
              const SizedBox(width: 10),
              const Text(
                'Bize Ulaşın',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Sorularınız veya önerileriniz için bize ulaşabilirsiniz.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          // İletişim butonları
          Row(
            children: [
              Expanded(
                child: _buildContactButton(
                  Icons.email,
                  'E-posta',
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildContactButton(
                  Icons.headset_mic,
                  'Destek',
                  Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildContactButton(
                  Icons.star,
                  'Değerlendir',
                  Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // İstatistik öğesi
  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFF5E5CE6),
          size: 20,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  // İlerleme detay öğesi
  Widget _buildProgressItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 18,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  // İletişim butonu
  Widget _buildContactButton(IconData icon, String label, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label butonuna tıklandı')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dikey ayırıcı çizgi
  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withOpacity(0.1),
    );
  }

  // Tarih formatı
  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  // Başarı oranına göre renk belirleme
  Color _getSuccessRateColor(double rate) {
    if (rate >= 0.8) return Colors.green;
    if (rate >= 0.6) return Colors.orange;
    return Colors.red;
  }
} 