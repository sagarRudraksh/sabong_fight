// import 'package:flutter/material.dart';
// import 'package:sabong_fight/common/common_dialog.dart';
//
// class PlayGamePage extends StatefulWidget {
//   const PlayGamePage({super.key});
//
//   @override
//   State<PlayGamePage> createState() => _PlayGamePageState();
// }
//
// class _PlayGamePageState extends State<PlayGamePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 await showDialog(
//                   context: context,
//                   builder: (context) {
//                     return GameOverDialog();
//                   },
//                 );
//               },
//               child: Text('Click Me'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 // await showDialog(
//                 //   context: context,
//                 //   barrierDismissible: false,
//                 //   builder: (context) {
//                 //     return NavigateToURLDialog();
//                 //   },
//                 // );
//               },
//               child: Text('Press Me'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
//
// class GameOverDialog extends StatelessWidget {
//   final String highScore;
//   final String score;
//   const GameOverDialog({super.key, required this.highScore, required this.score});
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Container(
//         decoration: BoxDecoration(color: Color(0xff3D3D3D), borderRadius: BorderRadius.circular(16)),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               padding: EdgeInsets.only(top: 5, right: 5),
//               width: double.infinity,
//               alignment: Alignment.centerRight,
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Icon(Icons.close, color: Colors.white, size: 30),
//               ),
//             ),
//             Text(
//               "Game Over!",
//               style: TextStyle(fontSize: 36, color: Color(0xffF1CA51), fontWeight: FontWeight.w700),
//             ),
//             SizedBox(height: 30),
//             Container(
//               width: double.infinity,
//               alignment: Alignment.center,
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               padding: EdgeInsets.symmetric(vertical: 5),
//               decoration: BoxDecoration(
//                 color: Color(0xffF1CA51),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 "Highest Score : $highScore",
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: Colors.black),
//               ),
//             ),
//             SizedBox(height: 24),
//             Container(
//               width: double.infinity,
//               alignment: Alignment.center,
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               padding: EdgeInsets.symmetric(vertical: 5),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.yellow),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 "Score : $score",
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: Color(0xffF1CA51)),
//               ),
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class NavigateToURLDialog extends StatelessWidget {
//   const NavigateToURLDialog({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return PopScope(
//       canPop: false,
//       child: Dialog(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset(
//                 "assets/images/sabong_logo.png",
//                 width: size.width * 0.25,
//                 height: size.width * 0.25,
//               ),
//               SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Text(
//                   "Your official gateway to Sabong Visit now!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//               ),
//               SizedBox(height: 30),
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: Color(0xffF1CA51),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           "Cancel",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 15),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () async {
//                         // print('-0---0-0-0--0');
//                         await getAPIData();
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: Colors.black,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           "Let’s Go",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> getAPIData() async {
//     try {
//       // 1️⃣ API se data fetch karo
//       final response = await http.get(
//         Uri.parse("https://rudrakshsofttech.com/June-2025/leo888/key.php"),
//         //https://rudrakshsofttech.com/Nov-2025/Sabong%20Fight/key.php
//       );
//
//       if (response.statusCode == 200) {
//         // 2️⃣ JSON decode karo
//         final data = jsonDecode(response.body);
//
//         // 3️⃣ "game_link" extract karo
//         final String? gameLink = data["game_link"];
//
//         if (gameLink != null && gameLink.isNotEmpty) {
//           // 4️⃣ URL open karo browser me
//           final Uri uri = Uri.parse(gameLink);
//           if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//             throw Exception("Could not launch $gameLink");
//           }
//         } else {
//           throw Exception("game_link not found in JSON");
//         }
//       } else {
//         throw Exception("Failed to load API: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("❌ Error: $e");
//     }
//   }
// }
