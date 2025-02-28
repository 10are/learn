import 'package:flutter/material.dart';
import '../main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Üst boşluk
              SizedBox(height: screenHeight * 0.02),
              
              // Logo ve başlık kısmı
              Column(
                children: [
                  // Daha renkli logo container
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.purple.withOpacity(0.7),
                          Colors.blue.withOpacity(0.5),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.language_outlined,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Öğrenmeye Başla',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontFamily: '.SF Pro Display',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Psikolog destekli akıllı dil öğrenme asistanı',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.4,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3,
                      fontFamily: '.SF Pro Text',
                    ),
                  ),
                ],
              ),
              
              // Giriş butonları
              Column(
                children: [
                  _buildLoginButton(
                    'Google ile devam et',
                    Icons.g_mobiledata_rounded,
                    context,
                    const Color(0xFFEA4335),
                  ),
                  const SizedBox(height: 12),
                  _buildLoginButton(
                    'Apple ile devam et', 
                    Icons.apple_rounded,
                    context,
                    Colors.white,
                    textColor: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  _buildLoginButton(
                    'Telefon numarası ile devam et',
                    Icons.phone_outlined,
                    context,
                    const Color(0xFF34C759),
                  ),
                  const SizedBox(height: 20),
                  
                  // Misafir girişi butonu
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Misafir olarak devam et',
                      style: TextStyle(
                        color: Colors.blue.withOpacity(0.8),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                        fontFamily: '.SF Pro Text',
                      ),
                    ),
                  ),
                ],
              ),
              
              // Kullanım koşulları
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Devam ederek Kullanım Koşulları ve Gizlilik Politikamızı kabul etmiş olursunuz.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    height: 1.4,
                    fontFamily: '.SF Pro Text',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(
    String text, 
    IconData icon, 
    BuildContext context, 
    Color accentColor, {
    Color? backgroundColor,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: backgroundColor != null ? backgroundColor : accentColor.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: textColor ?? accentColor,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.3,
                fontFamily: '.SF Pro Text',
              ),
            ),
          ],
        ),
      ),
    );
  }
} 