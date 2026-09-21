import 'package:flutter/material.dart';

void main() {
  runApp(const IMCApp());
}

class IMCApp extends StatelessWidget {
  const IMCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator IMC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const IMCCalculatorPage(),
    );
  }
}

class IMCCalculatorPage extends StatefulWidget {
  const IMCCalculatorPage({super.key});

  @override
  State<IMCCalculatorPage> createState() => _IMCCalculatorPageState();
}

class _IMCCalculatorPageState extends State<IMCCalculatorPage> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String result = '';
  String category = '';

  void calculateBMI() {
    final double? weight =
    double.tryParse(weightController.text.replaceAll(',', '.'));

    final double? heightCm =
    double.tryParse(heightController.text.replaceAll(',', '.'));

    if (weight == null || heightCm == null) {
      setState(() {
        result = 'Introduceți valori numerice valide.';
        category = '';
      });
      return;
    }

    if (weight <= 0 || heightCm <= 0) {
      setState(() {
        result = 'Greutatea și înălțimea trebuie să fie mai mari decât 0.';
        category = '';
      });
      return;
    }

    final double heightM = heightCm / 100;
    final double bmi = weight / (heightM * heightM);

    String bmiCategory;

    if (bmi < 18.5) {
      bmiCategory = 'Subponderal';
    } else if (bmi < 25) {
      bmiCategory = 'Normal';
    } else if (bmi < 30) {
      bmiCategory = 'Supraponderal';
    } else {
      bmiCategory = 'Obezitate';
    }

    setState(() {
      result = 'IMC: ${bmi.toStringAsFixed(2)}';
      category = 'Categoria: $bmiCategory';
    });
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator IMC'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.monitor_weight,
              size: 80,
            ),

            const SizedBox(height: 20),

            const Text(
              'Calculați indicele de masă corporală',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Greutate (kg)',
                hintText: 'Ex: 70',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monitor_weight),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: heightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Înălțime (cm)',
                hintText: 'Ex: 175',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.height),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: calculateBMI,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'CALCULEAZĂ IMC',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),

            const SizedBox(height: 30),

            if (result.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        result,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        category,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
