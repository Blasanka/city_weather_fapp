import 'package:flutter/material.dart';
import 'package:forecast_weather/src/presentation/providers/city_weather_provider.dart';
import 'package:provider/provider.dart';

class AddCityDialog extends StatefulWidget {
  const AddCityDialog({super.key});

  @override
  State<AddCityDialog> createState() => _AddCityDialogState();
}

class _AddCityDialogState extends State<AddCityDialog> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CityWeatherProvider>();
    return AlertDialog(
      title: const Text('Add City'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _controller, decoration: InputDecoration(labelText: 'City name', errorText: _error)),
          if (_loading) const Padding(padding: EdgeInsets.only(top: 12), child: CircularProgressIndicator())
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(
          onPressed: _loading ? null : () async {
            final name = _controller.text.trim();
            if (name.isEmpty) {
              setState(() => _error = 'Enter a city name');
              return;
            }
            setState(() { _loading = true; _error = null; });
            try {
              await provider.addCity(name);
              if (mounted) Navigator.of(context).pop();
            } catch (e) {
              setState(() { _error = 'Could not find city or network error'; });
            } finally {
              if (mounted) setState(() { _loading = false; });
            }
          },
          child: const Text('Add'),
        )
      ],
    );
  }
}