import 'package:flutter/material.dart';

void main() => runApp(const TempConverterApp());

class TempConverterApp extends StatelessWidget {
  const TempConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // 1. THEME LOGIC
      theme: ThemeData(primarySwatch: Colors.orange, brightness: Brightness.light),
      darkTheme: ThemeData(primarySwatch: Colors.deepOrange, brightness: Brightness.dark),
      themeMode: ThemeMode.system, 
      home: const TemperatureConverter(),
    );
  }
}

class TemperatureConverter extends StatefulWidget {
  const TemperatureConverter({super.key});

  @override
  State<TemperatureConverter> createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  final TextEditingController _celsiusController = TextEditingController();
  final TextEditingController _fahrenheitController = TextEditingController();
  String? _celsiusError;
  String? _fahrenheitError;

  // 2. ANIMATION LOGIC: We'll use AnimatedSwitcher for the result text
  void _updateFahrenheit(String value) {
    setState(() {
      if (value.isEmpty) {
        _fahrenheitController.clear();
        _celsiusError = null;
        return;
      }
      double? celsius = double.tryParse(value);
      if (celsius != null) {
        _celsiusError = null;
        _fahrenheitController.text = (celsius * 9 / 5 + 32).toStringAsFixed(1);
      } else {
        _celsiusError = "Invalid number";
        _fahrenheitController.clear();
      }
    });
  }

  void _updateCelsius(String value) {
    setState(() {
      if (value.isEmpty) {
        _celsiusController.clear();
        _fahrenheitError = null;
        return;
      }
      double? fahrenheit = double.tryParse(value);
      if (fahrenheit != null) {
        _fahrenheitError = null;
        _celsiusController.text = ((fahrenheit - 32) * 5 / 9).toStringAsFixed(1);
      } else {
        _fahrenheitError = "Invalid number";
        _celsiusController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Temp Converter"), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 3. ADAPTIVE UI: Using AnimatedContainer for smooth spacing
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: TextField(
                  controller: _celsiusController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: "Celsius",
                    suffixText: "°C",
                    errorText: _celsiusError,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: _updateFahrenheit,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Icon(Icons.compare_arrows, size: 40, color: Colors.orange),
              ),
              TextField(
                controller: _fahrenheitController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: "Fahrenheit",
                  suffixText: "°F",
                  errorText: _fahrenheitError,
                  border: const OutlineInputBorder(),
                ),
                onChanged: _updateCelsius,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _celsiusController.clear();
            _fahrenheitController.clear();
            _celsiusError = null;
            _fahrenheitError = null;
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}