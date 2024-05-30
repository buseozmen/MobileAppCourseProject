import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final Widget nextScreen; // Sonraki ekranı belirleyen bir widget

  LoadingScreen({required this.nextScreen}); // LoadingScreen'in constructor'ı

  @override
  Widget build(BuildContext context) {
    // Future.delayed metodu, belirtilen süre kadar bekledikten sonra bir işlem yapar
    Future.delayed(Duration(seconds: 1), () {
      // Navigator.of(context).pushReplacement metodu, belirtilen sayfaya geçiş yapar
      Navigator.of(context).pushReplacement(
        // PageRouteBuilder, özelleştirilmiş sayfa geçişleri oluşturmayı sağlar
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 200), // Geçiş süresi
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            // Yeni sayfanın oluşturulması
            return FadeTransition(
              opacity: animation, // Sayfa geçişindeki opaklık efekti
              child: nextScreen, // Sonraki ekran
            );
          },
        ),
      );
    });

    // Scaffold widget'ı, bir uygulamanın temel yapı taşıdır
    return Scaffold(
      backgroundColor: Color(0xFFFF00FF), // Arka plan rengi
      // Body widget'ı, sayfanın içeriğini oluşturur
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator( // Yükleme göstergesi
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Göstergenin rengi
            ),
            SizedBox(height: 20), // Yatay boşluk
            Text(
              'Loading...', // Yükleme metni
              style: TextStyle(
                color: Colors.white, // Metin rengi
                fontSize: 18, // Metin boyutu
                fontWeight: FontWeight.bold, // Kalın metin
              ),
            ),
          ],
        ),
      ),
    );
  }
}
