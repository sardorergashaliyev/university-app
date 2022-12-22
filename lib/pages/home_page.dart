import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic data;
  bool isLoading = true;

  Future<void> getInformation() async {
    isLoading = true;
    setState(() {});
    final url = Uri.parse('http://universities.hipolabs.com/search?country=Uzbekistan');
    final res = await http.get(url);
    data = jsonDecode(res.body);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.blueGrey),
                  child: Column(
                    children: [
                      Text(
                        data[index]['name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () async {
                          final launchUri =
                              Uri.parse(data[index]['web_pages']?[0] ?? '');
                          await url_launcher.launchUrl(launchUri,
                              mode: LaunchMode.inAppWebView);
                        },
                        child: Text(data[index]['web_pages']?[0] ?? ''),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () async {
                          final Uri launchUri =
                              Uri(scheme: 'tel', path: '+17829123847');
                          await launchUrl(launchUri);
                        },
                        child: const Text('number'),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
