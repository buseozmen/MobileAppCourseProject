import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:meal_app/screens/LodingScreen.dart';
import 'MealDetailScreen.dart';

class MealListScreen extends StatefulWidget {
  final String categoryName;

  MealListScreen({required this.categoryName});

  @override
  _MealListScreenState createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  List<dynamic>? meals; // Yemeklerin listesi, nullable olarak tanımlanmalı
  List<dynamic>?
      filteredMeals; // Filtrelenmiş yemeklerin listesi, nullable olarak tanımlanmalı
  TextEditingController searchController = TextEditingController();

  // Kategoriye ait yemekleri getiren asenkron fonksiyon
  Future<List<dynamic>> fetchMeals() async {
    try {
      Response response = await Dio().get(
          'https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.categoryName}');
      return response.data['meals'];
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return []; // Hata durumunda boş bir liste döndür
    }
  }

  @override
  void initState() {
    super.initState();
    // initState fonksiyonu, widget oluşturulduğunda otomatik olarak çağrılır
    // Yemekleri getiren fonksiyonu çağır ve dönen değeri setState ile meals listesine ve filteredMeals listesine ata
    fetchMeals().then((value) {
      setState(() {
        meals = value;
        filteredMeals = meals;
      });
    });
  }

  // Yemekleri filtrelemek için kullanılan fonksiyon
  void filterMeals(String query) {
    List<dynamic> searchResults = [];
    if (query.isNotEmpty && meals != null) {
      searchResults = meals!.where((meal) {
        final mealName = meal['strMeal'].toLowerCase();
        final input = query.toLowerCase();
        return mealName.contains(input);
      }).toList();
    } else {
      searchResults = meals ?? [];
    }
    setState(() {
      filteredMeals = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF00FF),
      appBar: AppBar(
        title: Text(
          'Meals in ${widget.categoryName}',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Başlık yazı tipi kalın
            fontStyle: FontStyle.italic, // Başlık yazı tipi eğik
            color: Colors.white, // Başlık yazı rengi
          ),
        ),
        backgroundColor: Color(0xFFFF00FF), // AppBar arka plan rengi
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterMeals(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200], // Yarı saydam gri arka plan rengi
              ),
              style: TextStyle(color: Colors.white), // Yazı rengini beyaz yapar
            ),
          ),
          Expanded(
            child: filteredMeals == null
                ? Center(
                    child:
                        CircularProgressIndicator()) // Eğer yemekler henüz yüklenmemişse bir yüklenme animasyonu göster
                : ListView.builder(
                    itemCount:
                        filteredMeals!.length, // Filtrelenmiş yemeklerin sayısı
                    itemBuilder: (BuildContext context, int index) {
                      final meal = filteredMeals![
                          index]; // Index numarasına göre yemek alınır
                      // Arka plan rengini sırayla belirleme, index çiftse bir renk, tekse diğer bir renk
                      Color backgroundColor = index % 2 == 0
                          ? Color.fromARGB(255, 240, 162, 220)
                          : Color.fromARGB(255, 247, 92, 239);
                      return Container(
                        color: backgroundColor,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                meal['strMealThumb']), // Yemek resminin URL'si
                          ),
                          title: Text(
                            meal['strMeal'],
                            style: TextStyle(
                              color: Colors.white, // Metin rengi beyaz
                            ),
                          ), // Yemek adı
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: LoadingScreen(
                                        nextScreen: MealDetailScreen(
                                            mealId: meal[
                                                'idMeal'])), // Yükleme ekranına geçiş yap ve MealDetailScreen'i yükle
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
