import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_page.dart';

class SavePage extends StatefulWidget {
  const SavePage({Key? key}) : super(key: key);

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: Text('Save Weather Detail'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: cityController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Enter City',
              ),
            ),
            TextField(
              controller: districtController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Enter District',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String city = cityController.text;
                String district = districtController.text;
                if (city.isNotEmpty && district.isNotEmpty) {
                  _navigateToWeatherPage(city, district);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter both city and district'),
                    ),
                  );
                }
              },
              child: Text('Save Weather Detail'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showWeatherSearchModal(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToWeatherPage(String city, String district) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WeatherPage(city: city),
      ),
    );
  }

  void _showWeatherSearchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Modify this container as needed for your weather search UI
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Weather Search',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add your logic to perform weather search
                  },
                  child: Text('Search Weather'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
