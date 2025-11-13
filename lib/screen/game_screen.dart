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
          appBar: AppBar(
            backgroundColor: Color(0xffF1CA51),
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
                  color: Color(0xff2A2A2A),
                  child: Stack(
                    children: [
                      Obx(
                        () => controller.anyEggBroken.value
                            ? const SizedBox()
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
                      Obx(
                        () => Stack(
                          children: controller.eggs.map((egg) {
                            double x = egg['x'];
                            bool broken = egg['broken'];
                            return AnimatedContainer(
                              alignment: Alignment(x, 1),
                              duration: const Duration(milliseconds: 0),
                              child: broken
                                  ? Offstage()
                                  : Icon(Icons.egg, size: 40, color: Colors.white),
                            );
                          }).toList(),
                        ),
                      ),
                      Obx(
                        () => controller.gameStarted.value
                            ? const Offstage()
                            : const Center(
                                child: Text(
                                  "TAP TO START",
                                  style: TextStyle(fontSize: 24, color: Colors.white),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(height: 15, color: Colors.green),
              SafeArea(
                child: Container(
                  height: 110,
                  color: Color(0xffF1CA51),
                  child: const Center(
                    child: Text(
                      "🐔 Avoid breaking eggs!",
                      style: TextStyle(fontSize: 26, color: Color(0xff2A2A2A)),
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
