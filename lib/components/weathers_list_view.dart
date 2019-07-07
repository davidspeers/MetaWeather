import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../utils/constants.dart';
import 'toasts.dart';

class WeathersListView extends StatefulWidget {
  final List<Weather> weathers;

  WeathersListView({Key key, this.weathers}) : super(key: key);

  @override
  _WeathersListViewState createState() => _WeathersListViewState();
}

/// Displays a List of Weather instances with their name, image and date
/// The list can be refreshed by pulling down on the screen, which calls getWeatherForecast
class _WeathersListViewState extends State<WeathersListView> {
  List<Weather> mutableWeathers; // need to be mutable for pull to refresh

  @override
  void initState() {
    super.initState();
    mutableWeathers = widget.weathers;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
          child: ListView.builder(
              itemCount: mutableWeathers.length,
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              itemBuilder: (context, position) {
                String titleText = '${mutableWeathers[position].date}';
                if (position == 0) titleText += " (Today)";
                if (position == 1) titleText += " (Tomorrow)";

                return Column(
                  children: <Widget>[
                    ListTile(
                        title: Text(
                          titleText,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.blueGrey,
                          ),
                        ),
                        subtitle: Text(
                          '${mutableWeathers[position].name}',
                          style: new TextStyle(
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        leading: Image.asset('assets/images/${mutableWeathers[position].abbreviation}.png')
                    ),
                    Divider(height: 5.0),
                  ],
                );
              }),
          onRefresh: _refresh
      )
    );
  }

  /// _refresh is called when the user pulls down on the screen
  Future<void> _refresh() async {
    mutableWeathers =  await getWeatherForecast(BELFAST_WOE_ID);
    // only redraw widget if data is available
    if (mutableWeathers.isNotEmpty) {
      setState(() {});
      blueGreyToast(FORECAST_UPDATED_MSG);
    }
  }

}