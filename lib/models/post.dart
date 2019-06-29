import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import '../utils/constants.dart';
import '../components/toasts.dart';

/// Use the factory constructor fromJson to extract;
/// the weather name, weather abbreviation, and date from the JSON response.
class Post {
  final String weatherStateName;
  final String weatherStateAbbr;
  final String date;

  Post({this.weatherStateName, this.weatherStateAbbr, this.date});

  factory Post.fromJson(Map<String, dynamic> json) {

    /// date will be in the form YYYY-MM-DD
    /// this function converts the date to a more readable format
    /// e.g. converts 2019-01-01 to 1 Jan
    String dateToString(String date) {
      List<String> yearMonthDay = date.split('-');

      String day = yearMonthDay[2];
      if (day[0] == '0') day.substring(1);

      String string = "$day ";

      switch (yearMonthDay[1]) {
        case '01':
          string += 'Jan';
          break;
        case '02':
          string += 'Feb';
          break;
        case '03':
          string += 'Mar';
          break;
        case '04':
          string += 'Apr';
          break;
        case '05':
          string += 'May';
          break;
        case '06':
          string += 'Jun';
          break;
        case '07':
          string += 'Jul';
          break;
        case '08':
          string += 'Aug';
          break;
        case '09':
          string += 'Sep';
          break;
        case '10':
          string += 'Oct';
          break;
        case '11':
          string += 'Nov';
          break;
        case '12':
          string += 'Dec';
          break;
      }

      return string;
    }

    return Post(
      weatherStateName: json['weather_state_name'] as String,
      weatherStateAbbr: json['weather_state_abbr'] as String,
      date: dateToString(json['applicable_date'] as String)
    );
  }
}

/// Fetch a list of Posts using the MetaWeather API
/// If Connected to Internet:
///   Returns 6 Posts: 1 for today and 5 for the next 5 days
/// If not connected OR no response OR an invalid response:
///   Returns an empty list and shows Toast with error to user.
Future<List<Post>> fetchPosts(String woeid) async {
  List<Post> posts = [];
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    blueGreyToast(NO_INTERNET_MSG);
  } else {
    try {
      final jsonResponse = await http.Client().get(META_WEATHER_ADDRESS + woeid);
      posts = createPosts(jsonResponse.body);
    } on SocketException {
      blueGreyToast(SOCKET_EXCEPTION_MSG);
    } on NoSuchMethodError {
      blueGreyToast(DATA_HANDLING_ERROR_MSG);
    } on FormatException {
      blueGreyToast(DATA_HANDLING_ERROR_MSG);
    } catch (e) {
      // TODO: Handle other possible exceptions
      blueGreyToast(e.toString());
    }
  }
  return posts;
}

/// Converts a MetaWeather JSON response to a List of Post instances
List<Post> createPosts(String responseBody) {
  List<Post> posts = new List<Post>();

  var decodedJson = json.decode(responseBody);
  List weatherForecast = decodedJson["consolidated_weather"];

  weatherForecast.forEach((day) {
    posts.add(Post.fromJson(day));
  });

  return posts;
}