import 'package:flutter/material.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({Key? key}) : super(key: key);

  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _controller = TextEditingController();
  double _result = 0;

  void _convert() {
    setState(() {
      double input = double.tryParse(_controller.text) ?? 0;
      _result = input * 0.621371; // conversion factor for km to miles
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kilometer to Mile Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter distance in kilometers',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Convert'),
            ),
            SizedBox(height: 20),
            Text(
              'Distance in miles: $_result',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}