import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sabong_fight/common/common_dialog.dart';
import 'package:sabong_fight/controller/game_controller.dart';
import 'package:sabong_fight/screen/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class StartGamePage extends StatefulWidget {
  const StartGamePage({super.key});

  @override
  State<StartGamePage> createState() => _StartGamePageState();
}

class _StartGamePageState extends State<StartGamePage> {
  // final Uri _url = Uri.parse(
  //   'https:\/\/photovideohide.blogspot.com\/p\/sabong-fight-sabongph-2026.html',
  // );
  final controller = Get.put(GameController());

  // bool _adsFlag = false;
  // String _privacyLink = '';
  // String _gameLink = '';

  /// ✅ GetX reactive variables
  final RxBool adsFlag = false.obs;
  final RxString privacyLink = ''.obs;
  final RxString gameLink = ''.obs;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await NavigateToURLDialog.getAPIData();
    final prefs = await SharedPreferences.getInstance();

    // final adsFlag = prefs.getString('ads_flag') ?? 'off';
    // final privacyLink = prefs.getString('privacy_link') ?? '';
    // final gameLink = prefs.getString('game_link') ?? '';

    // setState(() {
    //   _adsFlag = adsFlag.toLowerCase() == 'on';
    //   _privacyLink = privacyLink;
    //   _gameLink = gameLink;
    // });

    final ads = prefs.getString('ads_flag') ?? 'off';
    final privacy = prefs.getString('privacy_link') ?? '';
    final game = prefs.getString('game_link') ?? '';

    adsFlag.value = ads.toLowerCase() == 'on';
    privacyLink.value = privacy;
    gameLink.value = game;

    // ✅ Show dialog only if ads_flag is true
    if (adsFlag.value && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(.85),
          barrierDismissible: false,
          builder: (context) => const NavigateToURLDialog(),
        );
      });
    }
  }

  /// ✅ Launch Privacy Policy link
  // Future<void> _launchPrivacyLink() async {
  //   final link = privacyLink.value.trim();
  //   if (link.isNotEmpty && await canLaunchUrl(Uri.parse(link))) {
  //     await launchUrl(Uri.parse(link), mode: LaunchMode.platformDefault);
  //   } else {
  //     debugPrint('❌ Could not launch privacy link: $link');
  //   }
  // }
  Future<void> _launchPrivacyLink() async {
    final link = privacyLink.value.trim();
    if (link.isEmpty) {
      debugPrint('⚠️ Empty privacy link');
      return;
    }

    final uri = Uri.tryParse(link);
    if (uri == null) {
      debugPrint('❌ Invalid URI: $link');
      return;
    }

    if (!await launchUrl(
      uri,
      mode: LaunchMode.platformDefault, // ✅ safer for all platforms
    )) {
      debugPrint('❌ Could not launch privacy link: $link');
    }
  }

  /// ✅ Launch Game link
  Future<void> _launchGameLink() async {
    final link = gameLink.value.trim();
    if (link.isNotEmpty && await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link), mode: LaunchMode.platformDefault);
    } else {
      debugPrint('❌ Could not launch game link: $link');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.08),
                    Image.asset(
                      "assets/images/sabong_logo.png",
                      width: size.width * 0.55,
                      height: size.width * 0.55,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Sabong Fight",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      "SabongPH 2026",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.085,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    Obx(() {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 60),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.yellow),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Highest Score : ${controller.highScore.value.toString()}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: size.height * 0.05),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => GameView()));
                      },
                      child: Image.asset(
                        "assets/images/start_game.png",
                        width: size.width * 0.65,
                        // height: size.width * 0.2,
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'To learn more, please review our ',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w400,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _launchPrivacyLink();
                                // _launchUrl();
                                // Action to perform when "Sign up" is tapped
                                debugPrint('Sign up tapped!');
                                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                              },
                          ),
                          TextSpan(text: ' '),
                          WidgetSpan(
                            child: Image.asset(
                              "assets/images/right_arrow.png",
                              height: 10,
                              // width: size.width * 0.55,
                              // height: size.width * 0.55,
                            ),
                          ),
                          TextSpan(
                            text: ' here.',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ✅ Show bottom container only if ads_flag = true
          Obx(
            () => adsFlag.value
                ? SafeArea(
                    child: Container(
                      decoration: BoxDecoration(color: Color(0xffF1CA51)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              'Ad',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Visit our Official Website. Visit now!",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    _launchGameLink();
                                    // if (_gameLink.isNotEmpty) {
                                    //   await launchUrl(Uri.parse(_gameLink), mode: LaunchMode.externalApplication);
                                    // }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Text(
                                      "Let’s Go",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  )
                : Offstage(),
          ),
        ],
      ),
    );
  }

  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(Uri.parse(_privacyLink))) {
  //     throw Exception('Could not launch $_privacyLink');
  //   }
  // }
}
