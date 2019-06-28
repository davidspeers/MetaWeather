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