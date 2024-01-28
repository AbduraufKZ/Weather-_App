import 'package:flutter/material.dart';
import 'package:weather_app/ui/components/Favorite_list.dart';
import 'package:weather_app/ui/components/seach_appbar.dart';
import 'package:weather_app/ui/style/app_style.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF391A49),
              Color(0xFF301D5C),
              Color(0xFF262171),
              Color(0xFF262171),
              Color(0xFF301D5C),
              Color(0xFF391A49),
            ],
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SearchAppbar(),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Saved Locations',
              style: AppStyle.fontStyle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 25),
            const FavoriteList(),
          ],
        ),
      ),
    );
  }
}
