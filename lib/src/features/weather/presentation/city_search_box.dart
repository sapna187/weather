import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';

class CitySearchBox extends ConsumerStatefulWidget {
  final String city; // Added required city parameter

  const CitySearchBox({Key? key, required this.city})
      : super(key: key); // Updated constructor

  @override
  ConsumerState<CitySearchBox> createState() =>
      _CitySearchRowState(city); // Pass city parameter to state
}

class _CitySearchRowState extends ConsumerState<CitySearchBox> {
  static const _radius = 30.0;

  late final TextEditingController
      _searchController; // Initialize _searchController late

  _CitySearchRowState(String city) {
    _searchController = TextEditingController(
        text: city); // Initialize _searchController with provided city
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // circular radius
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Text(
              "Click on search button to see the waether at your current location"),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: _radius * 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(_radius),
                          bottomLeft: Radius.circular(_radius),
                        ),
                      ),
                    ),
                    onSubmitted: (value) =>
                        ref.read(cityProvider.notifier).state = value,
                  ),
                ),
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.accentColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(_radius),
                        bottomRight: Radius.circular(_radius),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text('search',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    ref.read(cityProvider.notifier).state =
                        _searchController.text;
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
