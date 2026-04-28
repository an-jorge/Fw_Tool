import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'credits_page.dart'; // Importa a página de créditos

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FW Tool',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
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
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  String _mode = '';
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  // =============================
  // DETECÇÃO + CONVERSÃO
  // =============================
  String detectAndConvert(String input) {
    input = input.trim().toUpperCase();

    // HEX → FW
    final isHex = RegExp(r'^[0-9A-F]{4}$').hasMatch(input);

    // FW → HEX
    final isFw = RegExp(r'^R\d{2}A\d{2}V\d{2}$').hasMatch(input);

    if (isHex) {
      _mode = "HEX → FW";
      return hexToFw(input);
    } else if (isFw) {
      _mode = "FW → HEX";
      return fwToHex(input);
    } else {
      throw Exception("Formato inválido");
    }
  }

  String hexToFw(String hex) {
    final byte1 = hex.substring(0, 2);
    final byte2 = hex.substring(2);

    final dec1 = int.parse(byte1, radix: 16);
    final dec2 = int.parse(byte2, radix: 16);

    return "R01A${dec1.toString().padLeft(2, '0')}V${dec2.toString().padLeft(2, '0')}";
  }

  String fwToHex(String fw) {
    final match = RegExp(r'^R\d{2}A(\d{2})V(\d{2})$').firstMatch(fw)!;

    final dec1 = int.parse(match.group(1)!);
    final dec2 = int.parse(match.group(2)!);

    final hex1 = dec1.toRadixString(16).toUpperCase().padLeft(2, '0');
    final hex2 = dec2.toRadixString(16).toUpperCase().padLeft(2, '0');

    return "$hex1$hex2";
  }

  // =============================
  // HISTÓRICO
  // =============================
  Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('history', _history);
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('history') ?? [];
    });
  }

  void addHistory(String entry) {
    setState(() {
      _history.insert(0, entry);
    });
    saveHistory();
  }

  void clearHistory() {
    setState(() => _history.clear());
    saveHistory();
  }

  // =============================
  // AÇÕES
  // =============================
  void convert() {
    try {
      final output = detectAndConvert(_controller.text);

      setState(() {
        _result = output;
      });

      addHistory("${_controller.text.toUpperCase()} → $output");
    } catch (e) {
      setState(() {
        _result = "Erro: $e";
        _mode = "";
      });
    }
  }

  void copyResult() {
    if (_result.isEmpty || _result.startsWith("Erro")) return;

    Clipboard.setData(ClipboardData(text: _result));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Copiado!")));
  }

  // =============================
  // UI
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            // HEADER (mais profissional)
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              accountName: const Text("FW Smart Tool"),
              accountEmail: const Text("Firmware Utility"),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.memory),
              ),
            ),

            // HOME
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // CRÉDITOS
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("Sobre / Créditos"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreditsPage()),
                );
              },
            ),

            const Divider(),

            // LIMPAR HISTÓRICO (atalho útil)
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Limpar histórico"),
              onTap: () {
                Navigator.pop(context);
                clearHistory();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(title: const Text("FW Smart Tool")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Digite o código (HEX ou FW)",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: convert,
                    child: const Text("Converter"),
                  ),

                  const SizedBox(height: 16),

                  if (_result.isNotEmpty)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Resultado ($_mode):",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: copyResult,
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(_result),
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),

                  if (_history.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Histórico:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ..._history.map(
                          (e) => ListTile(title: Text(e), dense: true),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
