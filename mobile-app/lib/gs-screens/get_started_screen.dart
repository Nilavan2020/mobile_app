import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/locale_service.dart';
// Language selection removed; back now pops.
import 'gs_sos_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDD671F), Color(0xFFB84A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back button and heading
              Column(
                children: [
                  // Back button at the top
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                      ),
                    ),
                  ),
                  // Heading
                  Consumer<LocaleService>(
                    builder: (context, localeService, child) {
                      final t = (String key) => LocaleService.translate(key, localeService.locale.languageCode);
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: Text(
                            t('welcome'),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Center image
              Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/primary_logo.png',
                      height: 260,
                      width: 260,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Smart Safety Welfare keeps you safer with SOS alerts, missing-person search, and disaster relief coordination—all from one app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),

              // Button at the bottom
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SOSScreen(),
                        ),
                      );
                    },
                      child: Consumer<LocaleService>(
                        builder: (context, localeService, child) {
                          final t = (String key) => LocaleService.translate(key, localeService.locale.languageCode);
                          return Container(
                            width: 300,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              t('get_started'),
                              style: const TextStyle(
                                color: Color(0xFFDD671F),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
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
