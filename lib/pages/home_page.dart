import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/consts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // instance to fetch data in json
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  //stores response of the query like temp,wind snow
  Weather? _weather;
  final _controller = TextEditingController();
  String ccity="Australia";
  // String? ccity;
  String cc = "";
  // if(ccity == null) {
  //     cc="Australia";
  // }
  // else{
  //   cc = ccity;
  // }

  @override
  void initState() {
    super.initState();
    _wf.currentWeatherByCityName(ccity).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // main scaffold
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      //show loading sign in case of no value
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _locationHeader(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            _dateTimeInfo(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            _weatherIcon(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            _currentTemp(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            _extraInfo(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15.0), // Adjust the value as needed
                ),
                hintStyle: const TextStyle(
                  fontFamily: 'Cera Pro',
                  fontSize: 18,
                ),
                hintText: 'What\'s on your mind?',
                suffixIcon: IconButton(
                  onPressed: () {
                    _controller.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
                prefixIcon: IconButton(
                  onPressed: () {
                    ccity = _controller.text;
                    setState(() {});
                  },
                  icon: const Icon(Icons.search, color: Colors.blue),
                  // static const IconData send = IconData(0xe571, fontFamily: 'MaterialIcons', matchTextDirection: true),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _locationHeader() {
    // display location
    // access _weather object , if dont have area name them null("")
    return Text(
      _weather?.areaName ?? "", // if name is not specified
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now =
        _weather!.date!; // from date-time object(_weather) and store in now

    return Column(
      children: [
        Text(
          // show time in specific structure
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              // show actual Day
              DateFormat("EEEE").format(now),
              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "  ${DateFormat("d.m.y").format(now)}",
              style: const TextStyle(
                fontWeight: FontWeight.w400, //boldness
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"))),
        ),
        Text(_weather?.weatherDescription ?? "")
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 90,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _extraInfo() {
    return Container(
        width: MediaQuery.sizeOf(context).width * 1.00,
        height: MediaQuery.sizeOf(context).height * 0.07,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(
          8.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C",
                ),
                Text(
                  "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C",
                ),
              ],
            ),
          ],
        ));
  }
}
