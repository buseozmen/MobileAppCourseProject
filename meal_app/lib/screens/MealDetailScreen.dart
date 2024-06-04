import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  MealDetailScreen(
      {required this.mealId}); // Yemek ID'sini alan bir constructor

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Map<String, dynamic>?
      mealDetails; // Yemek detaylarını saklayan bir değişken (nullable)

  // Belirli bir yemek ID'sine sahip yemeğin detaylarını API'den çeken metot
  Future<Map<String, dynamic>> fetchMealDetails() async {
    try {
      Response response = await Dio().get(
          'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}');
      return response.data['meals'][0];
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return {}; // Hata durumunda boş bir harita döndür
    }
  }

  @override
  void initState() {
    super.initState();
    // Ekran oluşturulduğunda, yemek detaylarını çeken metodu çağırır ve detayları alır
    fetchMealDetails().then((value) {
      setState(() {
        mealDetails = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF00FF),
      appBar: AppBar(
        title: Text(
          'Meal Details', // Ekran başlığı
          style: TextStyle(
            fontWeight: FontWeight.bold, // Kalın yazı stili
            fontStyle: FontStyle.italic, // Eğik yazı stili
            color: Colors.white, // Yazı rengi
          ),
        ),
        backgroundColor: Color(0xFFFF00FF), // App bar arka plan rengi
      ),
      body: mealDetails == null // Eğer yemek detayları henüz alınmadıysa
          ? Center(
              child: CircularProgressIndicator()) // Yükleme göstergesi göster
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      mealDetails!['strMealThumb'], // Yemek resmi URL'si

                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: SelectableText(
                        mealDetails!['strMeal'], // Yemek adı
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        children: [
                          TextSpan(
                            text: 'Category: ', // Kategori
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text:
                                  mealDetails!['strCategory']), // Kategori adı
                          TextSpan(
                            text: '\n\nArea: ', // Alan
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: mealDetails!['strArea']), // Alan adı
                          TextSpan(
                            text: '\n\nInstructions: ', // Talimatlar
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: mealDetails![
                                  'strInstructions']), // Talimatlar
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
