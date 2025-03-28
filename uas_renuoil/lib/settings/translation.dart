import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  bool isTranslationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Symbols.arrow_back_ios_new, size: 24),
                ),
              ),

              // Title
              const Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: Text(
                  'Translation',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              // Description
              const Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Text(
                  'Automatically translate the reviews, descriptions, and messages written by buyer and seller to English. Turn this feature off if you\'d like to show the original language.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              const Divider(color: Colors.grey, thickness: 0.5),

              // Toggle switch
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Translation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    CupertinoSwitch(value: isTranslationEnabled, onChanged: (_){
                                  setState(() {
                            isTranslationEnabled = !isTranslationEnabled;
                          });
                        }),
                    // Container(
                    //   width: 60,
                    //   height: 38,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(20),
                    //     color: isTranslationEnabled ? const Color(0xFF8E8E93) : const Color(0xFFD1D1D6),
                    //   ),
                    //   child: Stack(
                    //     children: [
                    //       AnimatedPositioned(
                    //         duration: const Duration(milliseconds: 200),
                    //         curve: Curves.easeInOut,
                    //         left: isTranslationEnabled ? 22 : 0,
                    //         right: isTranslationEnabled ? 0 : 22,
                    //         top: 0,
                    //         bottom: 0,
                    //         child: GestureDetector(
                    //           onTap: () {
                    //             setState(() {
                    //               isTranslationEnabled = !isTranslationEnabled;
                    //             });
                    //           },
                    //           child: Container(
                    //             width: 38,
                    //             height: 38,
                    //             decoration: const BoxDecoration(
                    //               shape: BoxShape.circle,
                    //               color: Colors.white,
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                   color: Colors.black12,
                    //                   blurRadius: 4,
                    //                   offset: Offset(0, 2),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),

              const Divider(color: Colors.grey, thickness: 0.5),
            ],
          ),
        ),
      ),
    );
  }
}