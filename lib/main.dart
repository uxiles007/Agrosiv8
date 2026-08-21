import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const Agrosiv8App());

class Agrosiv8App extends StatelessWidget {
  const Agrosiv8App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Агросів8',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF4F7F4),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool running = false;
  int total = 0;
  Timer? timer;

  final rows = List<int>.generate(8, (_) => 0);
  final active = List<bool>.generate(8, (_) => false);

  void toggleRunning() {
    setState(() => running = !running);
    timer?.cancel();

    if (running) {
      timer = Timer.periodic(const Duration(seconds: 2), (_) {
        setState(() {
          total++;
          final row = total % 8;
          rows[row]++;

          for (var i = 0; i < 8; i++) {
            active[i] = i == row;
          }
        });
      });
    } else {
      for (var i = 0; i < 8; i++) {
        active[i] = false;
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Агросів8',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'КОНТРОЛЬ ВИСІВУ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    running ? 'Система працює' : 'Система зупинена',
                    style: TextStyle(
                      color: running
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: toggleRunning,
                      icon: Icon(
                        running ? Icons.stop : Icons.play_arrow,
                      ),
                      label: Text(
                        running ? 'ЗУПИНИТИ' : 'ЗАПУСТИТИ',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat('Рядів', '8'),
                  _stat('Імпульсів', '$total'),
                  _stat('Статус', running ? 'ON' : 'OFF'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'РЯДКИ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          ...List.generate(8, (i) {
            final ok = active[i];

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      ok ? Colors.green : Colors.grey.shade300,
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: ok ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text('Ряд ${i + 1}'),
                subtitle: Text('Імпульсів: ${rows[i]}'),
                trailing: Icon(
                  ok
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: ok ? Colors.green : Colors.grey,
                ),
              ),
            );
          }),

          const SizedBox(height: 8),

          const Text(
            'Тестова версія. Наступним етапом підключимо ESP32 та реальні датчики 8 рядків.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _stat(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}
