import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_weather_example_flutter/src/features/auth/email_register.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/savepage.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(
      child: MaterialApp(
          debugShowCheckedModeBanner: false, home: EmailRegister())));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // Controllers for text fields
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          throw PlatformException(
            code: 'PERMISSION_DENIED',
            message: 'Location permission denied',
          );
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String city = placemarks.first.locality ?? '';

      setState(() {
        cityController.text = city;
      });
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyleWithShadow = TextStyle(
      color: Colors.white,
      shadows: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.25),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 0.5),
        )
      ],
    );

    // Check if city is null
    Widget currentPage;
    if (cityController.text != null && cityController.text.isNotEmpty) {
      currentPage = WeatherPage(city: cityController.text);
    } else {
      currentPage = Center(
          child: SizedBox(
              height: 50, width: 50, child: CircularProgressIndicator()));
    }

    return MaterialApp(
      title: 'Flutter Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: TextTheme(
          displayLarge: textStyleWithShadow,
          displayMedium: textStyleWithShadow,
          displaySmall: textStyleWithShadow,
          headlineMedium: textStyleWithShadow,
          headlineSmall: textStyleWithShadow,
          titleMedium: const TextStyle(color: Colors.white),
          bodyMedium: const TextStyle(color: Colors.white),
          bodyLarge: const TextStyle(color: Colors.white),
          bodySmall: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ),
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            currentPage,
            SavePage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: 'Weather',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.save),
              label: 'Save Forecast',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            });
          },
        ),
      ),
    );
  }
}
