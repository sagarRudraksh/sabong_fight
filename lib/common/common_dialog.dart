import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class GameOverDialog extends StatelessWidget {
  final String highScore;
  final String score;
  const GameOverDialog({super.key, required this.highScore, required this.score});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff3D3D3D),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),
            const Text(
              "Game Over!",
              style: TextStyle(fontSize: 36, color: Color(0xffF1CA51), fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xffF1CA51),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Highest Score : $highScore",
                style: const TextStyle(fontSize: 28, color: Colors.black),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Score : $score",
                style: const TextStyle(fontSize: 28, color: Color(0xffF1CA51)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class NavigateToURLDialog extends StatelessWidget {
  const NavigateToURLDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Dialog(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/sabong_logo.png",
                width: size.width * 0.25,
                height: size.width * 0.25,
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Your official gateway to Sabong. Visit now!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xffF1CA51),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "Cancel",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async => await _launchGameLink(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "Let’s Go",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Launch URL from stored SharedPreferences
  static Future<void> _launchGameLink() async {
    final prefs = await SharedPreferences.getInstance();
    final String? gameLink = prefs.getString('game_link');

    if (gameLink != null && gameLink.isNotEmpty) {
      final Uri uri = Uri.parse(gameLink);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception("Could not launch $gameLink");
      }
    } else {
      debugPrint("⚠️ game_link not found");
    }
  }

  /// ✅ Fetch and store API data
  static Future<void> getAPIData() async {
    try {
      final response = await http.get(
        Uri.parse("https://rudrakshsofttech.com/Nov-2025/Sabong%20Fight/key.php"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('ads_flag', data['ads_flag'] ?? 'off');
        await prefs.setString('privacy_link', data['privacy_link'] ?? '');
        await prefs.setString('game_link', data['game_link'] ?? '');
      } else {
        throw Exception("Failed to load API");
      }
    } catch (e) {
      debugPrint("❌ Error in getAPIData: $e");
    }
  }
}
