import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/ui/resources/app_icons.dart';

import 'package:weather_app/ui/routes/app_routes.dart';
import 'package:weather_app/ui/style/app_colors.dart';
import 'package:weather_app/ui/style/app_style.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final model=context.watch<WeatherProvider>();
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () {
              model.setFavorite(context, cityName: model.currentCity);
            },
            icon: SvgPicture.asset(
              AppIcons.location,
              color: AppColors.white,
            ),
            label: Text(
           model.currentCity,
              style: AppStyle.fontStyle.copyWith(
                fontSize: 18,
                color: AppColors.white
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              context.go(AppRoutes.search);
            },
            icon: Icon(
              Icons.menu,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
