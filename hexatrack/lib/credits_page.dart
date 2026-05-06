import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

const List<Map<String, dynamic>> changelog = [
  {
    "version": "1.1.0",
    "date": "2026-05-06",
    "changes": [
      "Adicionado menu lateral (Drawer)",
      "Página de créditos com versão automática",
      "Melhoria na experiência do utilizador (UX)",
    ],
  },
  {
    "version": "1.0.0",
    "date": "2026-05-01",
    "changes": [
      "Lançamento inicial",
      "Conversão HEX ↔ Firmware",
      "Histórico com armazenamento local",
    ],
  },
];

class CreditsPage extends StatefulWidget {
  const CreditsPage({super.key});

  @override
  State<CreditsPage> createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  String version = '';

  @override
  void initState() {
    super.initState();
    loadVersion();
  }

  Future<void> loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      version = "${info.version} (${info.buildNumber})";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sobre")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Icon(Icons.memory, size: 60),
                    const SizedBox(height: 16),

                    const Text(
                      "FW Smart Tool",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text("Versão: ${version.isEmpty ? '...' : version}"),

                    const Divider(height: 30),

                    const Text(
                      "FW Smart Tool é uma ferramenta de conversão de firmware Queclink no formato(R01AxxVxx) para o formato HEX (2 bytes), integrando à análise técnica Quatenus.",
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Changelog",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 10),

                    ...changelog.map((entry) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "v${entry["version"]} • ${entry["date"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              ...List.generate(
                                entry["changes"].length,
                                (i) => Text("• ${entry["changes"][i]}"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 20),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Autor",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 8),
                    const ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Antonio Jorge"),
                      subtitle: Text("Desenvolvimento"),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "2026",
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
