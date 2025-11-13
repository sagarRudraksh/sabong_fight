import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sabong_fight/controller/game_controller.dart';

class GameView extends StatelessWidget {
  GameView({super.key});

  final controller = Get.put(GameController());

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.logicalKey.keyLabel == ' ') {
          controller.gameStarted.value ? controller.jump() : controller.startGame();
        }
      },
      child: GestureDetector(
        onTap: () => controller.gameStarted.value ? controller.jump() : controller.startGame(),
        child: Scaffold(
          backgroundColor: Colors.blue[100],
          appBar: AppBar(
            backgroundColor: Colors.blue[100],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    "High Score: ${controller.highScore.value}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Obx(
                  () => Text(
                    "Score: ${controller.score.value}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.blue[200],
                  child: Stack(
                    children: [
                      // Dino (now chicken)
                      Obx(
                        () => controller.anyEggBroken.value
                            ? const SizedBox() // ✅ Hide when egg is broken
                            : AnimatedContainer(
                                alignment: Alignment(0, controller.dinoY.value),
                                duration: const Duration(milliseconds: 0),
                                child: SizedBox(
                                  height: 60,
                                  width: 80,
                                  child: Lottie.asset('assets/images/cock.json'),
                                ),
                              ),
                      ),

                      // Eggs (obstacles)
                      Obx(
                        () => Stack(
                          children: controller.eggs.map((egg) {
                            double x = egg['x'];
                            bool broken = egg['broken'];
                            return AnimatedContainer(
                              alignment: Alignment(x, 1),
                              duration: const Duration(milliseconds: 0),
                              child: broken
                                  ? SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Lottie.asset('assets/images/break_egg.json'),
                                    )
                                  : Icon(Icons.egg, size: 40, color: Colors.white),
                            );
                          }).toList(),
                        ),
                      ),

                      // Game start text
                      Obx(
                        () => controller.gameStarted.value
                            ? const SizedBox()
                            : const Center(
                                child: Text(
                                  "TAP TO START",
                                  style: TextStyle(fontSize: 24, color: Colors.black),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Ground
              Container(height: 15, color: Colors.green),

              // Bottom Decoration (optional)
              SafeArea(
                child: Container(
                  height: 110,
                  color: Colors.brown[300],
                  child: const Center(
                    child: Text(
                      "🐔 Avoid breaking eggs!",
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
