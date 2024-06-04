import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:meal_app/screens/LodingScreen.dart';
import 'MealListScreen.dart';

class MealCategoryScreen extends StatefulWidget {
  @override
  _MealCategoryScreenState createState() => _MealCategoryScreenState();
}

class _MealCategoryScreenState extends State<MealCategoryScreen> {
  List<dynamic>?
      categories; // Kategorilerin listesi, nullable olarak tanımlanmalı

  // Kategorileri API'den getiren asenkron fonksiyon
  Future<List<dynamic>> fetchCategories() async {
    try {
      Response response = await Dio()
          .get('https://www.themealdb.com/api/json/v1/1/categories.php');
      return response.data['categories'];
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return []; // Hata durumunda boş liste döndür
    }
  }

  @override
  void initState() {
    super.initState();
    // initState fonksiyonu, widget oluşturulduğunda otomatik olarak çağrılır
    // Kategorileri getiren fonksiyonu çağır ve dönen değeri setState ile categories listesine ata
    fetchCategories().then((value) {
      setState(() {
        categories = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF00FF), // Arka plan rengi
      appBar: AppBar(
        title: Text(
          'Meal Categories',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Başlık yazı tipi kalın
            fontStyle: FontStyle.italic, // Başlık yazı tipi eğik
            color: Colors.white, // Başlık yazı rengi
          ),
        ),
        backgroundColor: Color(0xFFFF00FF), // AppBar arka plan rengi
      ),
      body: categories == null
          ? Center(
              child:
                  CircularProgressIndicator()) // Eğer kategoriler henüz yüklenmemişse bir yüklenme animasyonu göster
          : ListView.builder(
              itemCount: categories!.length, // Kategorilerin sayısı
              itemBuilder: (BuildContext context, int index) {
                final category =
                    categories![index]; // Index numarasına göre kategori alınır
                // Arka plan rengini belirleme, index çiftse bir renk, tekse diğer bir renk
                Color backgroundColor = index.isEven
                    ? Color.fromARGB(255, 240, 162, 220)
                    : Color.fromARGB(255, 247, 92, 239);
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return FadeTransition(
                            opacity: animation,
                            child: LoadingScreen(
                                nextScreen: MealListScreen(
                                    categoryName: category[
                                        'strCategory'])), // Yükleme ekranına geçiş yap ve MealListScreen'i yükle
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    color: backgroundColor,
                    child: ListTile(
                      leading: Image.network(
                        category[
                            'strCategoryThumb'], // Kategoriye ait resim URL'si
                        width: 50,
                        height: 50,
                      ),
                      title: Text(
                        category['strCategory'], // Kategori adı
                        style: TextStyle(
                          color: Colors.white, // Metin rengi beyaz
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
