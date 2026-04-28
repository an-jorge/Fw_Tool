import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      "É uma ferramenta de código aberto, gratuita e sem anúncios.",
                      textAlign: TextAlign.center,
                    ),

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

                    const Text("2026", style: TextStyle(fontSize: 12)),
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
