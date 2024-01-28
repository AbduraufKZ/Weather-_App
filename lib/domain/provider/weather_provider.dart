import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/domain/api/api.dart';
import 'package:weather_app/domain/hive/favorite_history.dart';
import 'package:weather_app/domain/hive/hive_box.dart';
import 'package:weather_app/domain/models/city_photo.dart';
import 'package:weather_app/domain/models/coord.dart';
import 'package:weather_app/domain/models/weather_data.dart';
import 'package:weather_app/ui/resources/app_bg.dart';
import 'package:weather_app/ui/routes/app_routes.dart';
import 'package:weather_app/ui/style/app_colors.dart';

class WeatherProvider extends ChangeNotifier {
  //хранение координат
  Coord? coords;

  //хранение данных о погоде
  WeatherData? weatherData;

  //хранить текущие данные о погоде
  Current? current;

  //хранение текущих данных о фотографиях
  CityPhotos? cityPhotos;

  //контроллер ввода для поиска и установки города
  final searchController = TextEditingController();

  /*Главная функция которую мы будем запускать в FutureBuilder*/

  Future<WeatherData?> setUp({String? cityName}) async {
    cityName = (await pref).getString('city_name');
    coords = await Api.getCoords(cityName: cityName ?? 'Tashkent');
    weatherData = await Api.getWeather(coords);
    current = weatherData?.current;
    cityPhotos = await Api.getPhoto(cityName: cityName ?? 'Tashkent');
    setCurrentDay();
    setCurrentDayTime();
    setCurrentTime();
    setCurrentTemp();
    setWeekDay();
    getCurrentCity();

    return weatherData;
  }

  final pref = SharedPreferences.getInstance();
//установка текущего городв
  Future<void> setCurrentCity(BuildContext context, {String? cityName}) async {
    if (searchController.text != '') {
      cityName = searchController.text;
      (await pref).setString('city_name', cityName);
      await setUp(cityName: (await pref).getString('city_name'))
          .then((value) => context.go(AppRoutes.home))
          .then((value) => searchController.clear());
    }
  }

  String currentCity = '';
  Future<String> getCurrentCity() async {
    currentCity = (await pref).getString('city_name') ?? 'Ташкент';
    return capitalize(currentCity);
  }

  //текущая дата
  String? currentDay;
  String setCurrentDay() {
    final getTime = (current?.dt ?? 0) + (weatherData?.timezoneOffset ?? 0);
    final setTime = DateTime.fromMillisecondsSinceEpoch(getTime * 1000);
    currentDay = DateFormat('MMMM d').format(setTime);
    return currentDay ?? 'Error';
  }

  //текущая дата ./././
  String? currentDayTime;

  String setCurrentDayTime() {
    final getTime = (current?.dt ?? 0) + (weatherData?.timezoneOffset ?? 0);
    final setTime = DateTime.fromMillisecondsSinceEpoch(getTime * 1000);
    currentDayTime = DateFormat('yMd').format(setTime);
    return currentDayTime ?? 'Error';
  }

  //текущая время
  String? currentTime;

  String setCurrentTime() {
    final getTime = (current?.dt ?? 0) + (weatherData?.timezoneOffset ?? 0);
    final setTime = DateTime.fromMillisecondsSinceEpoch(getTime * 1000);
    currentTime = DateFormat('HH:mm a').format(setTime);
    return currentTime ?? 'Error';
  }

  //получение текущей иконки в зависимости от погоды
  final String _weatherIconUrl = 'https://api.openweathermap.org/img/w/';

  String iconData() {
    return '$_weatherIconUrl${current?.weather?[0].icon}.png';
  }

  //метод превращения первой буквы слова в заглавную, остальные строчные
  String capitalize(String str) => str[0].toUpperCase() + str.substring(1);

  //текущий статус погоды
  String currentStatus = '';
  String getCurrentStatus() {
    currentStatus = current?.weather?[0].description ?? 'Ошибка';
    return capitalize(currentStatus);
  }

  int kelvin = -273;
  //получение текущей температуры

  int currentTemp = 0;
  int setCurrentTemp() {
    currentTemp = ((current?.temp ?? -kelvin) + kelvin).round();
    return currentTemp;
  }

  //Влажность
  int humidity = 0;

  int setHumidity() {
    humidity = ((current?.humidity ?? 0) / 1).round();
    return humidity;
  }

  //скорость ветра

  dynamic windSpeed = 0;
  dynamic setWindSpeed() {
    windSpeed = current?.windSpeed ?? 0;
    return windSpeed;
  }
  // 15.6 = 15 toInt(),
  // 15.6 = 16 round()

  ///* ощущение температуры*/
  int feelsLike = 0;
  int setFeelsLike() {
    feelsLike = ((current?.feelsLike ?? -kelvin) + kelvin).round();
    return feelsLike;
  }

  //установка дней недели

  final List<String> date = [];
  List<Daily> daily = [];

  void setWeekDay() {
    daily = weatherData?.daily ?? [];
    for (var i = 0; i < daily.length; i++) {
      if (i == 0 && daily.isNotEmpty) {
        date.clear();
      }

      var timeNum = daily[i].dt * 1000;
      var itemDate = DateTime.fromMillisecondsSinceEpoch(timeNum);
      date.add(capitalize(DateFormat('EEE d').format(itemDate)));
    }
  }

  //получение иконок на каждый день
  String setDailyIcons(int index) {
    final String getIcon = '${weatherData?.daily?[index].weather?[0].icon}';
    final String setIcon = '$_weatherIconUrl$getIcon.png';
    return setIcon;
  }

  //получение погоды на каждый день
  int dayTemp = 0;

  int setDailyTemp(int index) {
    dayTemp =
        ((weatherData?.daily?[index].temp?.day ?? -kelvin) + kelvin).round();
    return dayTemp;
  }

  //получение скорости ветра на каждый день

  int dailyWindSpeed = 0;

  int setDailyWindSpeed(int index) {
    dailyWindSpeed = (weatherData?.daily?[index].windSpeed ?? 0).round();
    return dailyWindSpeed;
  }

  //время восхода
  String sunRise = '';

  String setSunRise() {
    final getSunTime =
        (current?.sunrise ?? 0) + (weatherData?.timezoneOffset ?? 0);
    final setSunrise = DateTime.fromMillisecondsSinceEpoch(getSunTime * 1000);
    sunRise = DateFormat('HH:mm a').format(setSunrise);
    return sunRise;
  }

  //время заката

  String sunSet = '';

  String setSunSet() {
    final getSunTime =
        (current?.sunset ?? 0) + (weatherData?.timezoneOffset ?? 0);
    final setSunrise = DateTime.fromMillisecondsSinceEpoch(getSunTime * 1000);
    sunSet = DateFormat('HH:mm a').format(setSunrise);
    return sunSet;
  }

  //Установка заднего фона

  String? currentBg;

  String setBg() {
    int id = current?.weather?[0].id ?? -1;
    if (id == -1 || current?.sunset == null || current?.dt == null) {
      currentBg = AppBg.shinyDay;
    }

    try {
      //
      if (current?.sunset < current?.dt) {
        if (id >= 200 && id <= 531) {
          currentBg = AppBg.rainyNight;
          AppColors.white = const Color(0xFFC6C6C6);
        } else if (id >= 600 && id <= 622) {
          currentBg = AppBg.shinyNight;
        } else if (id >= 701 && id <= 781) {
          currentBg = AppBg.fogNight;
        } else if (id == 800) {
          currentBg = AppBg.shinyNight;
        } else if (id >= 801 && id <= 804) {
          currentBg = AppBg.cloudyNight;
        }
      } else {
        if (id >= 200 && id <= 531) {
          currentBg = AppBg.rainyDay;
          AppColors.white = const Color(0xFF030708);
        } else if (id >= 600 && id <= 622) {
          currentBg = AppBg.shinyDay;
        } else if (id >= 701 && id <= 781) {
          currentBg = AppBg.fogDay;
        } else if (id == 800) {
          currentBg = AppBg.shinyDay;
        } else if (id >= 801 && id <= 804) {
          currentBg = AppBg.cloudyDay;
        }
      }
    } catch (e) {
      return AppBg.shinyDay;
    }
    return currentBg ?? AppBg.shinyDay;
  }

  //добавления в избранное
  Future<void> setFavorite(BuildContext context, {String? cityName}) async {
    var box = Hive.box<FavoriteHistory>(HiveBox.favoriteBox);
    box.add(
      FavoriteHistory(
          cityname: currentCity,
          currentStatus: currentStatus,
          humidity: '${setHumidity()}',
          windSpeed: '${setWindSpeed()}',
          temp: '$currentTemp',
          icon: iconData()),
    ).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColors.favoriteCardColor,
      content:Text('Город $cityName добавлен в избранное') )));
  }
  //уладения из избранного 
  Future<void> deleteFavorite(int index )async{
    var box = Hive.box<FavoriteHistory>(HiveBox.favoriteBox);
    box.delete(index);
  }
}
