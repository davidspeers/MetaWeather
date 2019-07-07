import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta_weather/models/weather.dart';
import 'package:meta_weather/utils/constants.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

// Create a mocked http.Client
// https://flutter.dev/docs/cookbook/testing/unit/mocking
class MockClient extends Mock implements http.Client {}

main() {
  group('getWeatherForecast', () {

    // Need to handle what is returned when connectivity plugin is called
    // https://stackoverflow.com/questions/44357053/flutter-test-missingpluginexception/44360235
    const MethodChannel('plugins.flutter.io/connectivity')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      // 'check' was found by printing methodCall.method
      // 'wifi' was found with Command-Click checkConnectivity method, then _parseConnectivityResult
      if (methodCall.method == 'check') {
        return 'wifi';
      }
      return null;
    });

    const MethodChannel('PonnamKarthik/fluttertoast')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      return null;
    });

    test('returns an empty list if the http call completes with a 404 error', () async {
      final client = MockClient();

      when(client.get(META_WEATHER_ADDRESS+BELFAST_WOE_ID))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
          await getWeatherForecast(client, BELFAST_WOE_ID),
          equals([])
      );
    });

    test('returns two Weather instances if server returns two objects in JSON array', () async {
      final client = MockClient();

      String jsonResponse = '{"consolidated_weather":['
            '{"weather_state_name":"Heavy Cloud","weather_state_abbr":"hc","applicable_date":"2019-07-07"},'
            '{"weather_state_name":"Light Rain","weather_state_abbr":"lr","applicable_date":"2019-07-08"}'
          ']}';
      when(client.get(META_WEATHER_ADDRESS+BELFAST_WOE_ID))
          .thenAnswer((_) async => http.Response(jsonResponse, 200));

      expect(
          await getWeatherForecast(client, BELFAST_WOE_ID),
          equals([
            Weather(name: "Heavy Cloud", abbreviation: "hc", date: "7 Jul"),
            Weather(name: "Light Rain", abbreviation: "lr", date: "8 Jul"),
          ])
      );
    });
  });
}

