import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sabong_fight/common/common_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameController extends GetxController {
  var dinoY = 1.0.obs;
  var score = 0.obs;
  var highScore = 0.obs;
  var gameStarted = false.obs;
  var isPrefsLoaded = false.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  var eggs = <Map<String, dynamic>>[].obs;

  var anyEggBroken = false.obs;

  SharedPreferences? _prefs;

  // Physics
  double time = 0;
  double height = 0;
  double initialHeight = 1;
  Timer? gameTimer;
  final _random = Random();

  // Speed of egg movement
  final double eggSpeed = 0.03; // Normal speed

  // @override
  // void onInit() {
  //   super.onInit();
  //   _initPrefs();
  // }

  @override
  void onReady() {
    super.onReady();
    initPrefs(); // run after Flutter binding and UI are ready
  }

  /// ✅ Initialize SharedPreferences and load stored high score
  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final savedScore = _prefs?.getInt('highScore') ?? 0;
    highScore.value = savedScore;
    isPrefsLoaded.value = true;
    debugPrint('🎯 Loaded high score: $savedScore');
  }

  /// ✅ Get prefs safely when needed
  Future<SharedPreferences> get _safePrefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// ✅ Save high score persistently
  Future<void> _saveHighScore(int newScore) async {
    final prefs = await _safePrefs; // ensures ready
    await prefs.setInt('highScore', newScore);
    debugPrint('💾 Saved new high score: $newScore');
    // await _prefs?.setInt('highScore', newScore);
    // debugPrint('💾 Saved new high score: $newScore');
  }

  // ✅ Function to load high score from SharedPreferences
  // Future<void> loadHighScore() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   highScore.value = prefs.getInt('highScore') ?? 0;
  // }
  //
  // // ✅ Function to save high score
  // Future<void> saveHighScore(int newScore) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('highScore', newScore);
  // }

  void startGame() {
    if (gameStarted.value) return;

    resetGame();
    gameStarted.value = true;

    gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      // Jump physics
      time += 0.03;
      height = -4.9 * time * time + 2.8 * time;
      dinoY.value = initialHeight - height;
      if (dinoY.value > 1) dinoY.value = 1;

      // Move all eggs
      for (var egg in eggs) {
        egg['x'] -= eggSpeed;
      }

      // Remove off-screen eggs
      eggs.removeWhere((egg) => egg['x'] < -1.5);

      // Maintain between 1–2 eggs
      while (eggs.length < _random.nextInt(2) + 1) {
        double lastX = eggs.isEmpty ? 0.3 : eggs.last['x'];

        // Calculate random gap (min 100px)
        double minGapPx = (100 + _random.nextInt(100).toDouble()); // between 100–200px
        double screenWidth = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
        double gap = (minGapPx / screenWidth) * 2; // convert to alignment units (-1 to 1)

        eggs.add({'x': 1.2 + gap + lastX, 'broken': false});
      }

      // 🚨 Collision detection
      for (var egg in eggs) {
        double x = egg['x'];

        // Check horizontal overlap and if cock is on ground
        if (x < 0.05 && x > -0.15 && dinoY.value > 0.9 && !egg['broken']) {
          egg['broken'] = true; // break the egg
          anyEggBroken.value = true;

          // ❌ Stop game immediately
          gameOver();
          return; // Exit loop after collision
        }
      }

      // Increment score as game continues
      score.value++;
      if (score.value > highScore.value) {
        highScore.value = score.value;
        _saveHighScore(highScore.value);
      }
    });
  }

  void jump() {
    if (dinoY.value > 0.9) {
      time = 0;
      initialHeight = dinoY.value;
    }
  }

  void gameOver() async {
    gameTimer?.cancel();
    gameStarted.value = false;
    await _audioPlayer.play(AssetSource('sounds/egg_break_sound.mp3'));

    // Optional: stop after 2 seconds
    Future.delayed(const Duration(seconds: 4), () {
      _audioPlayer.stop();
    });

    // Delay dialog slightly so it can appear after frame ends
    Future.delayed(const Duration(milliseconds: 100), () async {
      await showDialog(
        context: Get.context!,
        barrierColor: Colors.black.withOpacity(.8),
        builder: (context) {
          return GameOverDialog(highScore: highScore.value.toString(), score: score.value.toString());
        },
      );
    });
  }

  void resetGame() {
    eggs.clear();
    eggs.add({'x': 1.0, 'broken': false});
    dinoY.value = 1;
    time = 0;
    height = 0;
    score.value = 0;
    anyEggBroken.value = false;
  }

  @override
  void onClose() {
    gameTimer?.cancel();
    super.onClose();
  }
}
