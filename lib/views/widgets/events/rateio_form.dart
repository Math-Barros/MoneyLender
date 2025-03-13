import 'package:flutter/material.dart';

class RateioForm extends StatefulWidget {
  final Function(double, List<String>) onCreate;

  const RateioForm({super.key, required this.onCreate});

  @override
  State<RateioForm> createState() => _RateioFormState();
}

class _RateioFormState extends State<RateioForm> {
  final TextEditingController _valueController = TextEditingController();
  final List<String> _selectedFriends = [];

  void _addRateio() {
    final value = double.tryParse(_valueController.text) ?? 0.0;
    widget.onCreate(value, _selectedFriends);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _valueController,
          decoration: const InputDecoration(labelText: 'Valor do Rateio'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addRateio,
          child: const Text('Criar Rateio'),
        ),
      ],
    );
  }
}
