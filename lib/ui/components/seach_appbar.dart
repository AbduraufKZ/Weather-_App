import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/ui/style/app_colors.dart';
import 'package:weather_app/ui/style/app_style.dart';

class SearchAppbar extends StatelessWidget {
  const SearchAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final model =context.watch<WeatherProvider>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             const AnimatedSearch(),
              IconButton(
                onPressed: () {
                  model.setCurrentCity(context);
                },
                icon: Icon(
                  Icons.search,
                  color: AppColors.white,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedSearch extends StatelessWidget {
  const AnimatedSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return SizedBox(
      height: 30,
      width: 280,
      child: TextField(
        controller: model.searchController,
        decoration: InputDecoration(
          fillColor: AppColors.dayColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          hintText: 'Введите названия городa',
          hintStyle: AppStyle.fontStyle.copyWith(
            fontSize: 14,
            color: AppColors.black.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
