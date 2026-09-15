import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const double kWideBreakpoint = 700;

void main() => runApp(const DashboardApp());

class DashboardApp extends StatefulWidget {
  const DashboardApp({super.key});

  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: DashboardPage(
        isDark: isDark,
        onThemeChanged: (value) => setState(() => isDark = value),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    required this.isDark,
    required this.onThemeChanged,
    super.key,
  });

  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    // 2. Mengambil referensi tema
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Overview'),
        actions: [
          Row(
            children: [
              Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              const SizedBox(width: 4),
              Semantics(
                label: 'Tombol ganti tema gelap dan terang',
                child: CupertinoSwitch(
                  value: isDark,
                  onChanged: onThemeChanged,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  child: const Icon(Icons.person, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Raihan Daffa Izzuddin',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('NIM: 244107020113', style: theme.textTheme.bodyMedium),
                      Text('Kelas: TI 3E', style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= kWideBreakpoint ? 2 : 1;
                return GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: columns == 1 ? 2.8 : 2.2,
                  children: const [
                    InfoCard(title: 'SKS Ditempuh', value: '45'),
                    InfoCard(title: 'IPK Kumulatif', value: '3.85'),
                    InfoCard(title: 'Kehadiran', value: '98%'),
                    InfoCard(title: 'Tugas Aktif', value: '3'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({required this.title, required this.value, super.key});
  
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Informasi $title adalah $value',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title, 
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                value, 
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}